import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// Encabezado premium del Dashboard Académico.
class DashboardHeader extends StatelessWidget {
  final String dateStr;

  const DashboardHeader({
    super.key,
    required this.dateStr,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return _buildTitle(theme, context);
  }

  Widget _buildTitle(ThemeData theme, BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Inicio Académico',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Outfit',
                ),
              ),
              const SizedBox(height: 4),
              Text(
                dateStr,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade100),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(LucideIcons.bell),
            color: Colors.grey.shade500,
            onPressed: () {},
          ),
        ),
      ],
    );
  }
}
