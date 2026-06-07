import 'package:drift/drift.dart' as drift;
import '../database/app_database.dart';
import '../database/tables.dart';
import '../models/app_models.dart';
import '../interfaces/controllers/i_attendance_controller.dart';
import '../interfaces/repositories/i_attendance_repository.dart';
import '../interfaces/repositories/i_student_repository.dart';

class AttendanceController implements IAttendanceController {
  final IAttendanceRepository _attendanceRepository;
  final IStudentRepository _studentRepository;

  AttendanceController({
    required IAttendanceRepository attendanceRepository,
    required IStudentRepository studentRepository,
  })  : _attendanceRepository = attendanceRepository,
        _studentRepository = studentRepository;

  @override
  Future<List<AttendanceRecord>> getAttendanceListForSession(int sessionId, String groupCode) async {
    final students = await _studentRepository.searchStudents(groupCode);
    final groupStudents = students.where((s) => s.grupo?.toLowerCase() == groupCode.toLowerCase() && s.estado == StudentStatus.activo).toList();

    final savedAttendances = await _attendanceRepository.getAttendancesBySession(sessionId);
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

  @override
  Future<void> saveAttendances(int sessionId, List<AttendanceRecord> records) async {
    final companions = records.map((r) {
      return AttendancesCompanion.insert(
        idSession: sessionId,
        idStudent: r.student.id,
        estado: r.currentStatus ?? EstadoAsistencia.presente,
        observacion: r.observacion == null ? const drift.Value.absent() : drift.Value(r.observacion),
      );
    }).toList();

    await _attendanceRepository.saveAttendances(companions);
  }
}
