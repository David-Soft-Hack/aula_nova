import 'package:flutter/material.dart';
import '../../../database/daos.dart';
import 'session_card.dart';

/// Sección que muestra las sesiones activas/en vivo programadas para hoy.
class ActiveSessions extends StatelessWidget {
  final List<TodaySessionData> sessions;

  const ActiveSessions({
    super.key,
    required this.sessions,
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
                if (sessions.isNotEmpty)
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
            Text(
              '${sessions.length} ${sessions.length == 1 ? 'encuentro' : 'encuentros'}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        if (sessions.isEmpty)
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Center(
              child: Text(
                'No hay sesiones programadas para hoy',
                style: TextStyle(color: Colors.grey.shade500),
              ),
            ),
          )
        else
          ...sessions.map((s) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: SessionCard(
              module: s.moduleName,
              group: s.groupCode ?? 'Sin grupo',
              career: s.career,
              shift: s.turno ?? 'Mañana',
              hours: s.entry.horaImpartir.toString(),
              activities: [s.entry.codActividad ?? 'Actividad'],
            ),
          )),
      ],
    );
  }
}

