import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Academic Color Palette from CSS
  static const Color academic50 = Color(0xFFF0F7FF);
  static const Color academic100 = Color(0xFFE0EFFE);
  static const Color academic200 = Color(0xFFBAE0FD);
  static const Color academic500 = Color(0xFF3B82F6);
  static const Color academic600 = Color(0xFF2563EB); // Primary
  static const Color academic700 = Color(0xFF1D4ED8);

  static const Color slate50 = Color(0xFFF8FAFC); // Background
  static const Color slate900 = Color(0xFF0F172A); // Text

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: academic600,
        primary: academic600,
        secondary: academic500,
        surface: slate50,
        onSurface: slate900,
      ),
      scaffoldBackgroundColor: slate50,
      fontFamily: GoogleFonts.inter().fontFamily,
      textTheme: GoogleFonts.interTextTheme().copyWith(
        displayLarge: GoogleFonts.outfit(fontWeight: FontWeight.w900, color: slate900, letterSpacing: -0.5),
        displayMedium: GoogleFonts.outfit(fontWeight: FontWeight.w900, color: slate900, letterSpacing: -0.5),
        displaySmall: GoogleFonts.outfit(fontWeight: FontWeight.w900, color: slate900, letterSpacing: -0.5),
        headlineLarge: GoogleFonts.outfit(fontWeight: FontWeight.w900, color: slate900, letterSpacing: -0.5),
        headlineMedium: GoogleFonts.outfit(fontWeight: FontWeight.w900, color: slate900, letterSpacing: -0.5),
        headlineSmall: GoogleFonts.outfit(fontWeight: FontWeight.w900, color: slate900, letterSpacing: -0.5),
        titleLarge: GoogleFonts.outfit(fontWeight: FontWeight.w700, color: slate900),
        titleMedium: GoogleFonts.outfit(fontWeight: FontWeight.w600, color: slate900),
        titleSmall: GoogleFonts.outfit(fontWeight: FontWeight.w500, color: slate900),
        bodyLarge: GoogleFonts.inter(fontWeight: FontWeight.w400, color: slate900),
        bodyMedium: GoogleFonts.inter(fontWeight: FontWeight.w400, color: slate900),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white.withValues(alpha: 0.8),
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: slate900),
        titleTextStyle: GoogleFonts.outfit(
          color: slate900,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
      cardTheme: const CardThemeData(
        color: Color(0xE6FFFFFF), // Colors.white.withValues(alpha: 0.9) approx
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          side: BorderSide(color: Color(0x33FFFFFF)),
        ),
        shadowColor: Color(0x0D000000), // Colors.black.withValues(alpha: 0.05) approx
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: academic600,
        brightness: Brightness.dark,
        primary: academic500,
        surface: const Color(0xFF1E293B),
        onSurface: const Color(0xFFF1F5F9),
      ),
      scaffoldBackgroundColor: const Color(0xFF0F172A),
      fontFamily: GoogleFonts.inter().fontFamily,
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme).copyWith(
        displayLarge: GoogleFonts.outfit(fontWeight: FontWeight.w900, color: const Color(0xFFF1F5F9), letterSpacing: -0.5),
        displayMedium: GoogleFonts.outfit(fontWeight: FontWeight.w900, color: const Color(0xFFF1F5F9), letterSpacing: -0.5),
        displaySmall: GoogleFonts.outfit(fontWeight: FontWeight.w900, color: const Color(0xFFF1F5F9), letterSpacing: -0.5),
        headlineLarge: GoogleFonts.outfit(fontWeight: FontWeight.w900, color: const Color(0xFFF1F5F9), letterSpacing: -0.5),
        headlineMedium: GoogleFonts.outfit(fontWeight: FontWeight.w900, color: const Color(0xFFF1F5F9), letterSpacing: -0.5),
        headlineSmall: GoogleFonts.outfit(fontWeight: FontWeight.w900, color: const Color(0xFFF1F5F9), letterSpacing: -0.5),
        titleLarge: GoogleFonts.outfit(fontWeight: FontWeight.w700, color: const Color(0xFFF1F5F9)),
        titleMedium: GoogleFonts.outfit(fontWeight: FontWeight.w600, color: const Color(0xFFF1F5F9)),
        titleSmall: GoogleFonts.outfit(fontWeight: FontWeight.w500, color: const Color(0xFFF1F5F9)),
        bodyLarge: GoogleFonts.inter(fontWeight: FontWeight.w400, color: const Color(0xFFF1F5F9)),
        bodyMedium: GoogleFonts.inter(fontWeight: FontWeight.w400, color: const Color(0xFFF1F5F9)),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFF1E293B).withValues(alpha: 0.9),
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: Color(0xFFF1F5F9)),
        titleTextStyle: GoogleFonts.outfit(
          color: const Color(0xFFF1F5F9),
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
      cardTheme: const CardThemeData(
        color: Color(0xFF1E293B),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          side: BorderSide(color: Color(0x33FFFFFF)),
        ),
        shadowColor: Color(0x0DFFFFFF),
      ),
    );
  }
}
