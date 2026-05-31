import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../config/theme/app_theme.dart';
import '../../../database/app_database.dart';
import '../../../database/daos.dart';
import '../../../models/database_provider.dart';
import 'bitacora_delete_dialog.dart';

/// Tarjeta de bitácora — compacta y eficiente en espacio.
/// Al tocarla abre el diálogo de gestión de sesiones.
class BitacoraCard extends StatelessWidget {
  final BitacoraWithModule item;
  final void Function(List<CalendarioBitacora> sessions) onManage;

  const BitacoraCard({super.key, required this.item, required this.onManage});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bitacora = item.bitacora;
    final module = item.module;

    return StreamBuilder<List<CalendarioBitacora>>(
      stream: DatabaseProvider.bitacoraDao.watchCalendarioForBitacora(
        bitacora.id,
      ),
      builder: (context, snapshot) {
        final sessions = snapshot.data ?? [];
        final totalSessions = sessions.length;
        final completedSessions = sessions.where((s) => s.estadoImpartido).length;
        final progress = totalSessions == 0 ? 0.0 : (completedSessions / totalSessions);

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.01),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => onManage(sessions),
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.academic50,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  'GRUPO ${bitacora.codigoGrupo ?? "N/A"}',
                                  style: const TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.academic700,
                                  ),
                                ),
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
                          constraints: const BoxConstraints(),
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
              ),
            ),
          ),
        );
      },
    );
  }
}
