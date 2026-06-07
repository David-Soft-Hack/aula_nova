import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../config/theme/app_theme.dart';
import '../../../database/app_database.dart';
import '../../../providers/module_providers.dart';
import '../../shared/app_badge.dart';

/// Tarjeta de módulo con información de horas, unidades y carrera.
class ModuleCard extends StatelessWidget {
  final Module module;
  final VoidCallback onOptions;
  final VoidCallback onManage;

  const ModuleCard({
    super.key,
    required this.module,
    required this.onOptions,
    required this.onManage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Franja de color superior
            Container(
              height: 4,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppTheme.academic500, AppTheme.academic700],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Fila superior: Código y opciones
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AppBadge(
                        label: module.codModule,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.0,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        borderRadius: 8,
                      ),
                      IconButton(
                        style: IconButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(32, 32),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        icon: const Icon(LucideIcons.moreHorizontal, size: 18),
                        color: Colors.grey.shade400,
                        onPressed: onOptions,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Nombre del módulo
                  Text(
                    module.nombre,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                      fontSize: 17,
                      color: AppTheme.slate900,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Tag de carrera
                  if (module.carrera != null) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade100),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            LucideIcons.graduationCap,
                            size: 13,
                            color: AppTheme.academic500,
                          ),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              module.carrera!.toUpperCase(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 8.5,
                                fontWeight: FontWeight.w800,
                                color: Colors.grey.shade600,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Grid de horas
                  _HoursGrid(module: module),
                  const SizedBox(height: 16),

                  // Unidades
                  _UnitsIndicator(module: module),
                ],
              ),
            ),

            // Barra inferior de acción
            InkWell(
              onTap: onManage,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: AppTheme.academic50.withValues(alpha: 0.4),
                  border: Border(top: BorderSide(color: Colors.grey.shade100)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'GESTIONAR UNIDADES',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        color: AppTheme.academic600,
                        letterSpacing: 1.2,
                      ),
                    ),
                    SizedBox(width: 6),
                    Icon(
                      LucideIcons.chevronRight,
                      size: 13,
                      color: AppTheme.academic600,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Widget auxiliar: Grid de horas ─────────────────────────────────────────
class _HoursGrid extends StatelessWidget {
  final Module module;
  const _HoursGrid({required this.module});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _HourCard(
          icon: LucideIcons.bookOpen,
          label: 'H. Reloj',
          value: '${module.totalHoraReloj}',
          unit: 'ha',
        ),
        const SizedBox(width: 12),
        _HourCard(
          icon: LucideIcons.clock,
          label: 'H. ACADÉMICAS',
          value: '${module.totalHoraAcademic}',
          unit: 'hr',
        ),
      ],
    );
  }
}

class _HourCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String unit;

  const _HourCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppTheme.slate50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 10, color: Colors.grey.shade500),
                const SizedBox(width: 4),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 7.5,
                    fontWeight: FontWeight.w800,
                    color: Colors.grey,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: AppTheme.slate900,
                  ),
                ),
                const SizedBox(width: 2),
                Text(
                  unit,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Widget auxiliar: Indicador de unidades ──────────────────────────────────
class _UnitsIndicator extends ConsumerWidget {
  final Module module;
  const _UnitsIndicator({required this.module});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<List<Unit>>(
      future: ref.read(moduleControllerProvider).getUnitsByModule(module.codModule),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Row(
            children: [
              SizedBox(
                width: 12,
                height: 12,
                child: CircularProgressIndicator(
                  strokeWidth: 1.5,
                  color: Colors.grey.shade300,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                'Cargando...',
                style: TextStyle(fontSize: 9, color: Colors.grey.shade400),
              ),
            ],
          );
        }

        final units = snapshot.data ?? [];

        if (units.isEmpty) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.amber.shade50,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.amber.shade100),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  LucideIcons.alertTriangle,
                  size: 10,
                  color: Colors.amber.shade700,
                ),
                const SizedBox(width: 4),
                Text(
                  'Sin unidades',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber.shade800,
                  ),
                ),
              ],
            ),
          );
        }

        const displayLimit = 3;
        final displayUnits = units.take(displayLimit).toList();
        final hasMore = units.length > displayLimit;

        return Row(
          children: [
            ...displayUnits.asMap().entries.map((entry) {
              final idx = entry.key + 1;
              return Container(
                margin: const EdgeInsets.only(right: 4),
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Center(
                  child: Text(
                    'U$idx',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              );
            }),
            if (hasMore)
              Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  color: AppTheme.academic600,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '+${units.length - displayLimit}',
                    style: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            else
              AppBadge(
                label: '${units.length} ${units.length == 1 ? 'UD' : 'UDs'}',
                fontSize: 8.5,
                fontWeight: FontWeight.w900,
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              ),
          ],
        );
      },
    );
  }
}
