import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../database/app_database.dart';
import '../../database/tables.dart';
import '../../models/app_models.dart';
import '../../providers/attendance_providers.dart';
import '../shared/app_snackbar.dart';
import 'widgets/student_attendance_row.dart';
import 'widgets/session_info_header.dart';
import 'widgets/save_attendance_button.dart';

class TakeAttendanceScreen extends ConsumerStatefulWidget {
  final CalendarioBitacora session;
  final String groupCode;
  final String moduleName;
  final int sessionNumber;

  const TakeAttendanceScreen({
    super.key,
    required this.session,
    required this.groupCode,
    required this.moduleName,
    required this.sessionNumber,
  });

  @override
  ConsumerState<TakeAttendanceScreen> createState() => _TakeAttendanceScreenState();
}

class _TakeAttendanceScreenState extends ConsumerState<TakeAttendanceScreen> {
  // Map de studentId → AttendanceRecord para preservar estados al actualizar la lista
  final Map<int, AttendanceRecord> _recordsMap = {};
  bool _initialLoadDone = false;
  bool _isSaving = false;

  /// Carga las asistencias ya guardadas en DB para la sesión y las mezcla
  /// con los estudiantes activos actuales del grupo.
  Future<void> _loadSavedAttendances(List<Student> students) async {
    final savedAttendances = await ref
        .read(attendanceControllerProvider)
        .getAttendanceListForSession(widget.session.id, widget.groupCode);

    // Construir un mapa de asistencias ya guardadas por studentId
    final savedMap = {for (var r in savedAttendances) r.student.id: r};

    setState(() {
      for (final student in students) {
        if (!_recordsMap.containsKey(student.id)) {
          // Estudiante nuevo: tomar su registro guardado o crear uno vacío
          _recordsMap[student.id] = savedMap[student.id] ??
              AttendanceRecord(student: student, attendance: null);
        }
        // Si ya existe en _recordsMap, conservar el estado que el docente eligió
      }
      // Eliminar estudiantes que ya no están activos en el grupo
      _recordsMap.removeWhere((id, _) => !students.any((s) => s.id == id));
      _initialLoadDone = true;
    });
  }

  List<AttendanceRecord> get _records {
    final list = _recordsMap.values.toList();
    list.sort((a, b) => a.student.apellidos.compareTo(b.student.apellidos));
    return list;
  }

