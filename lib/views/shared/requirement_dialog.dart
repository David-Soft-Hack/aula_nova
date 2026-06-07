import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../config/theme/app_theme.dart';

class RequirementDialog extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final Color iconColor;

  const RequirementDialog({
    super.key,
    required this.title,
    required this.message,
    this.icon = LucideIcons.alertCircle,
    this.iconColor = Colors.amber,
  });

  static Future<void> show(
    BuildContext context, {
    required String title,
    required String message,
    IconData icon = LucideIcons.alertCircle,
    Color iconColor = Colors.amber,
  }) {
    return showDialog(
      context: context,
      builder: (_) => RequirementDialog(
        title: title,
        message: message,
        icon: icon,
        iconColor: iconColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: Row(
        children: [
          Icon(icon, color: iconColor, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      content: Text(
        message,
        style: const TextStyle(fontFamily: 'Inter', height: 1.5, fontSize: 14),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'Entendido',
            style: TextStyle(
              color: AppTheme.academic600,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
