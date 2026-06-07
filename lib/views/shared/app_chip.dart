import 'package:flutter/material.dart';

class AppChip extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;
  final Color backgroundColor;
  final double iconSize;
  final double fontSize;
  final FontWeight fontWeight;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final double spacing;
  final double? letterSpacing;

  const AppChip({
    super.key,
    required this.icon,
    required this.text,
    this.color = Colors.grey,
    this.backgroundColor = Colors.grey,
    this.iconSize = 12,
    this.fontSize = 10,
    this.fontWeight = FontWeight.bold,
    this.borderRadius = 10,
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    this.spacing = 6,
    this.letterSpacing = 0.5,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: iconSize, color: color),
          SizedBox(width: spacing),
          Flexible(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: fontWeight,
                color: color,
                letterSpacing: letterSpacing,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
