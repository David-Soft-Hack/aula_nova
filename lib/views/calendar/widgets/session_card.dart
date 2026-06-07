import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../config/theme/shift_colors.dart';
import '../../../database/daos.dart';

class SessionCard extends StatelessWidget {
  final TodaySessionData session;
  final VoidCallback onTap;

  const SessionCard({
    super.key,
    required this.session,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final s = session;
    final date = s.entry.fechaProgramada;
    final dayStr = date != null ? date.day.toString() : '--';
    final weekdayStr = date != null
        ? DateFormat('EEE', 'es').format(date).toUpperCase().replaceAll('.', '')
        : '---';
    final timeStr = date != null ? DateFormat('HH:mm', 'es').format(date) : null;

    // Status-based color (highest priority: impartida > evaluativa > turno)
    final Color accentColor;
    final Color accentBg;
    if (s.entry.estadoImpartido) {
      accentColor = const Color(0xFF10B981);
      accentBg = const Color(0xFFECFDF5);
    } else if (s.entry.esEvaluativa) {
      accentColor = const Color(0xFFF97316);
      accentBg = const Color(0xFFFFF7ED);
    } else {
      // Use shift color for pending classes
      accentColor = ShiftColors.accent(s.turno);
      accentBg = ShiftColors.background(s.turno);
    }

    final String statusLabel;
    final IconData statusIcon;
    final Color statusTextColor;
    if (s.entry.estadoImpartido) {
      statusLabel = 'Impartida';
      statusIcon = LucideIcons.checkCircle2;
      statusTextColor = const Color(0xFF10B981);
    } else if (s.entry.esEvaluativa) {
      statusLabel = 'Evaluación';
      statusIcon = LucideIcons.award;
      statusTextColor = const Color(0xFFF97316);
    } else {
      statusLabel = 'Pendiente';
      statusIcon = LucideIcons.clock4;
      statusTextColor = accentColor;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: 0.10),
            blurRadius: 20,
            spreadRadius: 0,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(22),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(22),
          splashColor: accentColor.withValues(alpha: 0.06),
          highlightColor: accentColor.withValues(alpha: 0.03),
          child: IntrinsicHeight(
            child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Left date panel ──────────────────────────────────────
              Container(
                width: 76,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [accentBg, accentBg.withValues(alpha: 0.6)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(22),
                    bottomLeft: Radius.circular(22),
                  ),
                ),
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      weekdayStr,
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                        color: accentColor.withValues(alpha: 0.65),
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      dayStr,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'Outfit',
                        height: 1,
                        color: accentColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Turno icon
                    Icon(
                      ShiftColors.icon(s.turno),
                      size: 14,
                      color: accentColor.withValues(alpha: 0.5),
                    ),
                    if (timeStr != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        timeStr,
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: accentColor.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // ── Accent divider ────────────────────────────────────────
              Container(
                width: 3,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      accentColor.withValues(alpha: 0.0),
                      accentColor.withValues(alpha: 0.7),
                      accentColor.withValues(alpha: 0.0),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),

              // ── Main content ──────────────────────────────────────────
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 14, 10, 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Title row + status badge
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              s.moduleName,
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 14,
                                color: Color(0xFF0F172A),
                                fontFamily: 'Outfit',
                                height: 1.25,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 6),
                          _StatusBadge(
                            icon: statusIcon,
                            label: statusLabel,
                            color: statusTextColor,
                            bgColor: s.entry.estadoImpartido
                                ? const Color(0xFFECFDF5)
                                : s.entry.esEvaluativa
                                    ? const Color(0xFFFFF7ED)
                                    : accentBg,
                          ),
                        ],
                      ),
                      const SizedBox(height: 9),

                      // Tags row: career, group, turno
                      Wrap(
                        spacing: 5,
                        runSpacing: 5,
                        children: [
                          _MiniTag(
                            icon: LucideIcons.graduationCap,
                            text: s.career,
                            color: const Color(0xFF475569),
                            bgColor: const Color(0xFFF1F5F9),
                          ),
                          if (s.groupCode != null)
                            _MiniTag(
                              icon: LucideIcons.users,
                              text: 'G-${s.groupCode}',
                              color: const Color(0xFF4F46E5),
                              bgColor: const Color(0xFFEEF2FF),
                            ),
                          if (s.turno != null)
                            _MiniTag(
                              icon: ShiftColors.icon(s.turno),
                              text: s.turno!,
                              color: ShiftColors.accent(s.turno),
                              bgColor: ShiftColors.background(s.turno),
                              isBold: true,
                            ),
                        ],
                      ),
                      const SizedBox(height: 9),

                      // Activity + divider
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: accentBg,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              s.entry.esEvaluativa
                                  ? LucideIcons.clipboardList
                                  : LucideIcons.bookOpen,
                              size: 11,
                              color: accentColor,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              s.entry.codActividad ?? 'Sin actividad asignada',
                              style: TextStyle(
                                fontSize: 11.5,
                                color: Colors.grey.shade500,
                                fontStyle: s.entry.codActividad == null
                                    ? FontStyle.italic
                                    : FontStyle.normal,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),

                      // Completion progress bar (only if impartida)
                      if (s.entry.estadoImpartido) ...[
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: 1.0,
                                  minHeight: 3,
                                  backgroundColor: Colors.grey.shade100,
                                  valueColor: const AlwaysStoppedAnimation(Color(0xFF10B981)),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Completada',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                color: Colors.grey.shade400,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              // ── Chevron ───────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.only(right: 14),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: accentBg,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      LucideIcons.chevronRight,
                      color: accentColor.withValues(alpha: 0.6),
                      size: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }
}

// ── Reusable sub-widgets ──────────────────────────────────────────────────────

class _StatusBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color bgColor;

  const _StatusBadge({
    required this.icon,
    required this.label,
    required this.color,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w800,
              color: color,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniTag extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;
  final Color bgColor;
  final bool isBold;

  const _MiniTag({
    required this.icon,
    required this.text,
    required this.color,
    required this.bgColor,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10, color: color),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
