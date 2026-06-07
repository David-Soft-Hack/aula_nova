import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../config/theme/app_theme.dart';
import '../../../database/tables.dart';
import '../../../models/app_models.dart';
import 'attendance_status_colors.dart';
import 'justification_dialog.dart';

class StudentAttendanceRow extends StatelessWidget {
  final AttendanceRecord record;
  final ValueChanged<EstadoAsistencia> onStatusChanged;
  final Function(String detalle, List<String> evidencias) onJustificationChanged;

  const StudentAttendanceRow({
    super.key,
    required this.record,
    required this.onStatusChanged,
    required this.onJustificationChanged,
  });

  Future<void> _handleJustification(BuildContext context) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => JustificationDialog(
        studentName: '${record.student.apellidos}, ${record.student.nombres}',
        initialDetail: record.justificacionDetalle,
        initialEvidencePaths: record.rutasEvidencia,
      ),
    );

    if (result != null) {
      onJustificationChanged(
        result['detalle'] as String,
        result['evidencias'] as List<String>,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasJustification = record.justificacionDetalle != null && record.justificacionDetalle!.isNotEmpty;
    
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
              if (record.currentStatus == EstadoAsistencia.justificado)
                IconButton(
                  icon: const Icon(LucideIcons.edit3, color: AppTheme.academic600, size: 20),
                  onPressed: () => _handleJustification(context),
                  tooltip: 'Editar Justificación',
                ),
            ],
          ),
          if (record.currentStatus == EstadoAsistencia.justificado && hasJustification) ...[
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade100),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Justificación: ${record.justificacionDetalle}',
                    style: TextStyle(color: Colors.blue.shade900, fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                  if (record.rutasEvidencia.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      '${record.rutasEvidencia.length} archivo(s) de evidencia adjunto(s)',
                      style: TextStyle(color: Colors.blue.shade800, fontSize: 11, fontStyle: FontStyle.italic),
                    ),
                  ],
                ],
              ),
            ),
          ],
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
              onSelectionChanged: (Set<EstadoAsistencia> newSelection) async {
                final selected = newSelection.first;
                if (selected == EstadoAsistencia.justificado) {
                  await _handleJustification(context);
                } else {
                  onStatusChanged(selected);
                }
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                  if (states.contains(WidgetState.selected)) {
                    return attendanceBackgroundColor(record.currentStatus);
                  }
                  return Colors.transparent;
                }),
                foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                  if (states.contains(WidgetState.selected)) {
                    return attendanceForegroundColor(record.currentStatus);
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
