import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../config/theme/app_theme.dart';
import '../dashboard/dashboard_screen.dart';
import '../modules/modules_screen.dart';
import '../bitacoras/bitacoras_screen.dart';
import '../careers/careers_screen.dart';
import '../students/students_screen.dart';
import 'widgets/bottom_nav_bar.dart';
import 'widgets/app_drawer.dart';
import 'widgets/secondary_menu_sheet.dart';

/// Pantallas de navegación principal de la aplicación.
final _kScreens = <Widget>[
  const DashboardScreen(),
  const ModulesScreen(),
  const BitacorasScreen(),
  const _PlaceholderScreen(
    icon: LucideIcons.calendar,
    title: 'Calendario Académico',
    subtitle: 'Seguimiento de fechas y evaluaciones',
  ),
  const StudentsScreen(),
  const _PlaceholderScreen(
    icon: LucideIcons.checkSquare,
    title: 'Control de Asistencia',
    subtitle: 'Registro rápido de asistencia diaria',
  ),
  const CareersScreen(),
];

/// Layout principal móvil para la navegación inferior.
class AppLayout extends StatefulWidget {
  const AppLayout({super.key});

  @override
  State<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  int _selectedIndex = 0;

  void _navigateTo(int index) {
    setState(() => _selectedIndex = index);
  }

  void _showSecondaryMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      elevation: 20,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (context) => SecondaryMenuSheet(
        items: [
          SecondaryMenuItem(
            icon: LucideIcons.calendar,
            title: 'Calendario',
            color: Colors.amber.shade600,
            onTap: () { Navigator.pop(context); _navigateTo(3); },
          ),
          SecondaryMenuItem(
            icon: LucideIcons.users,
            title: 'Estudiantes',
            color: Colors.green.shade600,
            onTap: () { Navigator.pop(context); _navigateTo(4); },
          ),
          SecondaryMenuItem(
            icon: LucideIcons.checkSquare,
            title: 'Asistencia',
            color: Colors.purple.shade600,
            onTap: () { Navigator.pop(context); _navigateTo(5); },
          ),
          SecondaryMenuItem(
            icon: LucideIcons.graduationCap,
            title: 'Programas',
            color: Colors.indigo.shade600,
            onTap: () { Navigator.pop(context); _navigateTo(6); },
          ),
          SecondaryMenuItem(
            icon: LucideIcons.settings,
            title: 'Ajustes',
            color: Colors.blueGrey.shade600,
            onTap: () {
              Navigator.pop(context);
              _showSnack('Configuración - Próximamente');
            },
          ),
          SecondaryMenuItem(
            icon: LucideIcons.user,
            title: 'Mi Perfil',
            color: Colors.teal.shade600,
            onTap: () {
              Navigator.pop(context);
              _showSnack('Perfil de Usuario - Próximamente');
            },
          ),
          SecondaryMenuItem(
            icon: LucideIcons.helpCircle,
            title: 'Soporte',
            color: Colors.blue.shade600,
            onTap: () {
              Navigator.pop(context);
              _showSnack('Centro de Soporte - Próximamente');
            },
          ),
        ],
      ),
    );
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(
        selectedIndex: _selectedIndex,
        onItemSelected: _navigateTo,
        onSettings: () => _showSnack('Configuración - Próximamente'),
        onLogout: () => _showSnack('Sesión Cerrada'),
      ),
      body: _kScreens[_selectedIndex],
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex >= 4 ? 4 : _selectedIndex,
        onTap: (index) {
          if (index == 4) {
            _showSecondaryMenu();
          } else {
            _navigateTo(index);
          }
        },
      ),
    );
  }
}

/// Pantalla placeholder para secciones en construcción.
class _PlaceholderScreen extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _PlaceholderScreen({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: AppTheme.academic600),
          const SizedBox(height: 16),
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Outfit')),
          const SizedBox(height: 8),
          Text(subtitle, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
