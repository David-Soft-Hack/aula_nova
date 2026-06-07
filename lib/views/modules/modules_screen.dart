import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../config/theme/app_theme.dart';
import '../../database/app_database.dart';
import '../../providers/module_providers.dart';
import '../../providers/database_providers.dart';
import 'widgets/module_card.dart';
import 'widgets/modules_layout.dart';
import 'widgets/add_module_stepper_dialog.dart';
import 'widgets/module_detail_dialog.dart';
import 'widgets/module_options_sheet.dart';
import 'widgets/edit_module_dialog.dart';

class ModulesScreen extends ConsumerWidget {
  const ModulesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final modulesAsync = ref.watch(allModulesStreamProvider);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: modulesAsync.when(
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 60),
              child: CircularProgressIndicator(color: AppTheme.academic600),
            ),
          ),
          error: (e, _) => Center(child: Text('Error: $e')),
          data: (modules) => SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ModulesPageHeader(
                  onNewModule: () => _showAddModuleModal(context, ref),
                ),
                const SizedBox(height: 32),
                if (modules.isEmpty)
                  const ModulesEmptyState()
                else
                  ModulesGrid(
                    modules: modules,
                    cardBuilder: (module) => ModuleCard(
                      module: module,
                      onOptions: () => _showModuleOptions(context, ref, module),
                      onManage: () => _showDetailModal(context, module),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showModuleOptions(BuildContext context, WidgetRef ref, Module module) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => ModuleOptionsSheet(
        module: module,
        onEdit: () {
          showDialog(
            context: context,
            builder: (context) => EditModuleDialog(module: module),
          );
        },
      ),
    );
  }

  Future<void> _showAddModuleModal(BuildContext context, WidgetRef ref) async {
    final careers = await ref.read(careerDaoProvider).getAllCareers();
    if (!context.mounted) return;

    if (careers.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Row(
            children: [
              Icon(LucideIcons.alertCircle, color: Colors.amber.shade700, size: 28),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Programa Requerido',
                  style: TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          content: const Text(
            'No puedes crear un Módulo Formativo porque aún no has registrado ningún Programa o Carrera Técnica.\n\nPor favor, ve a la sección de "Carreras o Programas" y agrega una carrera o curso primero.',
            style: TextStyle(fontFamily: 'Inter', height: 1.5, fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Entendido', style: TextStyle(color: AppTheme.academic600, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      );
      return;
    }

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Cerrar',
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) => const AddModuleStepperDialog(),
    );
  }

  void _showDetailModal(BuildContext context, Module module) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Cerrar',
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) => ModuleDetailDialog(module: module),
    );
  }
}
