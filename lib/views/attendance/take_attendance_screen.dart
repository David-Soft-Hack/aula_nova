import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
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
  List<AttendanceRecord>? _records;
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final records = await ref.read(attendanceControllerProvider).getAttendanceListForSession(
      widget.session.id,
      widget.groupCode,
    );
    if (mounted) {
      setState(() {
        _records = records;
        _isLoading = false;
      });
    }
  }

  Future<void> _save() async {
    if (_records == null) return;
    setState(() => _isSaving = true);
    try {
      await ref.read(attendanceControllerProvider).saveAttendances(widget.session.id, _records!);
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
    if (_records == null) return;
    setState(() {
      for (var r in _records!) {
        r.currentStatus = status;
        if (status != EstadoAsistencia.justificado) {
          r.justificacionDetalle = null;
          r.rutasEvidencia = [];
          r.fechaJustificacion = null;
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
    if (_records != null) {
      for (var r in _records!) {
        final status = r.currentStatus ?? EstadoAsistencia.presente;
        stats[status] = (stats[status] ?? 0) + 1;
      }
    }
    return stats;
  }

  @override
  Widget build(BuildContext context) {
    final stats = _getStats();

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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                SessionInfoHeader(moduleName: widget.moduleName, session: widget.session),
                _buildStatsSummaryBanner(stats),
                Expanded(
                  child: _records == null || _records!.isEmpty
                      ? const Center(child: Text('No hay estudiantes activos en este grupo.'))
                      : ListView.separated(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          itemCount: _records!.length,
                          separatorBuilder: (_, _) => const Divider(height: 1),
                          itemBuilder: (context, index) {
                            return StudentAttendanceRow(
                              record: _records![index],
                              onStatusChanged: (status) {
                                setState(() {
                                  _records![index].currentStatus = status;
                                });
                              },
                              onJustificationChanged: (detalle, evidencias) {
                                setState(() {
                                  _records![index].currentStatus = EstadoAsistencia.justificado;
                                  _records![index].justificacionDetalle = detalle;
                                  _records![index].rutasEvidencia = evidencias;
                                  _records![index].fechaJustificacion = DateTime.now();
                                });
                              },
                            );
                          },
                        ),
                ),
              ],
            ),
      bottomNavigationBar: SaveAttendanceButton(
        isLoading: _isSaving,
        onPressed: _save,
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

