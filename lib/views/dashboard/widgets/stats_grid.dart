import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// Cuadrícula de estadísticas dinámicas del Dashboard.
class StatsGrid extends StatelessWidget {
  const StatsGrid({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 0.88,
      children: const [
        StatCard(
          title: 'Módulos',
          value: '12',
          icon: LucideIcons.bookOpen,
          color: Colors.blue,
          trend: 'Activos',
        ),
        StatCard(
          title: 'Bitácoras',
          value: '8',
          icon: LucideIcons.fileText,
          color: Colors.green,
          trend: 'Configuradas',
        ),
        StatCard(
          title: 'Estudiantes',
          value: '124',
          icon: LucideIcons.users,
          color: Colors.indigo,
          trend: '+12 este mes',
        ),
        StatCard(
          title: 'Horas Totales',
          value: '340',
          icon: LucideIcons.clock,
          color: Colors.amber,
          trend: 'Académicas',
        ),
      ],
    );
  }
}

/// Tarjeta premium de indicador estadístico.
class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final MaterialColor color;
  final String trend;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.trend,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color.shade600, size: 18),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade100),
                ),
                child: Row(
                  children: [
                    Icon(LucideIcons.trendingUp, size: 9, color: Colors.green.shade500),
                    const SizedBox(width: 3),
                    const Text(
                      'Live',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 2),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Outfit',
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 3),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: color.shade50.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  trend.toUpperCase(),
                  style: TextStyle(
                    fontSize: 8.5,
                    fontWeight: FontWeight.bold,
                    color: color.shade700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
