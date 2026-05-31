import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// Footer con el botón de "Editar Bitácora" para la pantalla de gestión.
/// Incluye la decoración de borde superior y sombra.
class ManageBitacoraFooter extends StatelessWidget {
  final VoidCallback onEdit;

  const ManageBitacoraFooter({super.key, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x06000000),
            blurRadius: 10,
            offset: Offset(0, -4),
          ),
        ],
        border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: onEdit,
          icon: const Icon(LucideIcons.edit, size: 16),
          label: const Text('Editar Bitácora'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            side: const BorderSide(color: Color(0xFFCBD5E1)),
            foregroundColor: const Color(0xFF475569),
          ),
        ),
      ),
    );
  }
}
