import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../config/theme/app_theme.dart';

class DialogHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? stepBadge;
  final IconData icon;
  final bool isKeyboardVisible;
  final bool isSaving;
  final VoidCallback onClose;

  const DialogHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.stepBadge,
    required this.icon,
    required this.isKeyboardVisible,
    required this.isSaving,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (stepBadge != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppTheme.academic50,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    stepBadge!,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.academic600,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
              ],
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: isKeyboardVisible ? 16 : 20,
                  color: AppTheme.slate900,
                ),
              ),
              if (subtitle != null && !isKeyboardVisible) ...[
                const SizedBox(height: 3),
                Text(
                  subtitle!,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                    height: 1.3,
                  ),
                ),
              ],
            ],
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
