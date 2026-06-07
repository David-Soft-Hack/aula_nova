import '../database/app_database.dart';
import '../database/daos.dart';
import '../interfaces/repositories/i_attendance_repository.dart';

class AttendanceRepository implements IAttendanceRepository {
  final AttendanceDao _dao;

  AttendanceRepository(this._dao);

  @override
  Future<List<Attendance>> getAttendancesBySession(int sessionId) => _dao.getAttendancesBySession(sessionId);

  @override
  Future<void> saveAttendances(List<AttendancesCompanion> records) => _dao.saveAttendances(records);

  @override
  Future<void> upsertAttendance(AttendancesCompanion record) => _dao.upsertAttendance(record);
}
