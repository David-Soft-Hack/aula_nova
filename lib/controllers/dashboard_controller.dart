import '../database/daos.dart';
import '../database/tables.dart';
import '../models/database_provider.dart';

class DashboardController {
  final ModuleDao _moduleDao = DatabaseProvider.moduleDao;
  final BitacoraDao _bitacoraDao = DatabaseProvider.bitacoraDao;
  final StudentDao _studentDao = DatabaseProvider.studentDao;

  Stream<int> get totalModules =>
      _moduleDao.watchAllModules().map((list) => list.length);

  Stream<int> get activeBitacoras => _bitacoraDao
      .watchBitacorasWithModule()
      .map((list) => list.where((item) => item.bitacora.estado == EstadoBitacora.activo).length);

  Stream<int> get activeStudents =>
      _studentDao.watchAllStudents().map((list) => list.where((s) => s.estado == StudentStatus.activo).length);

  Stream<int> get totalHours => _moduleDao
      .watchAllModules()
      .map((list) => list.fold(0, (sum, m) => sum + (m.totalHoraAcademic)));

  Stream<List<TodaySessionData>> get todaySessions =>
      _bitacoraDao.watchTodaySessions();

  Stream<List<TodaySessionData>> get upcomingSessions =>
      _bitacoraDao.watchUpcomingSessions(days: 7);
}
