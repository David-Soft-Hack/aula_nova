import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/app_database.dart';
import '../interfaces/controllers/i_attendance_controller.dart';
import '../controllers/attendance_controller.dart';
import '../repositories/attendance_repository.dart';
import '../repositories/student_repository.dart';
import 'database_providers.dart';

final attendanceControllerProvider = Provider<IAttendanceController>((ref) {
  return AttendanceController(
    attendanceRepository: AttendanceRepository(ref.watch(appDatabaseProvider).attendanceDao),
    studentRepository: StudentRepository(ref.watch(studentDaoProvider)),
  );
});

/// Stream reactivo de estudiantes activos por grupo.
/// Se actualiza automáticamente cuando se agrega/modifica/elimina un estudiante.
final activeStudentsByGroupProvider =
    StreamProvider.family<List<Student>, String>((ref, groupCode) {
  final repo = StudentRepository(ref.watch(studentDaoProvider));
  return repo.watchActiveStudentsByGroup(groupCode);
});

