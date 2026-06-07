import 'package:flutter/material.dart';
import '../../config/theme/app_theme.dart';

class AppBadge extends StatelessWidget {
  final String label;
  final Color? color;
  final Color? backgroundColor;
  final double fontSize;
  final FontWeight fontWeight;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final double? letterSpacing;

  const AppBadge({
    super.key,
    required this.label,
    this.color,
    this.backgroundColor,
    this.fontSize = 9,
    this.fontWeight = FontWeight.bold,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    this.borderRadius = 6,
    this.letterSpacing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppTheme.academic50,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color ?? AppTheme.academic600,
          letterSpacing: letterSpacing ?? 0.3,
        ),
      ),
    );
  }
}
