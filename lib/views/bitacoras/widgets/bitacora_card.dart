import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../config/theme/app_theme.dart';
import '../../../database/app_database.dart';
import '../../../database/daos.dart';
import '../../../providers/bitacora_providers.dart';
import '../../shared/app_card.dart';
import '../../shared/app_badge.dart';
import 'bitacora_delete_dialog.dart';

class BitacoraCard extends ConsumerWidget {
  final BitacoraWithModule item;
  final void Function(List<CalendarioBitacora> sessions) onManage;

  const BitacoraCard({super.key, required this.item, required this.onManage});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final bitacora = item.bitacora;
    final module = item.module;
    final calendarioAsync = ref.watch(calendarioStreamProvider(bitacora.id));

    return calendarioAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (sessions) {
        final totalSessions = sessions.length;
        final completedSessions = sessions.where((s) => s.estadoImpartido).length;
        final progress = totalSessions == 0 ? 0.0 : (completedSessions / totalSessions);

        return AppCard(
          borderRadius: 16,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          onTap: () => onManage(sessions),
          borderSide: BorderSide(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.01),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Fila superior: Grupo, Carrera y Botón eliminar
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppBadge(
                                label: 'GRUPO ${bitacora.codigoGrupo ?? "N/A"}',
                                color: AppTheme.academic700,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                bitacora.carrera.toUpperCase(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 9,
                                  color: Colors.grey.shade500,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(LucideIcons.trash2, color: Colors.red, size: 18),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                          visualDensity: VisualDensity.compact,
                          splashRadius: 20,
                          tooltip: 'Eliminar Bitácora',
                          onPressed: () => confirmDeleteBitacora(context, bitacora),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Nombre del módulo con indicador visual de navegación
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            module.nombre,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Outfit',
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          LucideIcons.chevronRight,
                          color: AppTheme.academic600,
                          size: 20,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Progreso
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '$completedSessions de $totalSessions sesiones',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '${(progress * 100).toStringAsFixed(0)}%',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.academic700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 5,
                        backgroundColor: Colors.grey.shade100,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppTheme.academic500,
                        ),
                      ),
                  ),
                ],
              ),
      );
      },
    );
  }
}
