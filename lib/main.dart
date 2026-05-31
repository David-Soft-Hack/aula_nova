import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'config/theme/app_theme.dart';
import 'views/layout/app_layout.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('es', null);
  runApp(const AulaNovaApp());
}

class AulaNovaApp extends StatelessWidget {
  const AulaNovaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aula Nova',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light, // Forcing light mode to show the new design
      home: const AppLayout(),
    );
  }
}
