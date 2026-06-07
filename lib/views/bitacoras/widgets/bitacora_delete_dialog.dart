import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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


