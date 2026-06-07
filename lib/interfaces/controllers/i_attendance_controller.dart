import '../../models/app_models.dart';

abstract class IAttendanceController {
  Future<List<AttendanceRecord>> getAttendanceListForSession(int sessionId, String groupCode);
  Future<void> saveAttendances(int sessionId, List<AttendanceRecord> records);
}
