import 'package:flutter/material.dart';
import 'session_card.dart';

/// Sección que muestra las sesiones activas/en vivo programadas para hoy.
class ActiveSessions extends StatelessWidget {
  const ActiveSessions({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 16,
          runSpacing: 8,
          children: [
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              children: [
                Text(
                  'Sesiones de Hoy',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Outfit',
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'EN VIVO',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade600,
                    ),
                  ),
                ),
              ],
            ),
            const Text(
              '2 encuentros',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        const SessionCard(
          module: 'Desarrollo de Aplicaciones Móviles',
          group: 'Grupo A',
          career: 'Ing. de Software',
          shift: 'Mañana',
          hours: '3',
          activities: ['Instalación Flutter', 'Widgets Básicos'],
        ),
      ],
    );
  }
}

