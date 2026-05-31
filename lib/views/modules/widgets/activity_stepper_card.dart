import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../config/theme/app_theme.dart';
import 'stepper_hour_field.dart';

/// Tarjeta del paso 3 para editar una Actividad de Aprendizaje.
class ActivityStepperCard extends StatelessWidget {
  final int index;
  final TextEditingController? codeCtrl;
  final int selectedUnitIndex;
  final List<Map<String, dynamic>> units;
  final TextEditingController? descCtrl;
  final TextEditingController? hrCtrl;
  final TextEditingController? haCtrl;
  final ValueChanged<int?> onUnitChanged;
  final ValueChanged<String> onCodeChanged;
  final ValueChanged<String> onDescChanged;
  final ValueChanged<String> onHrChanged;
  final ValueChanged<String> onHaChanged;
  final VoidCallback onDelete;

  const ActivityStepperCard({
    super.key,
    required this.index,
    required this.codeCtrl,
    required this.selectedUnitIndex,
    required this.units,
    required this.descCtrl,
    required this.hrCtrl,
    required this.haCtrl,
    required this.onUnitChanged,
    required this.onCodeChanged,
    required this.onDescChanged,
    required this.onHrChanged,
    required this.onHaChanged,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.indigo.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.indigo.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: const BoxDecoration(
            border: Border(left: BorderSide(color: Colors.indigo, width: 5)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(LucideIcons.checkSquare, size: 14, color: Colors.indigo.shade700),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 130,
                      child: TextFormField(
                        controller: codeCtrl,
                        onChanged: onCodeChanged,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo.shade700,
                          fontFamily: 'Outfit',
                        ),
                        decoration: InputDecoration(
                          hintText: 'Act. Código',
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          filled: true,
                          fillColor: Colors.indigo.shade50,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.indigo.shade100),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.indigo.shade100),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.indigo, width: 1.5),
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    _DeleteButton(onDelete: onDelete),
                  ],
                ),
                const SizedBox(height: 12),
                _UnitSelector(units: units, selectedIndex: selectedUnitIndex, onChanged: onUnitChanged),
                const SizedBox(height: 12),
                TextFormField(
                  controller: descCtrl,
                  onChanged: onDescChanged,
                  maxLines: null,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                  decoration: _inputDecoration('Describe la actividad de aprendizaje...'),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: StepperHourField(controller: hrCtrl, label: 'Horas Reloj', icon: LucideIcons.clock, onChanged: onHrChanged, accent: Colors.amber.shade700)),
                    const SizedBox(width: 10),
                    Expanded(child: StepperHourField(controller: haCtrl, label: 'Horas Acad.', icon: LucideIcons.graduationCap, onChanged: onHaChanged, accent: Colors.teal.shade700)),
                  ],
                ),
              ],
            ),
          ),
        ),
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

class _UnitSelector extends StatelessWidget {
  final List<Map<String, dynamic>> units;
  final int selectedIndex;
  final ValueChanged<int?> onChanged;

  const _UnitSelector({required this.units, required this.selectedIndex, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          isExpanded: true,
          value: selectedIndex,
          onChanged: onChanged,
          icon: Icon(LucideIcons.chevronsUpDown, size: 14, color: Colors.grey.shade500),
          style: const TextStyle(fontSize: 13, color: Colors.black87),
          items: List.generate(
            units.length,
            (i) => DropdownMenuItem(
              value: i,
              child: Text(
                'UD ${i + 1} — ${units[i]['nombre'].toString().trim().isEmpty ? 'Sin nombre' : units[i]['nombre'].toString().trim()}',
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
