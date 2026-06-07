import 'package:drift/drift.dart' as drift;
import '../database/app_database.dart';
import '../database/daos.dart';
import '../database/tables.dart';

class AttendanceController {
  final AttendanceDao attendanceDao;
  final StudentDao studentDao;

  AttendanceController({
    required this.attendanceDao,
    required this.studentDao,
  });

  /// Recupera los estudiantes de un grupo y los mapea a su registro de asistencia
  /// para la sesión especificada. Si aún no hay asistencia, devuelve una lista base con 'presente'.
  Future<List<AttendanceRecord>> getAttendanceListForSession(int sessionId, String groupCode) async {
    final students = await studentDao.searchStudents(groupCode);
    final groupStudents = students.where((s) => s.grupo?.toLowerCase() == groupCode.toLowerCase() && s.estado == StudentStatus.activo).toList();
    
    final savedAttendances = await attendanceDao.getAttendancesBySession(sessionId);
    final savedMap = {for (var a in savedAttendances) a.idStudent: a};

    List<AttendanceRecord> records = [];
    for (var student in groupStudents) {
      if (savedMap.containsKey(student.id)) {
        records.add(AttendanceRecord(student: student, attendance: savedMap[student.id]));
      } else {
        records.add(AttendanceRecord(student: student, attendance: null));
      }
    }

    records.sort((a, b) => a.student.apellidos.compareTo(b.student.apellidos));
    return records;
  }

  /// Guarda la lista completa de asistencias de una sesión de forma masiva
  Future<void> saveAttendances(int sessionId, List<AttendanceRecord> records) async {
    final companions = records.map((r) {
      return AttendancesCompanion.insert(
        idSession: sessionId,
        idStudent: r.student.id,
        estado: r.currentStatus ?? EstadoAsistencia.presente,
        observacion: r.observacion == null ? const drift.Value.absent() : drift.Value(r.observacion),
      );
    }).toList();

    await attendanceDao.saveAttendances(companions);
  }
}

/// Helper class para unir al estudiante con su estado de asistencia en la UI
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
