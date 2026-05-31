import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../config/theme/app_theme.dart';

/// Modelo de datos para un ítem del menú del Drawer.
class DrawerItem {
  final IconData icon;
  final String title;
  final int index;

  const DrawerItem({
    required this.icon,
    required this.title,
    required this.index,
  });
}

/// Lista de ítems del Drawer principal.
const kPrimaryDrawerItems = [
  DrawerItem(icon: LucideIcons.home, title: 'Inicio Académico', index: 0),
  DrawerItem(icon: LucideIcons.bookOpen, title: 'Módulos Formativos', index: 1),
  DrawerItem(icon: LucideIcons.fileText, title: 'Bitácoras Docentes', index: 2),
];

const kSecondaryDrawerItems = [
  DrawerItem(icon: LucideIcons.calendar, title: 'Calendario Escolar', index: 3),
  DrawerItem(icon: LucideIcons.users, title: 'Gestión de Estudiantes', index: 4),
  DrawerItem(icon: LucideIcons.checkSquare, title: 'Control de Asistencia', index: 5),
  DrawerItem(icon: LucideIcons.graduationCap, title: 'Carreras o Programas', index: 6),
];

/// Widget Drawer principal de la aplicación Aula Nova.
class AppDrawer extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;
  final VoidCallback onSettings;
  final VoidCallback onLogout;

  const AppDrawer({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.onSettings,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 16,
      backgroundColor: Colors.white,
      child: Column(
        children: [
          const _DrawerHeader(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                for (final item in kPrimaryDrawerItems)
                  _DrawerNavItem(
                    item: item,
                    selected: selectedIndex == item.index,
                    onTap: () {
                      Navigator.pop(context);
                      onItemSelected(item.index);
                    },
                  ),
                const Divider(height: 24, thickness: 1),
                const Padding(
                  padding: EdgeInsets.only(left: 12, bottom: 8),
                  child: Text(
                    'OPCIONES SECUNDARIAS',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                for (final item in kSecondaryDrawerItems)
                  _DrawerNavItem(
                    item: item,
                    selected: selectedIndex == item.index,
                    onTap: () {
                      Navigator.pop(context);
                      onItemSelected(item.index);
                    },
                  ),
                const Divider(height: 24, thickness: 1),
                _DrawerNavItem(
                  item: const DrawerItem(icon: LucideIcons.settings, title: 'Configuración', index: -1),
                  selected: false,
                  onTap: () {
                    Navigator.pop(context);
                    onSettings();
                  },
                ),
                _DrawerNavItem(
                  item: const DrawerItem(icon: LucideIcons.logOut, title: 'Cerrar Sesión', index: -2),
                  selected: false,
                  onTap: () {
                    Navigator.pop(context);
                    onLogout();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Cabecera del Drawer con datos del usuario.
class _DrawerHeader extends StatelessWidget {
  const _DrawerHeader();

  @override
  Widget build(BuildContext context) {
    return UserAccountsDrawerHeader(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.academic600, AppTheme.academic700],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      currentAccountPicture: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const CircleAvatar(
          backgroundColor: AppTheme.academic100,
          foregroundColor: AppTheme.academic600,
          child: Text(
            'U',
            style: TextStyle(fontFamily: 'Outfit', fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      accountName: const Text(
        'Dr. Uriel',
        style: TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
      ),
      accountEmail: const Text(
        'uriel@aulanova.edu',
        style: TextStyle(fontFamily: 'Inter', fontSize: 13, color: AppTheme.academic100),
      ),
    );
  }
}

/// Ítem individual del Drawer con estado de selección.
class _DrawerNavItem extends StatelessWidget {
  final DrawerItem item;
  final bool selected;
  final VoidCallback onTap;

  const _DrawerNavItem({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: selected ? AppTheme.academic50 : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(
          item.icon,
          color: selected ? AppTheme.academic600 : Colors.grey.shade600,
          size: 20,
        ),
        title: Text(
          item.title,
          style: TextStyle(
            fontFamily: 'Outfit',
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            color: selected ? AppTheme.academic600 : Colors.grey.shade800,
            fontSize: 14,
          ),
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
