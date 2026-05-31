import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../config/theme/app_theme.dart';
import '../../../../database/app_database.dart';

/// Lista de unidades didácticas en el panel izquierdo del diálogo de detalle.
class UnitSidePanel extends StatelessWidget {
  final List<Unit> units;
  final String? selectedUnitId;
  final ValueChanged<String> onUnitSelected;
  final void Function(Unit) onEdit;
  final void Function(Unit) onDelete;
  final VoidCallback onAddUnit;

  const UnitSidePanel({
    super.key,
    required this.units,
    required this.selectedUnitId,
    required this.onUnitSelected,
    required this.onEdit,
    required this.onDelete,
    required this.onAddUnit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Row(
          children: [
            Text(
              'UNIDADES DIDÁCTICAS',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
          child: units.isEmpty
              ? const Center(
                  child: Text('Sin unidades', style: TextStyle(color: Colors.grey)),
                )
              : ListView.builder(
                  itemCount: units.length,
                  itemBuilder: (context, idx) {
                    final u = units[idx];
                    final selected = selectedUnitId == u.codUnit;
                    return GestureDetector(
                      onTap: () => onUnitSelected(u.codUnit),
                      child: _UnitListItem(
                        unit: u, 
                        selected: selected, 
                        onEdit: () => onEdit(u),
                        onDelete: () => onDelete(u)
                      ),
                    );
                  },
                ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: onAddUnit,
            icon: const Icon(LucideIcons.plus, size: 14),
            label: const Text(
              'AGREGAR UNIDAD',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppTheme.academic600,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
      ],
    );
  }
}

class _UnitListItem extends StatelessWidget {
  final Unit unit;
  final bool selected;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _UnitListItem({
    required this.unit,
    required this.selected,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: selected ? AppTheme.academic50.withValues(alpha: 0.3) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: selected ? AppTheme.academic600 : Colors.grey.shade200,
          width: selected ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.015),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: selected ? AppTheme.academic600 : AppTheme.academic50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Ponderación: ${unit.ponderacion.toInt()}%',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: selected ? Colors.white : AppTheme.academic600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade100),
                      ),
                      child: Row(
                        children: [
                          Icon(LucideIcons.clock, size: 10, color: Colors.grey.shade600),
                          const SizedBox(width: 4),
                          Text(
                            '${unit.totalHoraAcademic}h / ${unit.totalHoraReloj}h',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  unit.nombre,
                  style: const TextStyle(
                    fontSize: 13, 
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            children: [
              IconButton(
                icon: const Icon(LucideIcons.edit2, size: 16, color: Colors.blueAccent),
                onPressed: onEdit,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(height: 8),
              IconButton(
                icon: const Icon(LucideIcons.trash2, size: 16, color: Colors.redAccent),
                onPressed: onDelete,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
