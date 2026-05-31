import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../config/theme/app_theme.dart';
import 'unit_stepper_card.dart';

/// Vista para el paso 2 de Unidades Didácticas (UD) que utiliza tarjetas colapsables
/// para mejorar drásticamente la visibilidad y facilitar el trabajo al usuario.
class ModuleStep2Units extends StatefulWidget {
  final List<Map<String, dynamic>> units;
  final List<TextEditingController> unitNombreCtrl;
  final List<TextEditingController> unitHrCtrl;
  final List<TextEditingController> unitHaCtrl;
  final List<TextEditingController> unitPonderCtrl;
  final VoidCallback onAddUnit;
  final VoidCallback onStateUpdated;

  const ModuleStep2Units({
    super.key,
    required this.units,
    required this.unitNombreCtrl,
    required this.unitHrCtrl,
    required this.unitHaCtrl,
    required this.unitPonderCtrl,
    required this.onAddUnit,
    required this.onStateUpdated,
  });

  @override
  State<ModuleStep2Units> createState() => _ModuleStep2UnitsState();
}

class _ModuleStep2UnitsState extends State<ModuleStep2Units> {
  int _expandedIndex = 0; // Por defecto se expande la primera unidad

  @override
  Widget build(BuildContext context) {
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Unidades Didácticas (UD)',
                    style: TextStyle(
                      fontSize: isKeyboardOpen ? 14 : 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.slate900,
                    ),
                  ),
                  if (!isKeyboardOpen) ...[
                    const SizedBox(height: 2),
                    Text(
                      'Expande una unidad para editar sus detalles.',
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton.icon(
              onPressed: () {
                widget.onAddUnit();
                // Expande automáticamente la unidad recién agregada
                setState(() {
                  _expandedIndex = widget.units.length - 1;
                });
              },
              icon: Icon(LucideIcons.plus, size: isKeyboardOpen ? 14 : 16),
              label: Text(
                'Agregar UD',
                style: TextStyle(fontSize: isKeyboardOpen ? 11 : 13),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.academic600,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: EdgeInsets.symmetric(
                  horizontal: isKeyboardOpen ? 10 : 16,
                  vertical: isKeyboardOpen ? 8 : 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: isKeyboardOpen ? 8 : 16),
        Expanded(
          child: widget.units.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  itemCount: widget.units.length,
                  itemBuilder: (context, idx) {
                    return UnitStepperCard(
                      index: idx,
                      isExpanded: _expandedIndex == idx,
                      onToggleExpand: () {
                        setState(() {
                          _expandedIndex = _expandedIndex == idx ? -1 : idx;
                        });
                      },
                      nombreCtrl: idx < widget.unitNombreCtrl.length ? widget.unitNombreCtrl[idx] : null,
                      hrCtrl: idx < widget.unitHrCtrl.length ? widget.unitHrCtrl[idx] : null,
                      haCtrl: idx < widget.unitHaCtrl.length ? widget.unitHaCtrl[idx] : null,
                      ponderCtrl: idx < widget.unitPonderCtrl.length ? widget.unitPonderCtrl[idx] : null,
                      onNombreChanged: (val) {
                        widget.units[idx]['nombre'] = val;
                        widget.onStateUpdated();
                      },
                      onHrChanged: (val) {
                        widget.units[idx]['hr'] = int.tryParse(val) ?? 0;
                        widget.onStateUpdated();
                      },
                      onHaChanged: (val) {
                        widget.units[idx]['ha'] = int.tryParse(val) ?? 0;
                        widget.onStateUpdated();
                      },
                      onPonderChanged: (val) {
                        widget.units[idx]['ponderacion'] = double.tryParse(val) ?? 0.0;
                        widget.onStateUpdated();
                      },
                      onDelete: () {
                        widget.units.removeAt(idx);
                        widget.onStateUpdated();
                        // Ajusta el índice expandido después de borrar
                        setState(() {
                          if (_expandedIndex >= widget.units.length) {
                            _expandedIndex = widget.units.length - 1;
                          }
                        });
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(LucideIcons.bookOpen, size: 48, color: Colors.grey.shade300),
          const SizedBox(height: 12),
          Text(
            'No hay unidades asignadas',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 4),
          const Text(
            'Presiona "Agregar UD" para registrar una unidad didáctica.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
