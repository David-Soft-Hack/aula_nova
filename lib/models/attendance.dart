import 'package:aula_nova/database/app_database.dart';

import '../database/tables.dart';

class AttendanceRecord {
  final Student student;
  final Attendance? attendance;
  EstadoAsistencia? currentStatus;
  String? observacion;
  String? justificacionDetalle;
  List<String> rutasEvidencia;
  DateTime? fechaJustificacion;

  AttendanceRecord({required this.student, this.attendance})
      : rutasEvidencia = attendance?.rutasEvidencia ?? [] {
    currentStatus = attendance?.estado ?? EstadoAsistencia.presente;
    observacion = attendance?.observacion;
    justificacionDetalle = attendance?.justificacionDetalle;
    fechaJustificacion = attendance?.fechaJustificacion;
  }
}
