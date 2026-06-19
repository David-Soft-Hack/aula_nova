import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../config/theme/app_theme.dart';

class SaveAttendanceButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback? onPressed;
  final bool hasStudents;

  const SaveAttendanceButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
    this.hasStudents = true,
  });

  @override
  Widget build(BuildContext context) {
    final bool disabled = !hasStudents || isLoading;

    return Container(
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!hasStudents && !isLoading)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(LucideIcons.alertCircle, size: 14, color: Colors.orange.shade700),
                  const SizedBox(width: 6),
                  Text(
                    'No hay estudiantes en este grupo',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.orange.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          FilledButton.icon(
            onPressed: disabled ? null : onPressed,
            style: FilledButton.styleFrom(
              backgroundColor: hasStudents ? AppTheme.academic600 : Colors.grey.shade400,
              disabledBackgroundColor: Colors.grey.shade300,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              minimumSize: const Size(double.infinity, 48),
            ),
            icon: isLoading
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : Icon(hasStudents ? LucideIcons.save : LucideIcons.ban),
            label: Text(
              isLoading
                  ? 'Guardando...'
                  : hasStudents
                      ? 'Guardar Asistencia'
                      : 'Sin estudiantes para guardar',
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
