import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class SessionStatusBadge extends StatelessWidget {
  final bool estadoImpartido;
  final bool esEvaluativa;
  final Color? color;
  final Color? backgroundColor;
  final IconData? icon;
  final String? label;
  final double iconSize;
  final double fontSize;
  final EdgeInsetsGeometry padding;
  final double borderRadius;

  const SessionStatusBadge({
    super.key,
    required this.estadoImpartido,
    this.esEvaluativa = false,
    this.color,
    this.backgroundColor,
    this.icon,
    this.label,
    this.iconSize = 10,
    this.fontSize = 9,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    this.borderRadius = 20,
  });

  Color get _defaultColor {
    if (color != null) return color!;
    if (estadoImpartido) return const Color(0xFF10B981);
    if (esEvaluativa) return const Color(0xFFF97316);
    return const Color(0xFF2563EB);
  }

  Color get _defaultBackgroundColor {
    if (backgroundColor != null) return backgroundColor!;
    if (estadoImpartido) return const Color(0xFFECFDF5);
    if (esEvaluativa) return const Color(0xFFFFF7ED);
    return const Color(0xFFF0F7FF);
  }

  IconData get _defaultIcon {
    if (icon != null) return icon!;
    if (estadoImpartido) return LucideIcons.checkCircle2;
    if (esEvaluativa) return LucideIcons.award;
    return LucideIcons.clock;
  }

  String get _defaultLabel {
    if (label != null) return label!;
    if (estadoImpartido) return 'Impartida';
    if (esEvaluativa) return 'Evaluación';
    return 'Pendiente';
  }

  @override
  Widget build(BuildContext context) {
    final c = _defaultColor;
    final bg = _defaultBackgroundColor;

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: c.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_defaultIcon, size: iconSize, color: c),
          const SizedBox(width: 4),
          Text(
            _defaultLabel,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w800,
              color: c,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}
