import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../config/theme/app_theme.dart';
import '../../../../database/app_database.dart';

class SessionDetailHeader extends StatelessWidget {
  final CalendarioBitacora session;
  final int sessionNumber;
  final bool usarHorasReloj;

  const SessionDetailHeader({
    super.key,
    required this.session,
    required this.sessionNumber,
    required this.usarHorasReloj,
  });

  String _getRelativeUnitCode(String? fullCode) {
    if (fullCode == null || fullCode.isEmpty) return '—';
    String part = fullCode;
    if (fullCode.contains('-')) part = fullCode.split('-').last.trim();
    if (part.startsWith('UD')) return part;
    if (part.startsWith('U')) return 'UD${part.substring(1)}';
    return part;
  }

  String _getRelativeActivityCode(String? fullCode) {
    if (fullCode == null || fullCode.isEmpty) return '—';
    final isCont = fullCode.contains('(Cont.)');
    String cleanCode = fullCode.replaceAll(' (Cont.)', '').trim();
    if (cleanCode.contains('-')) cleanCode = cleanCode.split('-').last.trim();
    return isCont ? '$cleanCode (Cont.)' : cleanCode;
  }

  Widget _infoRow(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 13, color: AppTheme.academic600),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            label,
            style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('EEEE, dd MMMM yyyy', 'es')
        .format(session.fechaProgramada ?? DateTime.now());
    final displayUnit = _getRelativeUnitCode(session.codUnidad);
    final displayAct = _getRelativeActivityCode(session.codActividad);
    final horaLabel = usarHorasReloj
        ? '${session.horaImpartir ?? 0} HR (Reloj)'
        : '${session.horaImpartir ?? 0} HA (Académica)';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.academic50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.academic100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.academic600,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'SESIÓN $sessionNumber',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const Spacer(),
              if (session.estadoImpartido)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.green.shade200),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(LucideIcons.checkCircle2,
                          size: 12, color: Colors.green.shade600),
                      const SizedBox(width: 4),
                      Text('Impartida',
                          style: TextStyle(
                              fontSize: 11,
                              color: Colors.green.shade700,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            dateStr,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: AppTheme.academic700,
            ),
          ),
          const SizedBox(height: 8),
          _infoRow(LucideIcons.bookOpen, '$displayUnit — $displayAct'),
          const SizedBox(height: 4),
          _infoRow(LucideIcons.clock, horaLabel),
        ],
      ),
    );
  }
}
