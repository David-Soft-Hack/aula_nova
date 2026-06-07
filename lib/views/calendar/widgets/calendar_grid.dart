import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../config/theme/app_theme.dart';
import '../../../config/theme/shift_colors.dart';
import '../../../database/daos.dart';
import '../../../providers/calendar_providers.dart';
import 'session_card.dart';

class CalendarGrid extends ConsumerWidget {
  final DateTime activeMonth;
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;
  final void Function(TodaySessionData) onSessionTap;

  const CalendarGrid({
    super.key,
    required this.activeMonth,
    required this.selectedDate,
    required this.onDateSelected,
    required this.onSessionTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firstDay = DateTime(activeMonth.year, activeMonth.month, 1);
    final totalDays = DateTime(activeMonth.year, activeMonth.month + 1, 0).day;
    final weekdayOfFirst = firstDay.weekday;

    final prevMonthEnd = firstDay.subtract(const Duration(days: 1));
    final paddingDays = weekdayOfFirst - 1;

    final List<DateTime> calendarCells = [];

    for (int i = paddingDays - 1; i >= 0; i--) {
      calendarCells.add(
        DateTime(prevMonthEnd.year, prevMonthEnd.month, prevMonthEnd.day - i),
      );
    }

    for (int i = 1; i <= totalDays; i++) {
      calendarCells.add(DateTime(activeMonth.year, activeMonth.month, i));
    }

    final totalCellsNeeded = calendarCells.length <= 35 ? 35 : 42;
    final remainingPadding = totalCellsNeeded - calendarCells.length;
    for (int i = 1; i <= remainingPadding; i++) {
      calendarCells.add(DateTime(activeMonth.year, activeMonth.month + 1, i));
    }

    final filteredSessions = ref.watch(filteredCalendarSessionsProvider);
    final daySessions = ref.watch(sessionsForSelectedDateProvider);
    final now = DateTime.now();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Month header ───────────────────────────────────────────────
          _MonthHeader(activeMonth: activeMonth, ref: ref),

          // ── Weekday labels ─────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: ['LUN', 'MAR', 'MIÉ', 'JUE', 'VIE', 'SÁB', 'DOM']
                  .map(
                    (day) => Expanded(
                      child: Text(
                        day,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: day == 'SÁB' || day == 'DOM'
                              ? Colors.grey.shade400
                              : Colors.grey.shade500,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: 6),

          // ── Calendar grid ──────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                childAspectRatio: 0.82,
              ),
              itemCount: calendarCells.length,
              itemBuilder: (context, index) {
                final cellDate = calendarCells[index];
                final isCurrentMonth = cellDate.month == activeMonth.month;
                final isSelected =
                    cellDate.year == selectedDate.year &&
                    cellDate.month == selectedDate.month &&
                    cellDate.day == selectedDate.day;
                final isToday =
                    cellDate.year == now.year &&
                    cellDate.month == now.month &&
                    cellDate.day == now.day;
                final isWeekend = cellDate.weekday >= 6;

                final matches = filteredSessions.where((s) {
                  final date = s.entry.fechaProgramada;
                  if (date == null) return false;
                  return date.year == cellDate.year &&
                      date.month == cellDate.month &&
                      date.day == cellDate.day;
                }).toList();

                return _CalendarCell(
                  date: cellDate,
                  isCurrentMonth: isCurrentMonth,
                  isSelected: isSelected,
                  isToday: isToday,
                  isWeekend: isWeekend,
                  sessions: matches,
                  onTap: () => onDateSelected(cellDate),
                );
              },
            ),
          ),

          const SizedBox(height: 12),

          // ── Legend ─────────────────────────────────────────────────────
          _ShiftLegend(sessions: filteredSessions),

          // ── Divider + selected day sessions ────────────────────────────
          const SizedBox(height: 8),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Colors.grey.shade200,
                  Colors.transparent,
                ],
              ),
            ),
          ),
          _DaySessionsSection(
            selectedDate: selectedDate,
            sessions: daySessions,
            onSessionTap: onSessionTap,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ── Month navigation header ──────────────────────────────────────────────────

class _MonthHeader extends StatelessWidget {
  final DateTime activeMonth;
  final WidgetRef ref;

  const _MonthHeader({required this.activeMonth, required this.ref});

  @override
  Widget build(BuildContext context) {
    final label = toBeginningOfSentenceCase(
      DateFormat('MMMM yyyy', 'es').format(activeMonth),
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 12, 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF0F172A),
                    letterSpacing: -0.3,
                  ),
                ),
              ],
            ),
          ),
          // Today button
          TextButton.icon(
            onPressed: () {
              final today = DateTime.now();
              ref.read(activeMonthProvider.notifier).state = DateTime(
                today.year,
                today.month,
                1,
              );
              ref.read(selectedDateProvider.notifier).state = today;
            },
            icon: const Icon(LucideIcons.calendarCheck, size: 14),
            label: const Text(
              'Hoy',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
            ),
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.academic600,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              backgroundColor: AppTheme.academic50,
            ),
          ),
          const SizedBox(width: 4),
          _NavButton(
            icon: LucideIcons.chevronLeft,
            onTap: () {
              ref.read(activeMonthProvider.notifier).state = DateTime(
                activeMonth.year,
                activeMonth.month - 1,
                1,
              );
            },
          ),
          const SizedBox(width: 4),
          _NavButton(
            icon: LucideIcons.chevronRight,
            onTap: () {
              ref.read(activeMonthProvider.notifier).state = DateTime(
                activeMonth.year,
                activeMonth.month + 1,
                1,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _NavButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 18, color: Colors.grey.shade700),
      ),
    );
  }
}

