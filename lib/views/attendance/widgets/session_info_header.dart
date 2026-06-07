import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../config/theme/app_theme.dart';
import '../../../database/app_database.dart';

class SessionInfoHeader extends StatelessWidget {
  final String moduleName;
  final CalendarioBitacora session;

  const SessionInfoHeader({
    super.key,
    required this.moduleName,
    required this.session,
  });

  @override
  Widget build(BuildContext context) {
    final dateStr = session.fechaProgramada != null
        ? DateFormat('dd MMM yyyy', 'es').format(session.fechaProgramada!)
        : 'Sin fecha';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      color: AppTheme.academic50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            moduleName,
            style: const TextStyle(fontWeight: FontWeight.w600, color: AppTheme.academic800),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(LucideIcons.calendar, size: 14, color: AppTheme.academic600),
              const SizedBox(width: 4),
              Text(dateStr, style: const TextStyle(color: AppTheme.academic700)),
              const SizedBox(width: 16),
              Icon(LucideIcons.tag, size: 14, color: AppTheme.academic600),
              const SizedBox(width: 4),
              Text(session.codActividad ?? 'Sin actividad', style: const TextStyle(color: AppTheme.academic700)),
            ],
          ),
        ],
      ),
    );
  }
}
