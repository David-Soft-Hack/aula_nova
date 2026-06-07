import 'package:flutter/material.dart';
import '../../../database/tables.dart';

Color attendanceBackgroundColor(EstadoAsistencia? status) {
  switch (status) {
    case EstadoAsistencia.presente:
      return Colors.green.shade100;
    case EstadoAsistencia.ausente:
      return Colors.red.shade100;
    case EstadoAsistencia.tardanza:
      return Colors.orange.shade100;
    case EstadoAsistencia.justificado:
      return Colors.blue.shade100;
    default:
      return Colors.transparent;
  }
}

Color attendanceForegroundColor(EstadoAsistencia? status) {
  switch (status) {
    case EstadoAsistencia.presente:
      return Colors.green.shade800;
    case EstadoAsistencia.ausente:
      return Colors.red.shade800;
    case EstadoAsistencia.tardanza:
      return Colors.orange.shade800;
    case EstadoAsistencia.justificado:
      return Colors.blue.shade800;
    default:
      return Colors.grey.shade600;
  }
}
