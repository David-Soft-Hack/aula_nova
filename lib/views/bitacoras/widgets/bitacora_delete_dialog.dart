import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../config/theme/app_theme.dart';
import '../../../database/app_database.dart';
import '../../../models/database_provider.dart';

/// Muestra un diálogo de confirmación para eliminar una bitácora.
/// Retorna true si el usuario confirmó, false si canceló.
Future<void> confirmDeleteBitacora(
  BuildContext context,
  Bitacora bitacora,
) async {
  final confirm = await showDialog<bool>(
    context: context,
    builder: (c) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Row(
        children: [
          Icon(LucideIcons.alertTriangle, color: Colors.red),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              '¿Eliminar Bitácora?',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      content: const Text(
        'Esta acción eliminará la bitácora y todas sus sesiones asociadas. No se puede deshacer.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(c, false),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red.shade600,
            foregroundColor: Colors.white,
          ),
          onPressed: () => Navigator.pop(c, true),
          child: const Text('Eliminar'),
        ),
      ],
    ),
  );

  if (confirm == true && context.mounted) {
    final messenger = ScaffoldMessenger.of(context);
    await DatabaseProvider.bitacoraDao.deleteBitacora(bitacora.id);
    messenger.showSnackBar(
      const SnackBar(
        content: Text('Bitácora eliminada'),
        backgroundColor: Colors.redAccent,
      ),
    );
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
