import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// Barra de navegación inferior premium para pantallas móviles.
class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const BottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: onTap,
      backgroundColor: Colors.white,
      selectedItemColor: theme.colorScheme.primary,
      unselectedItemColor: Colors.grey.shade500,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
      unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal, fontSize: 10),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(LucideIcons.home),
          label: 'Inicio',
        ),
        BottomNavigationBarItem(
          icon: Icon(LucideIcons.bookOpen),
          label: 'Módulos',
        ),
        BottomNavigationBarItem(
          icon: Icon(LucideIcons.fileText),
          label: 'Bitácoras',
        ),
        BottomNavigationBarItem(
          icon: Icon(LucideIcons.calendar),
          label: 'Calendario',
        ),
        BottomNavigationBarItem(
          icon: Icon(LucideIcons.menu),
          label: 'Más',
        ),
      ],
    );
  }
}
