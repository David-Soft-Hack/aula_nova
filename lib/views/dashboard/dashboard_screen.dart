import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../database/daos.dart';
import '../../providers/dashboard_providers.dart';
import '../../providers/navigation_providers.dart';
import '../calendar/widgets/session_detail_dialog.dart';
import 'widgets/dashboard_header.dart';
import 'widgets/stats_grid.dart';
import 'widgets/active_sessions.dart';
import 'widgets/agenda_sidebar.dart';
import 'widgets/quick_actions.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  void _showSessionDetail(BuildContext context, TodaySessionData session) {
    showDialog(
      context: context,
      builder: (_) => SessionDetailDialog(sessionData: session),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final dateStr = toBeginningOfSentenceCase(
      DateFormat("EEEE, dd 'de' MMMM 'de' yyyy", 'es').format(now),
    );

    final totalModules = ref.watch(totalModulesProvider);
    final activeBitacoras = ref.watch(activeBitacorasProvider);
    final activeStudents = ref.watch(activeStudentsProvider);
    final totalHours = ref.watch(totalHoursProvider);
    final todaySessions = ref.watch(todaySessionsProvider);
    final upcomingSessions = ref.watch(upcomingSessionsProvider);
    final pendingSessions = ref.watch(pendingPastSessionsProvider);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DashboardHeader(dateStr: dateStr),
              const SizedBox(height: 20),

              // Banner de sesiones pendientes del pasado
              if (pendingSessions.valueOrNull?.isNotEmpty ?? false)
                _PendingSessionsBanner(
                  count: pendingSessions.valueOrNull!.length,
                  onTap: () => ref.read(appLayoutIndexProvider.notifier).state = 3,
                ),
              if (pendingSessions.valueOrNull?.isNotEmpty ?? false)
                const SizedBox(height: 16),

              StatsGrid(
                totalModules: totalModules.valueOrNull ?? 0,
                totalBitacoras: activeBitacoras.valueOrNull ?? 0,
                totalStudents: activeStudents.valueOrNull ?? 0,
                totalHours: totalHours.valueOrNull ?? 0,
              ),
              const SizedBox(height: 32),
              const QuickActions(),
              const SizedBox(height: 32),
              ActiveSessions(sessions: todaySessions.valueOrNull ?? []),
              const SizedBox(height: 32),
              AgendaSidebar(
                upcoming: upcomingSessions.valueOrNull ?? [],
                onSessionTap: (s) => _showSessionDetail(context, s),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Banner de advertencia que muestra el número de sesiones pasadas sin marcar.
class _PendingSessionsBanner extends StatelessWidget {
  final int count;
  final VoidCallback onTap;

  const _PendingSessionsBanner({required this.count, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFEF3C7), Color(0xFFFDE68A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFF59E0B).withValues(alpha: 0.4)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFF59E0B).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(LucideIcons.alertTriangle,
                  color: Color(0xFFB45309), size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$count ${count == 1 ? 'sesión pendiente' : 'sesiones pendientes'} de días anteriores',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Color(0xFF78350F),
                      fontFamily: 'Outfit',
                    ),
                  ),
                  const Text(
                    'Toca para revisar y marcar en el calendario',
                    style: TextStyle(fontSize: 11, color: Color(0xFF92400E)),
                  ),
                ],
              ),
            ),
            const Icon(LucideIcons.chevronRight,
                color: Color(0xFFB45309), size: 16),
          ],
        ),
      ),
    );
  }
}
