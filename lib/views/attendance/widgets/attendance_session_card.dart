import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../config/theme/app_theme.dart';
import '../../../database/app_database.dart';
import '../../../database/daos.dart';
import '../../shared/app_snackbar.dart';
import '../take_attendance_screen.dart';

class AttendanceSessionCard extends ConsumerWidget {
  final CalendarioBitacora session;
  final BitacoraWithModule bitacora;
  final int sessionNumber;

  const AttendanceSessionCard({
    super.key,
    required this.session,
    required this.bitacora,
    required this.sessionNumber,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final dateStr = session.fechaProgramada != null
        ? DateFormat('EEEE, dd MMMM yyyy', 'es').format(session.fechaProgramada!)
        : 'Fecha no definida';

    // Build visual states for attendance:
    // If it's imparted, we can assume attendance might be registered.
    // Let's color-code based on whether the session is imparted.
    final bool isCompleted = session.estadoImpartido;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCompleted ? Colors.green.shade100 : Colors.grey.shade200,
          width: isCompleted ? 1.5 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            if (bitacora.bitacora.codigoGrupo == null) {
              AppSnackbar.showWarning(context, 'Esta bitácora no tiene un grupo asignado.');
              return;
            }
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => TakeAttendanceScreen(
                  session: session,
                  groupCode: bitacora.bitacora.codigoGrupo!,
                  moduleName: bitacora.module.nombre,
                  sessionNumber: sessionNumber,
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: isCompleted ? Colors.green.shade50 : AppTheme.academic50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      'S$sessionNumber',
                      style: TextStyle(
                        color: isCompleted ? Colors.green.shade700 : AppTheme.academic700,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dateStr,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.slate900,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(LucideIcons.tag, size: 14, color: Colors.grey.shade400),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              'Actividad: ${session.codActividad ?? 'Sin Actividad'}',
                              style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 13,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isCompleted ? Colors.green.shade100 : Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        isCompleted ? 'Impartida' : 'Pendiente',
                        style: TextStyle(
                          color: isCompleted ? Colors.green.shade800 : Colors.orange.shade800,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 8),
                const Icon(LucideIcons.chevronRight, color: Colors.grey, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
