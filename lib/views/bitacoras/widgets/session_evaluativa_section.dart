import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class SessionEvaluativaSection extends StatelessWidget {
  final bool esEvaluativa;
  final ValueChanged<bool> onChanged;

  const SessionEvaluativaSection({
    super.key,
    required this.esEvaluativa,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: esEvaluativa
            ? const Color(0xFFFFF7ED)
            : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: esEvaluativa
              ? const Color(0xFFFBD0A0)
              : Colors.grey.shade200,
        ),
      ),
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: esEvaluativa
                  ? const Color(0xFFFF8C00).withValues(alpha: 0.12)
                  : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              LucideIcons.clipboardList,
              size: 20,
              color: esEvaluativa
                  ? const Color(0xFFEA580C)
                  : Colors.grey.shade500,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Actividad Evaluativa',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                Text(
                  esEvaluativa
                      ? 'Esta sesión contiene una evaluación'
                      : 'Marcar como sesión evaluativa',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: esEvaluativa,
            onChanged: onChanged,
            activeTrackColor: const Color(0xFFEA580C),
            activeThumbColor: Colors.white,
          ),
        ],
      ),
    );
  }
}
