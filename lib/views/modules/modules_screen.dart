import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../config/theme/app_theme.dart';
import '../../models/database_provider.dart';
import '../../database/app_database.dart';
import 'widgets/module_card.dart';
import 'widgets/modules_layout.dart';
import 'widgets/add_module_stepper_dialog.dart';
import 'widgets/module_detail_dialog.dart';
import 'widgets/module_options_sheet.dart';
import 'widgets/edit_module_dialog.dart';

/// Pantalla de gestión de Módulos Formativos.
class ModulesScreen extends StatelessWidget {
  const ModulesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: StreamBuilder<List<Module>>(
          stream: DatabaseProvider.moduleDao.watchAllModules(),
          builder: (context, snapshot) {
            final isLoading = snapshot.connectionState == ConnectionState.waiting;
            final modules = snapshot.data ?? [];

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ModulesPageHeader(
                    onNewModule: () => _showAddModuleModal(context),
                  ),
                  const SizedBox(height: 32),
                  if (isLoading)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 60),
                        child: CircularProgressIndicator(
                          color: AppTheme.academic600,
                        ),
                      ),
                    )
                  else if (modules.isEmpty)
                    const ModulesEmptyState()
                  else
                    ModulesGrid(
                      modules: modules,
                      cardBuilder: (module) => ModuleCard(
                        module: module,
                        onOptions: () => _showModuleOptions(context, module),
                        onManage: () => _showDetailModal(context, module),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _showModuleOptions(BuildContext context, Module module) {
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

  Future<void> _showAddModuleModal(BuildContext context) async {
    final careers = await DatabaseProvider.careerDao.getAllCareers();
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
