import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import '../../../../config/theme/app_theme.dart';
import '../../../../database/app_database.dart';
import 'session_detail_bottom_sheet.dart';

class BitacoraSessionItem extends StatelessWidget {
  final CalendarioBitacora session;
  final int index;
  final bool usarHorasReloj;
  final Function(int, bool) onToggleCompleted;
  final Future<void> Function(int, CalendarioBitacora) onSessionUpdated;

  const BitacoraSessionItem({
    super.key,
    required this.session,
    required this.index,
    required this.usarHorasReloj,
    required this.onToggleCompleted,
    required this.onSessionUpdated,
  });

  // Extract relative unit code (e.g., "MF-U1" -> "UD1")
  String _getRelativeUnitCode(String fullCode) {
    String part = fullCode;
    if (fullCode.contains('-')) {
      part = fullCode.split('-').last.trim();
    }
    if (part.startsWith('UD')) {
      return part;
    }
    if (part.startsWith('U')) {
      return 'UD${part.substring(1)}';
    }
    return part;
  }

  // Extract relative activity code (e.g., "MF-U1-A1 (Cont.)" -> "A1 (Cont.)")
  String _getRelativeActivityCode(String fullCode) {
    final isCont = fullCode.contains('(Cont.)');
    String cleanCode = fullCode.replaceAll(' (Cont.)', '').trim();
    if (cleanCode.contains('-')) {
      cleanCode = cleanCode.split('-').last.trim();
    }
    return isCont ? '$cleanCode (Cont.)' : cleanCode;
  }

  void _openDetail(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SessionDetailBottomSheet(
        session: session,
        sessionNumber: index + 1,
        usarHorasReloj: usarHorasReloj,
        onSave: (updated) => onSessionUpdated(index, updated),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat(
      'EEEE, dd MMMM',
      'es',
    ).format(session.fechaProgramada ?? DateTime.now());
    final displayUnit = _getRelativeUnitCode(session.codUnidad ?? '');
    final displayAct = _getRelativeActivityCode(session.codActividad ?? '');
    final hasDocument = session.rutaDocumento != null &&
        session.rutaDocumento!.isNotEmpty;

    return InkWell(
      onTap: () => _openDetail(context),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: session.esEvaluativa
                ? const Color(0xFFFBD0A0)
                : Colors.grey.shade200,
            width: session.esEvaluativa ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          children: [
            // Checkbox
            Checkbox(
              value: session.estadoImpartido,
              activeColor: AppTheme.academic600,
              onChanged: (val) {
                if (val != null) {
                  onToggleCompleted(index, val);
                }
              },
            ),
            const SizedBox(width: 12),

            // Session info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date row
                  Text(
                    dateStr.toUpperCase(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: session.estadoImpartido
                          ? Colors.grey
                          : AppTheme.academic700,
                      decoration: session.estadoImpartido
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Unit/Activity
                  Text(
                    'Actividades: $displayUnit - $displayAct',
                    style:
                        TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),

                  // Hours
                  Row(
                    children: [
                      const Icon(LucideIcons.clock,
                          size: 12, color: Colors.grey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          usarHorasReloj
                              ? '${session.horaImpartir ?? 0} HR (Reloj)'
                              : '${session.horaImpartir ?? 0} HA (Académica)',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade500,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  // Badges row
                  if (session.esEvaluativa) ...[
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        // Evaluativa badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF7ED),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: const Color(0xFFFBD0A0)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                LucideIcons.clipboardList,
                                size: 10,
                                color: Color(0xFFEA580C),
                              ),
                              const SizedBox(width: 4),
                              const Text(
                                'Evaluativa',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFFEA580C),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Score badge
                        if (session.puntaje != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF7ED),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: const Color(0xFFFBD0A0)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  LucideIcons.star,
                                  size: 10,
                                  color: Color(0xFFEA580C),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${session.puntaje!.toStringAsFixed(1)} pts',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFFEA580C),
                                  ),
                                ),
                              ],
                            ),
                          ),

                        // Document badge
                        if (hasDocument)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppTheme.academic50,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: AppTheme.academic100),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  LucideIcons.fileText,
                                  size: 10,
                                  color: AppTheme.academic600,
                                ),
                                const SizedBox(width: 4),
                                const Text(
                                  'Documento',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.academic600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            ),

            // Detail arrow
            const SizedBox(width: 8),
            Icon(
              LucideIcons.chevronRight,
              size: 18,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }
}
