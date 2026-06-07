import '../database/daos.dart';
import '../database/tables.dart';

class DashboardController {
  final ModuleDao moduleDao;
  final BitacoraDao bitacoraDao;
  final StudentDao studentDao;

  DashboardController({
    required this.moduleDao,
    required this.bitacoraDao,
    required this.studentDao,
  });

  Stream<int> get totalModules =>
      moduleDao.watchAllModules().map((list) => list.length);

  Stream<int> get activeBitacoras => bitacoraDao
      .watchBitacorasWithModule()
      .map((list) => list.where((item) => item.bitacora.estado == EstadoBitacora.activo).length);

  Stream<int> get activeStudents =>
      studentDao.watchAllStudents().map((list) => list.where((s) => s.estado == StudentStatus.activo).length);

  Stream<int> get totalHours => moduleDao
      .watchAllModules()
      .map((list) => list.fold(0, (sum, m) => sum + (m.totalHoraAcademic)));

  Stream<List<TodaySessionData>> get todaySessions =>
      bitacoraDao.watchTodaySessions();

  Stream<List<TodaySessionData>> get upcomingSessions =>
      bitacoraDao.watchUpcomingSessions(days: 7);
}
