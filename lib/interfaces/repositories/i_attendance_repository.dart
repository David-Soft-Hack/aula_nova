import '../../database/app_database.dart';

abstract class IAttendanceRepository {
  Future<List<Attendance>> getAttendancesBySession(int sessionId);
  Future<void> saveAttendances(List<AttendancesCompanion> records);
  Future<void> upsertAttendance(AttendancesCompanion record);
}
