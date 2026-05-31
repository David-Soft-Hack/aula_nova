import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../config/theme/app_theme.dart';

class FormWeeklyFrequency extends StatelessWidget {
  final List<String> diasSemana;
  final List<String> diasSeleccionados;
  final ValueChanged<String> onToggleDia;

  const FormWeeklyFrequency({
    super.key,
    required this.diasSemana,
    required this.diasSeleccionados,
    required this.onToggleDia,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      color: Colors.grey.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  LucideIcons.calendarDays,
                  size: 18,
                  color: AppTheme.academic600,
                ),
                const SizedBox(width: 8),
                Text(
                  'Días de Frecuencia Semanal',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: diasSemana.map((day) {
                final isSelected = diasSeleccionados.contains(day);
                return FilterChip(
                  label: Text(day),
                  selected: isSelected,
                  onSelected: (selected) {
                    onToggleDia(day);
                  },
                  selectedColor: AppTheme.academic100,
                  checkmarkColor: AppTheme.academic600,
                  labelStyle: TextStyle(
                    color: isSelected ? AppTheme.academic700 : Colors.black87,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: isSelected
                          ? AppTheme.academic200
                          : Colors.grey.shade200,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
