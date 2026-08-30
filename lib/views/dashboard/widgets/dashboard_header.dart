import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// Encabezado premium del Dashboard Académico con saludo contextual.
class DashboardHeader extends StatelessWidget {
  final String dateStr;

  const DashboardHeader({
    super.key,
    required this.dateStr,
  });

  /// Retorna el saludo y el ícono apropiados según la hora del día.
  static ({String greeting, IconData icon, Color iconColor}) _getGreetingData() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return (
        greeting: 'Buenos días ☀️',
        icon: LucideIcons.sunrise,
        iconColor: const Color(0xFFD97706),
      );
    } else if (hour >= 12 && hour < 19) {
      return (
        greeting: 'Buenas tardes 🌤️',
        icon: LucideIcons.sun,
        iconColor: const Color(0xFFEA580C),
      );
    } else {
      return (
        greeting: 'Buenas noches 🌙',
        icon: LucideIcons.moon,
        iconColor: const Color(0xFF6D28D9),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final greetingData = _getGreetingData();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Saludo contextual
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: greetingData.iconColor.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(greetingData.icon, size: 14, color: greetingData.iconColor),
              const SizedBox(width: 6),
              Text(
                greetingData.greeting,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: greetingData.iconColor,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Inicio Académico',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Outfit',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dateStr,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade100),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(LucideIcons.bell),
                color: Colors.grey.shade500,
                onPressed: () {},
              ),
            ),
          ],
        ),
      ],
    );
  }
}
