import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../config/theme/app_theme.dart';
import '../../../database/app_database.dart';
import '../../../models/student.dart';

class StudentCard extends StatelessWidget {
  final Student student;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const StudentCard({
    super.key,
    required this.student,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppTheme.academic50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(LucideIcons.user, color: AppTheme.academic600, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(student.fullName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5)),
                  const SizedBox(height: 4),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 10,
                    runSpacing: 4,
                    children: [
                      Text(student.codigo, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                      if (student.carrera != null && student.carrera!.isNotEmpty)
                        Text(student.carrera!, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                      Text(student.statusLabel, style: const TextStyle(color: AppTheme.academic600, fontWeight: FontWeight.bold, fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(LucideIcons.edit3, color: Colors.blue.shade600, size: 18),
              visualDensity: VisualDensity.compact,
              padding: const EdgeInsets.all(6),
              constraints: const BoxConstraints(),
              tooltip: 'Editar',
              onPressed: onEdit,
            ),
            const SizedBox(width: 6),
            IconButton(
              icon: const Icon(LucideIcons.trash2, color: Colors.red, size: 18),
              visualDensity: VisualDensity.compact,
              padding: const EdgeInsets.all(6),
              constraints: const BoxConstraints(),
              tooltip: 'Eliminar',
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
