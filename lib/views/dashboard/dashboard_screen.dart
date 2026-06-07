import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../database/daos.dart';
import '../../providers/dashboard_providers.dart';
import '../calendar/widgets/session_detail_dialog.dart';
import 'widgets/dashboard_header.dart';
import 'widgets/stats_grid.dart';
import 'widgets/active_sessions.dart';
import 'widgets/agenda_sidebar.dart';

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

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DashboardHeader(dateStr: dateStr),
              const SizedBox(height: 32),
              StatsGrid(
                totalModules: totalModules.valueOrNull ?? 0,
                totalBitacoras: activeBitacoras.valueOrNull ?? 0,
                totalStudents: activeStudents.valueOrNull ?? 0,
                totalHours: totalHours.valueOrNull ?? 0,
              ),
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
