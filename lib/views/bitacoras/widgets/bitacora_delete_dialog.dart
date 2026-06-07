import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../config/theme/app_theme.dart';
import '../../../database/app_database.dart';
import '../../../providers/database_providers.dart';
import '../../shared/confirm_delete_dialog.dart';
import '../../shared/app_snackbar.dart';

/// Muestra un diálogo de confirmación para eliminar una bitácora.
/// Retorna true si el usuario confirmó, false si canceló.
Future<void> confirmDeleteBitacora(
  BuildContext context,
  Bitacora bitacora,
) async {
  final confirm = await showDialog<bool>(
    context: context,
    builder: (_) => const ConfirmDeleteDialog(
      title: '¿Eliminar Bitácora?',
      message: 'Esta acción eliminará la bitácora y todas sus sesiones asociadas.\n\n'
          'Los estudiantes activos del grupo de clase pasarán a estado '
          'Suspendido (o Finalizado si el calendario estaba completo).\n\n'
          'Esta acción no se puede deshacer.',
    ),
  );

  if (confirm == true && context.mounted) {
    await ProviderScope.containerOf(context).read(bitacoraDaoProvider).deleteBitacora(bitacora.id);
    if (context.mounted) AppSnackbar.showError(context, 'Bitácora eliminada');
  }
}

/// Diálogo de advertencia cuando no hay módulos registrados para crear una bitácora.
class NoModulesDialog extends StatelessWidget {
  const NoModulesDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: Row(
        children: [
          Icon(LucideIcons.alertCircle, color: Colors.amber.shade700, size: 28),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Módulo Requerido',
              style: TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      content: const Text(
        'No puedes configurar una bitácora porque aún no has registrado ningún Módulo Formativo.\n\nPor favor, ve a la sección de "Módulos Formativos" y sube o agrega un módulo primero.',
        style: TextStyle(fontFamily: 'Inter', height: 1.5, fontSize: 14),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'Entendido',
            style: TextStyle(
              color: AppTheme.academic600,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
