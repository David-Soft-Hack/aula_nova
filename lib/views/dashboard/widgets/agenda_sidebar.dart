import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../config/theme/app_theme.dart';
import '../../../database/daos.dart';
import '../../../providers/navigation_providers.dart';

/// Barra lateral de la agenda académica con eventos programados.
class AgendaSidebar extends ConsumerWidget {
  final List<TodaySessionData> upcoming;
  final void Function(TodaySessionData) onSessionTap;

  const AgendaSidebar({super.key, required this.upcoming, required this.onSessionTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Agenda Académica',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              fontFamily: 'Outfit',
            ),
          ),
          const SizedBox(height: 24),
          if (upcoming.isEmpty)
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.academic50.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  'No hay sesiones próximas',
                  style: TextStyle(color: Colors.grey.shade500),
                ),
              ),
            )
          else
            ...upcoming.take(5).map((s) {
              final date = s.entry.fechaProgramada;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: AgendaItem(
                  session: s,
                  day: date != null ? date.day.toString() : '--',
                  month: date != null
                      ? DateFormat('MMM', 'es').format(date).toUpperCase()
                      : '---',
                  title: s.moduleName,
                  career: s.career,
                  shift: s.turno ?? 'Mañana',
                  onTap: () => onSessionTap(s),
                ),
              );
            }),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              onPressed: () {
                ref.read(appLayoutIndexProvider.notifier).state = 3;
              },
              icon: const Text(
                'Ver Calendario Completo',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              label: const Icon(LucideIcons.arrowRight, size: 18),
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey.shade700,
                backgroundColor: Colors.grey.shade50,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Elemento individual representativo de un día en la agenda académica.
class AgendaItem extends StatelessWidget {
  final TodaySessionData session;
  final String day;
  final String month;
  final String title;
  final String career;
  final String shift;
  final VoidCallback onTap;

  const AgendaItem({
    super.key,
    required this.session,
    required this.day,
    required this.month,
    required this.title,
    required this.career,
    required this.shift,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        splashColor: AppTheme.academic600.withValues(alpha: 0.06),
        highlightColor: AppTheme.academic600.withValues(alpha: 0.03),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.academic50.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.academic100),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      month,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey,
                      ),
                    ),
                    Text(
                      day,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: AppTheme.academic700,
                        fontFamily: 'Outfit',
                        height: 1,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      career.toUpperCase(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      shift.toUpperCase(),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        color: Colors.indigo.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppTheme.academic50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  LucideIcons.chevronRight,
                  color: Colors.grey.shade300,
                  size: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
