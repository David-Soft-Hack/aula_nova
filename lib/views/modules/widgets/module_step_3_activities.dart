import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../config/theme/app_theme.dart';
import 'activity_stepper_card.dart';

class ModuleStep3Activities extends StatelessWidget {
  final List<Map<String, dynamic>> activities;
  final List<Map<String, dynamic>> units;
  final List<TextEditingController> actCodeCtrl;
  final List<TextEditingController> actDescCtrl;
  final List<TextEditingController> actHrCtrl;
  final List<TextEditingController> actHaCtrl;
  final VoidCallback onAddActivity;
  final VoidCallback onStateUpdated;

  const ModuleStep3Activities({
    super.key,
    required this.activities,
    required this.units,
    required this.actCodeCtrl,
    required this.actDescCtrl,
    required this.actHrCtrl,
    required this.actHaCtrl,
    required this.onAddActivity,
    required this.onStateUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Expanded(
              child: Text(
                'Actividades de Aprendizaje',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton.icon(
              onPressed: onAddActivity,
              icon: const Icon(LucideIcons.plus, size: 16),
              label: const Text('Agregar Actividad'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.academic600,
                foregroundColor: Colors.white,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.builder(
            itemCount: activities.length,
            itemBuilder: (context, idx) {
              final a = activities[idx];
              final unitIndex = a['unitIndex'] as int? ?? 0;

              return ActivityStepperCard(
                index: idx,
                codeCtrl: idx < actCodeCtrl.length ? actCodeCtrl[idx] : null,
                selectedUnitIndex: unitIndex,
                units: units,
                descCtrl: idx < actDescCtrl.length ? actDescCtrl[idx] : null,
                hrCtrl: idx < actHrCtrl.length ? actHrCtrl[idx] : null,
                haCtrl: idx < actHaCtrl.length ? actHaCtrl[idx] : null,
                onUnitChanged: (val) {
                  if (val != null) {
                    activities[idx]['unitIndex'] = val;
                    onStateUpdated();
                  }
                },
                onCodeChanged: (val) {
                  activities[idx]['codigo'] = val;
                  onStateUpdated();
                },
                onDescChanged: (val) {
                  activities[idx]['descripcion'] = val;
                  onStateUpdated();
                },
                onHrChanged: (val) {
                  activities[idx]['hr'] = int.tryParse(val) ?? 0;
                  onStateUpdated();
                },
                onHaChanged: (val) {
                  activities[idx]['ha'] = int.tryParse(val) ?? 0;
                  onStateUpdated();
                },
                onDelete: () {
                  activities.removeAt(idx);
                  onStateUpdated();
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
