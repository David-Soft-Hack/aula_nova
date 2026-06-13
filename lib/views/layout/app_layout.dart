import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../providers/navigation_providers.dart';
import '../dashboard/dashboard_screen.dart';
import '../modules/modules_screen.dart';
import '../bitacoras/bitacoras_screen.dart';
import '../calendar/calendar_screen.dart';
import '../careers/careers_screen.dart';
import '../students/students_screen.dart';
import '../groups/groups_screen.dart';
import '../attendance/attendance_screen.dart';
import '../shared/app_snackbar.dart';
import 'widgets/bottom_nav_bar.dart';
import 'widgets/secondary_menu_sheet.dart';

/// Pantallas de navegación principal de la aplicación.
final _kScreens = <Widget>[
  const DashboardScreen(),
  const ModulesScreen(),
  const BitacorasScreen(),
  const CalendarScreen(),
  const StudentsScreen(),
  const AttendanceScreen(),
  const CareersScreen(),
  const GroupsScreen(),
];

/// Layout principal móvil para la navegación inferior.
class AppLayout extends ConsumerStatefulWidget {
  const AppLayout({super.key});

  @override
  ConsumerState<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends ConsumerState<AppLayout> {
  void _navigateTo(int index) {
    ref.read(appLayoutIndexProvider.notifier).state = index;
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
            icon: LucideIcons.users,
            title: 'Estudiantes',
            color: Colors.green.shade600,
            onTap: () {
              Navigator.pop(context);
              _navigateTo(4);
            },
          ),
          SecondaryMenuItem(
            icon: LucideIcons.checkSquare,
            title: 'Asistencia',
            color: Colors.purple.shade600,
            onTap: () {
              Navigator.pop(context);
              _navigateTo(5);
            },
          ),
          SecondaryMenuItem(
            icon: LucideIcons.graduationCap,
            title: 'Programas',
            color: Colors.indigo.shade600,
            onTap: () {
              Navigator.pop(context);
              _navigateTo(6);
            },
          ),
          SecondaryMenuItem(
            icon: LucideIcons.library,
            title: 'Grupos',
            color: Colors.deepOrange.shade600,
            onTap: () {
              Navigator.pop(context);
              _navigateTo(7);
            },
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
    AppSnackbar.showInfo(context, message);
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = ref.watch(appLayoutIndexProvider);
    return Scaffold(
      drawer: null,
      body: _kScreens[selectedIndex],
      bottomNavigationBar: BottomNavBar(
        selectedIndex: selectedIndex >= 4 ? 4 : selectedIndex,
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
