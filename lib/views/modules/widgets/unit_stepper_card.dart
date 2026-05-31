import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../config/theme/app_theme.dart';
import 'stepper_hour_field.dart';

/// Tarjeta del paso 2 para editar una Unidad Didáctica con soporte para colapso/expansión animada.
class UnitStepperCard extends StatelessWidget {
  final int index;
  final bool isExpanded;
  final VoidCallback onToggleExpand;
  final TextEditingController? nombreCtrl;
  final TextEditingController? hrCtrl;
  final TextEditingController? haCtrl;
  final TextEditingController? ponderCtrl;
  final ValueChanged<String> onNombreChanged;
  final ValueChanged<String> onHrChanged;
  final ValueChanged<String> onHaChanged;
  final ValueChanged<String> onPonderChanged;
  final VoidCallback onDelete;

  const UnitStepperCard({
    super.key,
    required this.index,
    required this.isExpanded,
    required this.onToggleExpand,
    required this.nombreCtrl,
    required this.hrCtrl,
    required this.haCtrl,
    required this.ponderCtrl,
    required this.onNombreChanged,
    required this.onHrChanged,
    required this.onHaChanged,
    required this.onPonderChanged,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final hasName = nombreCtrl?.text.trim().isNotEmpty ?? false;
    final nameText = hasName ? nombreCtrl!.text : 'Unidad Didáctica ${index + 1}';

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isExpanded ? AppTheme.academic600 : AppTheme.academic100,
          width: isExpanded ? 1.5 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: (isExpanded ? AppTheme.academic600 : Colors.black)
                .withValues(alpha: isExpanded ? 0.08 : 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cabecera clickeable para colapsar/expandir
          InkWell(
            onTap: onToggleExpand,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  _UnitBadge(index: index),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      nameText,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: isExpanded ? FontWeight.bold : FontWeight.w600,
                        color: isExpanded ? AppTheme.academic700 : AppTheme.slate900,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (!isExpanded) ...[
                    // Indicadores breves de horas cuando está colapsado
                    _buildMiniBadge(
                      icon: LucideIcons.clock,
                      text: '${hrCtrl?.text.isEmpty == true ? "0" : hrCtrl?.text}h',
                      color: Colors.amber.shade700,
                    ),
                    const SizedBox(width: 6),
                    _buildMiniBadge(
                      icon: LucideIcons.percent,
                      text: '${ponderCtrl?.text.isEmpty == true ? "0" : ponderCtrl?.text}%',
                      color: Colors.purple.shade700,
                    ),
                    const SizedBox(width: 12),
                  ],
                  _DeleteButton(onDelete: onDelete),
                  const SizedBox(width: 8),
                  Icon(
                    isExpanded ? LucideIcons.chevronUp : LucideIcons.chevronDown,
                    color: Colors.grey.shade400,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
          
          // Formulario expandible
          AnimatedCrossFade(
            firstChild: const SizedBox(width: double.infinity),
            secondChild: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(height: 16),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: nombreCtrl,
                    onChanged: onNombreChanged,
                    maxLines: null,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    decoration: _inputDecoration('Denominación de la Unidad Didáctica'),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: StepperHourField(
                          controller: hrCtrl,
                          label: 'Horas Reloj',
                          icon: LucideIcons.clock,
                          onChanged: onHrChanged,
                          accent: Colors.amber.shade700,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: StepperHourField(
                          controller: haCtrl,
                          label: 'Horas Acad.',
                          icon: LucideIcons.graduationCap,
                          onChanged: onHaChanged,
                          accent: Colors.teal.shade700,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: StepperHourField(
                          controller: ponderCtrl,
                          label: 'Ponderación %',
                          icon: LucideIcons.percent,
                          onChanged: onPonderChanged,
                          accent: Colors.purple.shade700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            crossFadeState: isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniBadge({
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

InputDecoration _inputDecoration(String hint) {
  return InputDecoration(
    hintText: hint,
    hintStyle: TextStyle(fontSize: 13, color: Colors.grey.shade400, fontWeight: FontWeight.normal),
    filled: true,
    fillColor: Colors.grey.shade50,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppTheme.academic500, width: 1.5)),
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
  );
}

class _UnitBadge extends StatelessWidget {
  final int index;
  const _UnitBadge({required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.academic50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.academic200),
      ),
      child: Text(
        'UD ${index + 1}',
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: AppTheme.academic700,
        ),
      ),
    );
  }
}

class _DeleteButton extends StatelessWidget {
  final VoidCallback onDelete;
  const _DeleteButton({required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onDelete,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(8)),
        child: Icon(LucideIcons.trash2, size: 14, color: Colors.red.shade600),
      ),
    );
  }
}
