import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../database/app_database.dart';
import '../../../providers/module_providers.dart';
import '../../shared/confirm_delete_dialog.dart';
import '../../shared/app_snackbar.dart';

class ModuleOptionsSheet extends ConsumerWidget {
  final Module module;
  final VoidCallback? onEdit;

  const ModuleOptionsSheet({
    super.key,
    required this.module,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(LucideIcons.edit2, color: Colors.blue),
              title: const Text('Editar Módulo', style: TextStyle(fontWeight: FontWeight.bold)),
              onTap: () {
                Navigator.pop(context);
                onEdit?.call();
              },
            ),
            ListTile(
              leading: const Icon(LucideIcons.trash2, color: Colors.red),
              title: const Text(
                'Eliminar Módulo',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
              ),
              onTap: () async {
                final controller = ref.read(moduleControllerProvider);
                Navigator.pop(context); // Cerrar la hoja de opciones
                
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (_) => ConfirmDeleteDialog(
                    title: '¿Eliminar Módulo?',
                    message: '¿Estás seguro de que deseas eliminar el módulo "${module.nombre}"? Se borrarán también todas sus unidades, actividades y bitácoras asociadas. Esta acción no se puede deshacer.',
                  ),
                );

                if (confirm == true) {
                  try {
                    await controller.deleteModuleWithDetails(module.codModule);
                    if (context.mounted) {
                      AppSnackbar.showSuccess(context, 'Módulo eliminado con éxito');
                    }
                  } catch (e) {
                    if (context.mounted) {
                      AppSnackbar.showError(context, 'Error al eliminar: $e');
                    }
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
