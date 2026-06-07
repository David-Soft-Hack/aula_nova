import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../config/theme/app_theme.dart';
import '../../../database/daos.dart';
import '../../../providers/bitacora_providers.dart';
import '../bitacora_attendance_view.dart';

class BitacoraAttendanceCard extends ConsumerWidget {
  final BitacoraWithModule bitacoraWithModule;

  const BitacoraAttendanceCard({
    super.key,
    required this.bitacoraWithModule,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final bitacora = bitacoraWithModule.bitacora;
    final module = bitacoraWithModule.module;

    final sessionsAsync = ref.watch(calendarioStreamProvider(bitacora.id));

    return sessionsAsync.when(
      loading: () => const Card(
        margin: EdgeInsets.only(bottom: 16),
        child: SizedBox(
          height: 140,
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (e, _) => Card(
        margin: const EdgeInsets.only(bottom: 16),
        child: SizedBox(
          height: 140,
          child: Center(child: Text('Error: $e')),
        ),
      ),
      data: (sessions) {
        final totalSessions = sessions.length;
        final completedSessions = sessions.where((s) => s.estadoImpartido).length;
        final progress = totalSessions > 0 ? (completedSessions / totalSessions) : 0.0;

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(color: Colors.grey.shade100),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => BitacoraAttendanceView(
                      bitacoraWithModule: bitacoraWithModule,
                    ),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppTheme.academic100,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Grupo ${bitacora.codigoGrupo ?? 'N/A'}',
                            style: const TextStyle(
                              color: AppTheme.academic800,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        if (bitacora.turno != null && bitacora.turno!.isNotEmpty)
                          Row(
                            children: [
                              const Icon(LucideIcons.sun, size: 14, color: Colors.orange),
                              const SizedBox(width: 4),
                              Text(
                                bitacora.turno!,
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      module.nombre,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Outfit',
                        color: AppTheme.slate900,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      bitacora.carrera,
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Divider(height: 1),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Progreso de Sesiones',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '$completedSessions / $totalSessions',
                          style: const TextStyle(
                            color: AppTheme.academic600,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.grey.shade100,
                        valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.academic600),
                        minHeight: 6,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