// ── Calendar cell ─────────────────────────────────────────────────────────────

class _CalendarCell extends StatelessWidget {
  final DateTime date;
  final bool isCurrentMonth;
  final bool isSelected;
  final bool isToday;
  final bool isWeekend;
  final List<TodaySessionData> sessions;
  final VoidCallback onTap;

  const _CalendarCell({
    required this.date,
    required this.isCurrentMonth,
    required this.isSelected,
    required this.isToday,
    required this.isWeekend,
    required this.sessions,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Collect unique shift colors for dot indicators
    final shiftDots = _buildShiftDots();

    final bgColor = isSelected
        ? AppTheme.academic600
        : isToday
        ? AppTheme.academic100
        : isWeekend && isCurrentMonth
        ? const Color(0xFFF8FAFC)
        : Colors.transparent;

    final textColor = isSelected
        ? Colors.white
        : isCurrentMonth
        ? (isWeekend ? Colors.grey.shade500 : const Color(0xFF0F172A))
        : Colors.grey.shade300;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: isToday && !isSelected
              ? Border.all(color: AppTheme.academic500, width: 1.5)
              : null,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppTheme.academic600.withValues(alpha: 0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Day number
            Text(
              date.day.toString(),
              style: TextStyle(
                fontSize: 13,
                fontFamily: 'Outfit',
                fontWeight: isSelected || isToday
                    ? FontWeight.w800
                    : FontWeight.w500,
                color: textColor,
              ),
            ),
            const SizedBox(height: 2),
            // Shift dots row
            if (shiftDots.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: shiftDots,
              )
            else
              const SizedBox(height: 6),
          ],
        ),
      ),
    );
  }

  /// Builds up to 3 colored dots representing distinct shift types for this day.
  List<Widget> _buildShiftDots() {
    if (sessions.isEmpty) return [];

    // Group sessions by meaningful type: evaluativa, impartida, or by turno
    final seenColors = <Color>{};
    final dots = <Widget>[];

    // Priority: evaluativa (orange) first
    if (sessions.any((s) => s.entry.esEvaluativa && !s.entry.estadoImpartido)) {
      seenColors.add(const Color(0xFFF97316));
    }
    // Then impartida (green)
    if (sessions.any((s) => s.entry.estadoImpartido)) {
      seenColors.add(const Color(0xFF10B981));
    }
    // Then by shift
    for (final s in sessions) {
      if (!s.entry.estadoImpartido && !s.entry.esEvaluativa) {
        final color = ShiftColors.accent(s.turno);
        seenColors.add(color);
      }
      if (seenColors.length >= 3) break;
    }

    for (final color in seenColors.take(3)) {
      if (dots.isNotEmpty) dots.add(const SizedBox(width: 2));
      dots.add(
        _ShiftDot(
          color: isSelected ? Colors.white.withValues(alpha: 0.8) : color,
        ),
      );
    }

    return dots;
  }
}