  Future<void> _save() async {
    final records = _records;
    if (records.isEmpty) {
      AppSnackbar.showWarning(
        context,
        'No hay estudiantes',
        description: 'No se puede guardar la asistencia porque no hay estudiantes en este grupo.',
      );
      return;
    }
    setState(() => _isSaving = true);
    try {
      await ref.read(attendanceControllerProvider).saveAttendances(widget.session.id, records);
      if (mounted) {
        AppSnackbar.showSuccess(context, 'Asistencia guardada correctamente.');
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        AppSnackbar.showError(context, 'Error al guardar', description: e.toString());
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _markAllAs(EstadoAsistencia status) {
    setState(() {
      for (final id in _recordsMap.keys) {
        _recordsMap[id]!.currentStatus = status;
        if (status != EstadoAsistencia.justificado) {
          _recordsMap[id]!.justificacionDetalle = null;
          _recordsMap[id]!.rutasEvidencia = [];
          _recordsMap[id]!.fechaJustificacion = null;
        }
      }
    });
  }

  Map<EstadoAsistencia, int> _getStats() {
    final stats = {
      EstadoAsistencia.presente: 0,
      EstadoAsistencia.tardanza: 0,
      EstadoAsistencia.ausente: 0,
      EstadoAsistencia.justificado: 0,
    };
    for (final r in _recordsMap.values) {
      final status = r.currentStatus ?? EstadoAsistencia.presente;
      stats[status] = (stats[status] ?? 0) + 1;
    }
    return stats;
  }

  @override
  Widget build(BuildContext context) {
    // Escuchar el stream reactivo de estudiantes
    final studentsAsync = ref.watch(activeStudentsByGroupProvider(widget.groupCode));

    // Cuando llega una nueva lista de estudiantes, sincronizar _recordsMap
    studentsAsync.whenData((students) {
      if (!_initialLoadDone) {
        // Primera vez: cargar asistencias guardadas del DB
        _loadSavedAttendances(students);
      } else {
        // Actualizaciones posteriores: agregar nuevos estudiantes y quitar los eliminados
        bool changed = false;
        for (final student in students) {
          if (!_recordsMap.containsKey(student.id)) {
            _recordsMap[student.id] = AttendanceRecord(student: student, attendance: null);
            changed = true;
          }
        }
        final activeIds = students.map((s) => s.id).toSet();
        final toRemove = _recordsMap.keys.where((id) => !activeIds.contains(id)).toList();
        if (toRemove.isNotEmpty) {
          for (final id in toRemove) {
            _recordsMap.remove(id);
          }
          changed = true;
        }
        if (changed && mounted) setState(() {});
      }
    });

    final stats = _getStats();
    final records = _records;
    final hasStudents = records.isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          'Sesión ${widget.sessionNumber} - Grupo ${widget.groupCode}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Outfit'),
        ),
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        actions: [
          PopupMenuButton<EstadoAsistencia>(
            icon: const Icon(LucideIcons.checkSquare),
            tooltip: 'Marcar a todos',
            onSelected: _markAllAs,
            itemBuilder: (context) => const [
              PopupMenuItem(value: EstadoAsistencia.presente, child: Text('Marcar todos Presentes')),
              PopupMenuItem(value: EstadoAsistencia.ausente, child: Text('Marcar todos Ausentes')),
            ],
          ),
        ],
      ),
      body: studentsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (_) {
          if (!_initialLoadDone) {
            return const Center(child: CircularProgressIndicator());
          }
          return Column(
            children: [
              SessionInfoHeader(moduleName: widget.moduleName, session: widget.session),
              _buildStatsSummaryBanner(stats),
              Expanded(
                child: !hasStudents
                    ? _buildEmptyState()
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: records.length,
                        separatorBuilder: (_, _) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final record = records[index];
                          return StudentAttendanceRow(
                            record: record,
                            onStatusChanged: (status) {
                              setState(() {
                                _recordsMap[record.student.id]!.currentStatus = status;
                              });
                            },
                            onJustificationChanged: (detalle, evidencias) {
                              setState(() {
                                final r = _recordsMap[record.student.id]!;
                                r.currentStatus = EstadoAsistencia.justificado;
                                r.justificacionDetalle = detalle;
                                r.rutasEvidencia = evidencias;
                                r.fechaJustificacion = DateTime.now();
                              });
                            },
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: SaveAttendanceButton(
          isLoading: _isSaving,
          onPressed: hasStudents ? _save : null,
          hasStudents: hasStudents,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(LucideIcons.userX, size: 48, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            'No hay estudiantes activos en este grupo',
            style: TextStyle(color: Colors.grey.shade500, fontSize: 15),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Agrega estudiantes al grupo para poder registrar asistencias.',
            style: TextStyle(color: Colors.grey.shade400, fontSize: 13),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSummaryBanner(Map<EstadoAsistencia, int> stats) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatIndicator('P', stats[EstadoAsistencia.presente] ?? 0, Colors.green),
          _buildStatIndicator('T', stats[EstadoAsistencia.tardanza] ?? 0, Colors.orange),
          _buildStatIndicator('A', stats[EstadoAsistencia.ausente] ?? 0, Colors.red),
          _buildStatIndicator('J', stats[EstadoAsistencia.justificado] ?? 0, Colors.blue),
        ],
      ),
    );
  }

  Widget _buildStatIndicator(String label, int count, Color color) {
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '$count',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ],
    );
  }
}
