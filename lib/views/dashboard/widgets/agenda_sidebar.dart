import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../config/theme/app_theme.dart';

/// Barra lateral de la agenda académica con eventos programados.
class AgendaSidebar extends StatelessWidget {
  const AgendaSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
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
          const AgendaItem(
            day: '15',
            month: 'MAY',
            title: 'Programación Web',
            career: 'Ing. Sistemas',
            shift: 'Mañana',
          ),
          const SizedBox(height: 12),
          const AgendaItem(
            day: '16',
            month: 'MAY',
            title: 'Bases de Datos II',
            career: 'Ing. Sistemas',
            shift: 'Tarde',
          ),
          const SizedBox(height: 12),
          const AgendaItem(
            day: '17',
            month: 'MAY',
            title: 'Estructura de Datos',
            career: 'Ing. Sistemas',
            shift: 'Noche',
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              onPressed: () {},
              icon: const Text(
                'Ver Calendario Completo',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              label: const Icon(LucideIcons.arrowRight, size: 18),
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey.shade700,
                backgroundColor: Colors.grey.shade50,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
  final String day;
  final String month;
  final String title;
  final String career;
  final String shift;

  const AgendaItem({
    super.key,
    required this.day,
    required this.month,
    required this.title,
    required this.career,
    required this.shift,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      career.toUpperCase(),
                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        '•',
                        style: TextStyle(color: Colors.grey, fontSize: 10),
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
