import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import '../../config/theme/app_theme.dart';
import '../../database/app_database.dart';
import '../../database/tables.dart';
import '../../controllers/attendance_controller.dart';
import '../../providers/attendance_providers.dart';
import '../shared/app_snackbar.dart';

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
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final dateStr = widget.session.fechaProgramada != null
        ? DateFormat('dd MMM yyyy', 'es').format(widget.session.fechaProgramada!)
        : 'Sin fecha';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Sesión ${widget.sessionNumber} - Grupo ${widget.groupCode}'),
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
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  color: AppTheme.academic50,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.moduleName,
                        style: const TextStyle(fontWeight: FontWeight.w600, color: AppTheme.academic800),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(LucideIcons.calendar, size: 14, color: AppTheme.academic600),
                          const SizedBox(width: 4),
                          Text(dateStr, style: const TextStyle(color: AppTheme.academic700)),
                          const SizedBox(width: 16),
                          Icon(LucideIcons.tag, size: 14, color: AppTheme.academic600),
                          const SizedBox(width: 4),
                          Text(widget.session.codActividad ?? 'Sin actividad', style: const TextStyle(color: AppTheme.academic700)),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: _records == null || _records!.isEmpty
                      ? const Center(child: Text('No hay estudiantes activos en este grupo.'))
                      : ListView.separated(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          itemCount: _records!.length,
                          separatorBuilder: (_, _) => const Divider(height: 1),
                          itemBuilder: (context, index) {
                            return _StudentAttendanceRow(
                              record: _records![index],
                              onStatusChanged: (status) {
                                setState(() {
                                  _records![index].currentStatus = status;
                                });
                              },
                            );
                          },
                        ),
                ),
              ],
            ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: FilledButton.icon(
          onPressed: _isSaving ? null : _save,
          style: FilledButton.styleFrom(
            backgroundColor: AppTheme.academic600,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          icon: _isSaving
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
              : const Icon(LucideIcons.save),
          label: Text(_isSaving ? 'Guardando...' : 'Guardar Asistencia', style: const TextStyle(fontSize: 16)),
        ),
      ),
    );
  }
}

class _StudentAttendanceRow extends StatelessWidget {
  final AttendanceRecord record;
  final ValueChanged<EstadoAsistencia> onStatusChanged;

  const _StudentAttendanceRow({
    required this.record,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: AppTheme.academic100,
                child: Text(
                  record.student.nombres[0].toUpperCase(),
                  style: const TextStyle(color: AppTheme.academic800, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${record.student.apellidos}, ${record.student.nombres}',
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                    ),
                    Text(
                      record.student.codigo,
                      style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: SegmentedButton<EstadoAsistencia>(
              segments: const [
                ButtonSegment(
                  value: EstadoAsistencia.presente,
                  icon: Icon(LucideIcons.check),
                  label: Text('P', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                ButtonSegment(
                  value: EstadoAsistencia.tardanza,
                  icon: Icon(LucideIcons.clock),
                  label: Text('T', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                ButtonSegment(
                  value: EstadoAsistencia.ausente,
                  icon: Icon(LucideIcons.x),
                  label: Text('A', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                ButtonSegment(
                  value: EstadoAsistencia.justificado,
                  icon: Icon(LucideIcons.fileText),
                  label: Text('J', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
              selected: {record.currentStatus ?? EstadoAsistencia.presente},
              onSelectionChanged: (Set<EstadoAsistencia> newSelection) {
                onStatusChanged(newSelection.first);
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                  if (states.contains(WidgetState.selected)) {
                    switch (record.currentStatus) {
                      case EstadoAsistencia.presente:
                        return Colors.green.shade100;
                      case EstadoAsistencia.ausente:
                        return Colors.red.shade100;
                      case EstadoAsistencia.tardanza:
                        return Colors.orange.shade100;
                      case EstadoAsistencia.justificado:
                        return Colors.blue.shade100;
                      default:
                        return AppTheme.academic100;
                    }
                  }
                  return Colors.transparent;
                }),
                foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                  if (states.contains(WidgetState.selected)) {
                    switch (record.currentStatus) {
                      case EstadoAsistencia.presente:
                        return Colors.green.shade800;
                      case EstadoAsistencia.ausente:
                        return Colors.red.shade800;
                      case EstadoAsistencia.tardanza:
                        return Colors.orange.shade800;
                      case EstadoAsistencia.justificado:
                        return Colors.blue.shade800;
                      default:
                        return AppTheme.academic800;
                    }
                  }
                  return Colors.grey.shade600;
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
