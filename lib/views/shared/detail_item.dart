import 'package:flutter/material.dart';
import '../../../config/theme/app_theme.dart';

class DetailItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? iconBackground;
  final Color? iconColor;
  final double iconSize;

  const DetailItem({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.iconBackground,
    this.iconColor,
    this.iconSize = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconBackground ?? AppTheme.academic50.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: iconSize, color: iconColor ?? AppTheme.academic700),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
