import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
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
              // Header modularizado
              DashboardHeader(dateStr: dateStr),
              const SizedBox(height: 32),

              // Stats Grid modularizado
              const StatsGrid(),
              const SizedBox(height: 32),

              // Contenido principal (Sesiones activas y Agenda lateral)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ActiveSessions(),
                  const SizedBox(height: 32),
                  const AgendaSidebar(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
