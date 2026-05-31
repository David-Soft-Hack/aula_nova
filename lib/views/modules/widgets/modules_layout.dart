import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../config/theme/app_theme.dart';
import '../../../database/app_database.dart';

/// Encabezado para la pantalla de módulos en formato móvil.
class ModulesPageHeader extends StatelessWidget {
  final VoidCallback onNewModule;

  const ModulesPageHeader({
    super.key,
    required this.onNewModule,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final titleColumn = Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Módulos Formativos', style: theme.textTheme.headlineMedium),
              const SizedBox(height: 4),
              Text(
                'Gestión centralizada de contenidos y carga horaria',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ),
      ],
    );

    final newButton = ElevatedButton.icon(
      onPressed: onNewModule,
      icon: const Icon(LucideIcons.plus, size: 20),
      label: const Text('Nuevo Módulo'),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.academic600,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        shadowColor: AppTheme.academic600.withValues(alpha: 0.3),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        titleColumn,
        const SizedBox(height: 16),
        SizedBox(width: double.infinity, child: newButton),
      ],
    );
  }
}

// ─── Estado vacío ────────────────────────────────────────────────────────────

/// Pantalla vacía que se muestra cuando no hay módulos filtrados.
class ModulesEmptyState extends StatelessWidget {
  const ModulesEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 64.0),
        child: Column(
          children: [
            Icon(LucideIcons.bookOpen, size: 48, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              'No se encontraron módulos',
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.grey.shade400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Grid de módulos ─────────────────────────────────────────────────────────

/// Listado vertical de tarjetas de módulos para dispositivos móviles.
class ModulesGrid extends StatelessWidget {
  final List<Module> modules;
  final Widget Function(Module module) cardBuilder;

  const ModulesGrid({
    super.key,
    required this.modules,
    required this.cardBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: modules
          .map((m) => Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: cardBuilder(m),
              ))
          .toList(),
    );
  }
}
