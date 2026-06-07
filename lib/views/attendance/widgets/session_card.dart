import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../config/theme/app_theme.dart';
import '../../../database/app_database.dart';
import '../../../database/daos.dart';
import '../../shared/app_snackbar.dart';
import '../take_attendance_screen.dart';

class SessionCard extends ConsumerWidget {
  final CalendarioBitacora session;
  final BitacoraWithModule bitacora;
  final int sessionNumber;

  const SessionCard({
    super.key,
    required this.session,
    required this.bitacora,
    required this.sessionNumber,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateStr = session.fechaProgramada != null
        ? DateFormat('EEEE, dd MMM yyyy', 'es').format(session.fechaProgramada!)
        : 'Fecha no definida';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: InkWell(
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
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppTheme.academic50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    'S$sessionNumber',
                    style: const TextStyle(
                      color: AppTheme.academic600,
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
                      'Actividad: ${session.codActividad ?? 'Sin Actividad'}',
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(LucideIcons.calendar, size: 14, color: Colors.grey.shade500),
                        const SizedBox(width: 4),
                        Text(dateStr, style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(LucideIcons.chevronRight, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
