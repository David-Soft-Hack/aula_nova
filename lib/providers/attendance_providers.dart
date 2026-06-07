import 'package:flutter_riverpod/flutter_riverpod.dart';
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
