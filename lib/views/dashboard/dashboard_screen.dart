import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../../controllers/dashboard_controller.dart';
import '../../database/daos.dart';
import 'widgets/dashboard_header.dart';
import 'widgets/stats_grid.dart';
import 'widgets/active_sessions.dart';
import 'widgets/agenda_sidebar.dart';

/// Pantalla principal del Dashboard del Docente.
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final DashboardController _controller = DashboardController();

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('es', null);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final dateStr = toBeginningOfSentenceCase(
      DateFormat("EEEE, dd 'de' MMMM 'de' yyyy", 'es').format(now),
    );

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DashboardHeader(dateStr: dateStr),
              const SizedBox(height: 32),

              // Stats Grid con streams
              StreamBuilder<int>(
                stream: _controller.totalModules,
                initialData: 0,
                builder: (context, modules) {
                  return StreamBuilder<int>(
                    stream: _controller.activeBitacoras,
                    initialData: 0,
                    builder: (context, bitacoras) {
                      return StreamBuilder<int>(
                        stream: _controller.activeStudents,
                        initialData: 0,
                        builder: (context, students) {
                          return StreamBuilder<int>(
                            stream: _controller.totalHours,
                            initialData: 0,
                            builder: (context, hours) {
                              return StatsGrid(
                                totalModules: modules.data ?? 0,
                                totalBitacoras: bitacoras.data ?? 0,
                                totalStudents: students.data ?? 0,
                                totalHours: hours.data ?? 0,
                              );
                            },
                          );
                        },
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 32),

              // Sesiones de hoy y Agenda
              StreamBuilder<List<TodaySessionData>>(
                stream: _controller.todaySessions,
                initialData: const [],
                builder: (context, today) {
                  return StreamBuilder<List<TodaySessionData>>(
                    stream: _controller.upcomingSessions,
                    initialData: const [],
                    builder: (context, upcoming) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ActiveSessions(sessions: today.data ?? []),
                          const SizedBox(height: 32),
                          AgendaSidebar(upcoming: upcoming.data ?? []),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
