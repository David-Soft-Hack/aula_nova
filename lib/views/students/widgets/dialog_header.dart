import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../config/theme/app_theme.dart';

class DialogHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isKeyboardVisible;
  final bool isSaving;
  final VoidCallback onClose;

  const DialogHeader({
    super.key,
    required this.title,
    required this.icon,
    required this.isKeyboardVisible,
    required this.isSaving,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(isKeyboardVisible ? 6 : 10),
          decoration: BoxDecoration(
            color: AppTheme.academic50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: AppTheme.academic600,
            size: isKeyboardVisible ? 16 : 22,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: isKeyboardVisible ? 16 : 20,
              color: AppTheme.slate900,
            ),
          ),
        ),
        IconButton(
          onPressed: isSaving ? null : onClose,
          icon: Icon(
            LucideIcons.x,
            color: Colors.grey.shade400,
            size: isKeyboardVisible ? 18 : 22,
          ),
          splashRadius: 20,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ],
    );
  }
}
