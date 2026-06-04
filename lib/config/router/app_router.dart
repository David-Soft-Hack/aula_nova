import 'package:flutter/material.dart';
import '../../views/layout/app_layout.dart';
import '../../views/modules/modules_screen.dart';
import '../../views/bitacoras/bitacoras_screen.dart';

import '../../views/careers/careers_screen.dart';
import '../../views/students/students_screen.dart';

class AppRouter {
  static const String dashboard = '/';
  static const String modules = '/modules';
  static const String bitacoras = '/bitacoras';
  static const String careers = '/careers';
  static const String students = '/students';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case dashboard:
        return MaterialPageRoute(
          builder: (_) => const AppLayout(),
        );
      case modules:
        return MaterialPageRoute(
          builder: (_) => const ModulesScreen(),
        );
      case bitacoras:
        return MaterialPageRoute(
          builder: (_) => const BitacorasScreen(),
        );
      case careers:
        return MaterialPageRoute(
          builder: (_) => const CareersScreen(),
        );
      case students:
        return MaterialPageRoute(
          builder: (_) => const StudentsScreen(),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const AppLayout(),
        );
    }
  }

  static Future<T?> pushNamed<T>(BuildContext context, String routeName, {Object? arguments}) {
    return Navigator.pushNamed(context, routeName, arguments: arguments);
  }
}
