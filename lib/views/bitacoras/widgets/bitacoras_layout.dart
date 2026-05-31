import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../config/theme/app_theme.dart';

/// Encabezado de la pantalla de Bitácoras Docentes en una sola fila compacta.
class BitacorasPageHeader extends StatelessWidget {
  final VoidCallback onNewBitacora;

  const BitacorasPageHeader({
    super.key,
    required this.onNewBitacora,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bitácoras Docentes',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Outfit',
                  fontSize: 18,
                  color: AppTheme.slate900,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Seguimiento de sesiones de clase',
                style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey.shade500, fontSize: 11),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton.icon(
          onPressed: onNewBitacora,
          icon: const Icon(LucideIcons.plus, size: 16),
          label: const Text('Configurar'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.academic600,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ],
    );
  }
}

// ─── Barra de búsqueda ────────────────────────────────────────────────────────

/// Barra de búsqueda con limpiador para la pantalla de Bitácoras.
class BitacoraSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String searchTerm;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const BitacoraSearchBar({
    super.key,
    required this.controller,
    required this.searchTerm,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.01),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          hintText: 'Buscar por módulo, grupo, carrera...',
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
          prefixIcon: Icon(LucideIcons.search, size: 16, color: Colors.grey.shade400),
          suffixIcon: searchTerm.isNotEmpty
              ? IconButton(
                  icon: const Icon(LucideIcons.x, size: 14),
                  onPressed: onClear,
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
        ),
      ),
    );
  }
}

// ─── Estado vacío ─────────────────────────────────────────────────────────────

/// Widget de estado vacío para la pantalla de bitácoras.
class BitacorasEmptyState extends StatelessWidget {
  final VoidCallback onCreateBitacora;

  const BitacorasEmptyState({super.key, required this.onCreateBitacora});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: AppTheme.academic50,
                shape: BoxShape.circle,
              ),
              child: const Icon(LucideIcons.fileText, size: 48, color: AppTheme.academic600),
            ),
            const SizedBox(height: 16),
            Text(
              'Sin Bitácoras',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'Aún no has configurado ninguna bitácora para tus módulos. Comienza creando una ahora.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade500),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onCreateBitacora,
              icon: const Icon(LucideIcons.plus, size: 18),
              label: const Text('Crear Primera Bitácora'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.academic600,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