class _ShiftDot extends StatelessWidget {
  final Color color;
  const _ShiftDot({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 5,
      height: 5,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}

// ── Shift legend ──────────────────────────────────────────────────────────────

class _ShiftLegend extends StatelessWidget {
  final List<TodaySessionData> sessions;

  const _ShiftLegend({required this.sessions});

  @override
  Widget build(BuildContext context) {
    // Collect unique turnos that appear in sessions
    final seenTurnos = <String?>{};
    for (final s in sessions) {
      seenTurnos.add(s.turno);
    }

    final hasEvaluativa = sessions.any((s) => s.entry.esEvaluativa);
    final hasImpartida = sessions.any((s) => s.entry.estadoImpartido);

    final legendItems = <Widget>[];

    if (hasImpartida) {
      legendItems.add(
        _LegendDot(color: const Color(0xFF10B981), label: 'Impartida'),
      );
    }
    if (hasEvaluativa) {
      legendItems.add(
        _LegendDot(color: const Color(0xFFF97316), label: 'Evaluación'),
      );
    }
    for (final turno in seenTurnos) {
      if (turno != null) {
        legendItems.add(
          _LegendDot(color: ShiftColors.accent(turno), label: turno),
        );
      }
    }

    if (legendItems.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: Wrap(spacing: 12, runSpacing: 6, children: legendItems),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}

// ── Day sessions section ──────────────────────────────────────────────────────

class _DaySessionsSection extends StatelessWidget {
  final DateTime selectedDate;
  final List<TodaySessionData> sessions;
  final void Function(TodaySessionData) onSessionTap;

  const _DaySessionsSection({
    required this.selectedDate,
    required this.sessions,
    required this.onSessionTap,
  });

  @override
  Widget build(BuildContext context) {
    final dateStr = toBeginningOfSentenceCase(
      DateFormat("EEEE d 'de' MMMM", 'es').format(selectedDate),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dateStr,
                      style: const TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF334155),
                      ),
                    ),
                  ],
                ),
              ),
              if (sessions.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.academic50,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppTheme.academic100),
                  ),
                  child: Text(
                    '${sessions.length} ${sessions.length == 1 ? 'clase' : 'clases'}',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.academic700,
                    ),
                  ),
                ),
            ],
          ),
        ),

        // Content
        if (sessions.isEmpty)
          _EmptyDay()
        else ...[
          const SizedBox(height: 12),
          // Group by turno for visual clarity
          ..._buildGroupedSessions(),
        ],
      ],
    );
  }

  List<Widget> _buildGroupedSessions() {
    // Sort sessions by turno then by evaluativa status
    final sorted = List<TodaySessionData>.from(sessions);
    sorted.sort((a, b) {
      if (a.turno != b.turno) {
        return (a.turno ?? '').compareTo(b.turno ?? '');
      }
      if (a.entry.esEvaluativa != b.entry.esEvaluativa) {
        return a.entry.esEvaluativa ? -1 : 1;
      }
      return 0;
    });

    // Group by turno
    final grouped = <String?, List<TodaySessionData>>{};
    for (final s in sorted) {
      grouped.putIfAbsent(s.turno, () => []).add(s);
    }

    final widgets = <Widget>[];

    for (final entry in grouped.entries) {
      final turno = entry.key;
      final group = entry.value;

      // Show turno header if there are multiple turnos
      if (grouped.length > 1 && turno != null) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 6),
            child: Row(
              children: [
                Icon(
                  ShiftColors.icon(turno),
                  size: 13,
                  color: ShiftColors.accent(turno),
                ),
                const SizedBox(width: 6),
                Text(
                  turno,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: ShiftColors.accent(turno),
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    height: 1,
                    color: ShiftColors.accent(turno).withValues(alpha: 0.15),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${group.length} clase${group.length > 1 ? 's' : ''}',
                  style: TextStyle(fontSize: 10, color: Colors.grey.shade400),
                ),
              ],
            ),
          ),
        );
      } else {
        widgets.add(const SizedBox(height: 8));
      }

      for (final s in group) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SessionCard(session: s, onTap: () => onSessionTap(s)),
          ),
        );
      }
    }

    return widgets;
  }
}

class _EmptyDay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 36),
      child: Center(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                LucideIcons.calendarX2,
                size: 32,
                color: Colors.grey.shade300,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Sin clases este día',
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Colors.grey.shade400,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Selecciona otra fecha para ver sesiones',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
            ),
          ],
        ),
      ),
    );
  }
}
