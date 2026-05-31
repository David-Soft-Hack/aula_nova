import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// Barra lateral de navegación (Sidebar) premium para pantallas de escritorio/tableta.
class SidebarRail extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  const SidebarRail({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return NavigationRail(
      backgroundColor: Colors.white,
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      labelType: NavigationRailLabelType.all,
      selectedLabelTextStyle: theme.textTheme.labelMedium?.copyWith(
        color: theme.colorScheme.primary,
        fontWeight: FontWeight.w700,
      ),
      unselectedLabelTextStyle: theme.textTheme.labelMedium?.copyWith(
        color: Colors.grey.shade500,
        fontWeight: FontWeight.w500,
      ),
      selectedIconTheme: IconThemeData(color: theme.colorScheme.primary),
      unselectedIconTheme: IconThemeData(color: Colors.grey.shade500),
      destinations: const [
        NavigationRailDestination(
          icon: Icon(LucideIcons.home),
          label: Text('Inicio'),
        ),
        NavigationRailDestination(
          icon: Icon(LucideIcons.bookOpen),
          label: Text('Módulos'),
        ),
        NavigationRailDestination(
          icon: Icon(LucideIcons.fileText),
          label: Text('Bitácoras'),
        ),
        NavigationRailDestination(
          icon: Icon(LucideIcons.calendar),
          label: Text('Calendario'),
        ),
        NavigationRailDestination(
          icon: Icon(LucideIcons.users),
          label: Text('Estudiantes'),
        ),
        NavigationRailDestination(
          icon: Icon(LucideIcons.checkCircle),
          label: Text('Asistencia'),
        ),
      ],
    );
  }
}
