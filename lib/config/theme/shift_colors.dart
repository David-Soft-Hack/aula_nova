import 'package:flutter/material.dart';

/// Maps shift names (turno) to a consistent color pair [accent, background].
class ShiftColors {
  static const _map = <String, _ShiftColor>{
    'mañana': _ShiftColor(Color(0xFF0EA5E9), Color(0xFFE0F2FE)),
    'matutino': _ShiftColor(Color(0xFF0EA5E9), Color(0xFFE0F2FE)),
    'tarde': _ShiftColor(Color(0xFFF97316), Color(0xFFFFF7ED)),
    'vespertino': _ShiftColor(Color(0xFFF97316), Color(0xFFFFF7ED)),
    'noche': _ShiftColor(Color(0xFF8B5CF6), Color(0xFFF5F3FF)),
    'nocturno': _ShiftColor(Color(0xFF8B5CF6), Color(0xFFF5F3FF)),
    'sabatino': _ShiftColor(Color(0xFF10B981), Color(0xFFECFDF5)),
    'sabado': _ShiftColor(Color(0xFF10B981), Color(0xFFECFDF5)),
  };

  static Color accent(String? turno) {
    if (turno == null) return const Color(0xFF64748B);
    return _map[turno.toLowerCase()]?.accent ?? const Color(0xFF64748B);
  }

  static Color background(String? turno) {
    if (turno == null) return const Color(0xFFF1F5F9);
    return _map[turno.toLowerCase()]?.background ?? const Color(0xFFF1F5F9);
  }

  static IconData icon(String? turno) {
    if (turno == null) return Icons.schedule_outlined;
    switch (turno.toLowerCase()) {
      case 'mañana':
      case 'matutino':
        return Icons.wb_sunny_outlined;
      case 'tarde':
      case 'vespertino':
        return Icons.wb_twilight_outlined;
      case 'noche':
      case 'nocturno':
        return Icons.nights_stay_outlined;
      case 'sabatino':
      case 'sabado':
        return Icons.weekend_outlined;
      default:
        return Icons.schedule_outlined;
    }
  }
}

class _ShiftColor {
  final Color accent;
  final Color background;
  const _ShiftColor(this.accent, this.background);
}
