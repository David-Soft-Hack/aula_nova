import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../config/theme/app_theme.dart';

class BitacoraResumenHeader extends StatelessWidget {
  final double progress;
  final int completed;
  final int total;
  final int frecuenciaClase;
  final DateTime fechaInicio;

  const BitacoraResumenHeader({
    super.key,
    required this.progress,
    required this.completed,
    required this.total,
    required this.frecuenciaClase,
    required this.fechaInicio,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Círculo de progreso compacto
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 52,
              height: 52,
              child: CircularProgressIndicator(
                value: progress,
                strokeWidth: 5,
                backgroundColor: Colors.grey.shade100,
                color: AppTheme.academic500,
              ),
            ),
            Text(
              '${(progress * 100).toStringAsFixed(0)}%',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppTheme.academic700,
                fontFamily: 'Outfit',
              ),
            ),
          ],
        ),
        const SizedBox(width: 16),
        // Columnas de estadísticas compactas
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildCompactStatItem(
                    'Clases Impartidas',
                    '$completed de $total',
                  ),
                  _buildCompactStatItem('Duración', '$frecuenciaClase hrs'),
                ],
              ),
              const SizedBox(height: 6),
              _buildCompactStatItem(
                'Fecha de Inicio',
                DateFormat('dd MMM, yyyy', 'es').format(fechaInicio),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCompactStatItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade500,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
            color: AppTheme.slate900,
          ),
        ),
      ],
    );
  }
}
