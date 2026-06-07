import 'package:aula_nova/database/app_database.dart';

import '../database/tables.dart';

class AttendanceRecord {
  final Student student;
  final Attendance? attendance;
  EstadoAsistencia? currentStatus;
  String? observacion;

  AttendanceRecord({required this.student, this.attendance}) {
    currentStatus = attendance?.estado ?? EstadoAsistencia.presente;
    observacion = attendance?.observacion;
  }
}
