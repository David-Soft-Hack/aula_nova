import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';

class FormHolidayDates extends StatelessWidget {
  final List<DateTime> fechasFeriadas;
  final VoidCallback onAddFechaFeriada;
  final ValueChanged<DateTime> onRemoveFechaFeriada;

  const FormHolidayDates({
    super.key,
    required this.fechasFeriadas,
    required this.onAddFechaFeriada,
    required this.onRemoveFechaFeriada,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.red.shade100),
      ),
      color: Colors.red.shade50.withValues(alpha: 0.3),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  LucideIcons.calendarOff,
                  size: 18,
                  color: Colors.red.shade700,
                ),
                const SizedBox(width: 8),
                Text(
                  'Fechas Feriadas (No laborables)',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.red.shade900,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: onAddFechaFeriada,
                  icon: const Icon(LucideIcons.plusCircle),
                  color: Colors.red.shade700,
                  tooltip: 'Agregar feriado',
                  constraints: const BoxConstraints(),
                  padding: EdgeInsets.zero,
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.red.shade50,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (fechasFeriadas.isEmpty)
              Text(
                'No se han agregado fechas feriadas.',
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              )
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: fechasFeriadas.map((date) {
                  final formattedDate = DateFormat('dd MMM, yyyy', 'es').format(date);
                  return InputChip(
                    label: Text(formattedDate),
                    onDeleted: () {
                      onRemoveFechaFeriada(date);
                    },
                    deleteIconColor: Colors.red.shade700,
                    deleteIcon: const Icon(LucideIcons.x, size: 12),
                    backgroundColor: Colors.red.shade50,
                    labelStyle: TextStyle(
                      color: Colors.red.shade900,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: Colors.red.shade200),
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
