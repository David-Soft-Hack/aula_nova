import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../config/theme/app_theme.dart';
import '../../../database/tables.dart';
import '../../../models/app_models.dart';
import 'attendance_status_colors.dart';

class StudentAttendanceRow extends StatelessWidget {
  final AttendanceRecord record;
  final ValueChanged<EstadoAsistencia> onStatusChanged;

  const StudentAttendanceRow({
    super.key,
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
