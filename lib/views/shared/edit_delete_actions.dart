import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class EditDeleteActions extends StatelessWidget {
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final double iconSize;

  const EditDeleteActions({
    super.key,
    this.onEdit,
    this.onDelete,
    this.iconSize = 18,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (onEdit != null)
          IconButton(
            icon: Icon(LucideIcons.edit3,
                color: Colors.blue.shade600, size: iconSize),
            visualDensity: VisualDensity.compact,
            padding: const EdgeInsets.all(6),
            constraints: const BoxConstraints(),
            onPressed: onEdit,
          ),
        if (onDelete != null)
          IconButton(
            icon: const Icon(LucideIcons.trash2,
                color: Colors.red, size: 18),
            visualDensity: VisualDensity.compact,
            padding: const EdgeInsets.all(6),
            constraints: const BoxConstraints(),
            onPressed: onDelete,
          ),
      ],
    );
  }
}
