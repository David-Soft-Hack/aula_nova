import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../database/app_database.dart';
import '../../../controllers/module_controller.dart';

/// Hoja modal de opciones de acción para un módulo.
class ModuleOptionsSheet extends StatelessWidget {
  final Module module;
  final VoidCallback? onEdit;

  const ModuleOptionsSheet({
    super.key,
    required this.module,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
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
                Navigator.pop(context); // Cerrar la hoja de opciones
                
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    title: const Row(
                      children: [
                        Icon(LucideIcons.alertTriangle, color: Colors.red),
                        SizedBox(width: 8),
                        Text('¿Eliminar Módulo?', style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    content: Text(
                      '¿Estás seguro de que deseas eliminar el módulo "${module.nombre}"? Se borrarán también todas sus unidades, actividades y bitácoras asociadas. Esta acción no se puede deshacer.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade600,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Sí, eliminar'),
                      ),
                    ],
                  ),
                );

                if (confirm == true) {
                  try {
                    // Instanciamos el controller localmente ya que no podemos importarlo directamente sin modificar imports.
                    // Actually, let me just add the import to the file if needed.
                    await ModuleController().deleteModuleWithDetails(module.codModule);
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error al eliminar: $e'), backgroundColor: Colors.red),
                      );
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
