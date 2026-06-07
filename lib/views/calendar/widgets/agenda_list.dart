import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../config/theme/app_theme.dart';
import '../../../config/theme/shift_colors.dart';
import '../../../database/daos.dart';
import '../../../providers/calendar_providers.dart';
import 'session_card.dart';

class AgendaList extends ConsumerWidget {
  final void Function(TodaySessionData) onSessionTap;

  const AgendaList({
    super.key,
    required this.onSessionTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessions = ref.watch(filteredCalendarSessionsProvider);

    if (sessions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(LucideIcons.calendarOff, size: 48, color: Colors.grey.shade300),
            ),
            const SizedBox(height: 16),
            Text(
              'No hay sesiones programadas',
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Colors.grey.shade400,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Ajusta los filtros para ver más resultados',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade400),
            ),
          ],
        ),
      );
    }

    // Group by month
    final grouped = <String, List<TodaySessionData>>{};
    for (final s in sessions) {
      final key = s.entry.fechaProgramada != null
          ? DateFormat('yyyy-MM', 'es').format(s.entry.fechaProgramada!)
          : 'sin-fecha';
      grouped.putIfAbsent(key, () => []).add(s);
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      physics: const BouncingScrollPhysics(),
      itemCount: grouped.length,
      itemBuilder: (context, monthIndex) {
        final monthKey = grouped.keys.elementAt(monthIndex);
        final monthSessions = grouped[monthKey]!;
        final firstDate = monthSessions.first.entry.fechaProgramada;

        final monthLabel = firstDate != null
            ? toBeginningOfSentenceCase(
                DateFormat('MMMM yyyy', 'es').format(firstDate))
            : 'Sin fecha';

        // Stats for this month
        final totalCount = monthSessions.length;
        final doneCount = monthSessions.where((s) => s.entry.estadoImpartido).length;
        final evalCount = monthSessions.where((s) => s.entry.esEvaluativa).length;

        // Group by day within the month
        final byDay = <String, List<TodaySessionData>>{};
        for (final s in monthSessions) {
          final dayKey = s.entry.fechaProgramada != null
              ? DateFormat('yyyy-MM-dd').format(s.entry.fechaProgramada!)
              : 'sin-fecha';
          byDay.putIfAbsent(dayKey, () => []).add(s);
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Month header card
            Container(
              margin: const EdgeInsets.only(top: 20, bottom: 12),
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppTheme.academic600, AppTheme.academic700],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.academic600.withValues(alpha: 0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      monthLabel,
                      style: const TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ),
                  _MonthStat(
                    icon: LucideIcons.calendarDays,
                    value: totalCount.toString(),
                    label: 'total',
                  ),
                  const SizedBox(width: 12),
                  _MonthStat(
                    icon: LucideIcons.checkCircle2,
                    value: doneCount.toString(),
                    label: 'impartidas',
                    color: const Color(0xFF6EE7B7),
                  ),
                  if (evalCount > 0) ...[
                    const SizedBox(width: 12),
                    _MonthStat(
                      icon: LucideIcons.award,
                      value: evalCount.toString(),
                      label: 'evaluaciones',
                      color: const Color(0xFFFED7AA),
                    ),
                  ],
                ],
              ),
            ),

            // Progress bar for the month
            if (doneCount > 0 && totalCount > 0)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Avance del mes',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: Colors.grey.shade500,
                          ),
                        ),
                        Text(
                          '${(doneCount / totalCount * 100).round()}%',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF10B981),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: doneCount / totalCount,
                        minHeight: 4,
                        backgroundColor: Colors.grey.shade100,
                        valueColor: const AlwaysStoppedAnimation(Color(0xFF10B981)),
                      ),
                    ),
                  ],
                ),
              ),

            // Sessions grouped by day
            for (final dayEntry in byDay.entries)
              _DayGroup(
                dayKey: dayEntry.key,
                sessions: dayEntry.value,
                onSessionTap: onSessionTap,
              ),
          ],
        );
      },
    );
  }
}

// ── Month stat chip ────────────────────────────────────────────────────────────

class _MonthStat extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _MonthStat({
    required this.icon,
    required this.value,
    required this.label,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 14, color: color.withValues(alpha: 0.8)),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: 16,
            fontWeight: FontWeight.w900,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 8,
            fontWeight: FontWeight.w600,
            color: color.withValues(alpha: 0.7),
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }
}

// ── Day group ──────────────────────────────────────────────────────────────────

class _DayGroup extends StatelessWidget {
  final String dayKey;
  final List<TodaySessionData> sessions;
  final void Function(TodaySessionData) onSessionTap;

  const _DayGroup({
    required this.dayKey,
    required this.sessions,
    required this.onSessionTap,
  });

  @override
  Widget build(BuildContext context) {
    final date = sessions.first.entry.fechaProgramada;
    final now = DateTime.now();
    final isToday = date != null &&
        date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;

    final dateLabel = date != null
        ? toBeginningOfSentenceCase(
            DateFormat("EEEE d", 'es').format(date))
        : 'Sin fecha';

    // Unique turnos for this day
    final turnos = sessions.map((s) => s.turno).whereType<String>().toSet();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Day row
        Padding(
          padding: const EdgeInsets.only(bottom: 8, top: 4),
          child: Row(
            children: [
              // Date pill
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: isToday ? AppTheme.academic600 : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  isToday ? 'Hoy · $dateLabel' : dateLabel,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: isToday ? Colors.white : Colors.grey.shade600,
                    fontFamily: 'Outfit',
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Turno color dots
              for (final t in turnos) ...[
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: ShiftColors.accent(t),
                  ),
                ),
                const SizedBox(width: 3),
              ],
              Expanded(
                child: Container(height: 1, color: Colors.grey.shade100),
              ),
            ],
          ),
        ),
        // Session cards
        for (final s in sessions)
          SessionCard(session: s, onTap: () => onSessionTap(s)),
        const SizedBox(height: 4),
      ],
    );
  }
}
