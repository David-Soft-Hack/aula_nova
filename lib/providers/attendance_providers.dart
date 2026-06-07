import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/attendance_controller.dart';
import '../database/daos.dart';
import 'database_providers.dart';

final attendanceDaoProvider = Provider<AttendanceDao>((ref) => ref.watch(appDatabaseProvider).attendanceDao);

final attendanceControllerProvider = Provider<AttendanceController>((ref) {
  return AttendanceController(
    attendanceDao: ref.watch(attendanceDaoProvider),
    studentDao: ref.watch(studentDaoProvider),
  );
});
