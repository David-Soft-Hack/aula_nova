import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/daos.dart';
import '../repositories/module_repository.dart';
import '../repositories/bitacora_repository.dart';
import '../repositories/student_repository.dart';
import '../controllers/dashboard_controller.dart';
import '../interfaces/controllers/i_dashboard_controller.dart';
import 'database_providers.dart';

final dashboardControllerProvider = Provider<IDashboardController>((ref) {
  return DashboardController(
    moduleRepository: ModuleRepository(
      ref.watch(moduleDaoProvider),
      ref.watch(unitDaoProvider),
      ref.watch(activityDaoProvider),
    ),
    bitacoraRepository: BitacoraRepository(ref.watch(bitacoraDaoProvider)),
    studentRepository: StudentRepository(ref.watch(studentDaoProvider)),
  );
});

final totalModulesProvider = StreamProvider<int>((ref) {
  return ref.watch(dashboardControllerProvider).totalModules;
});

final activeBitacorasProvider = StreamProvider<int>((ref) {
  return ref.watch(dashboardControllerProvider).activeBitacoras;
});

final activeStudentsProvider = StreamProvider<int>((ref) {
  return ref.watch(dashboardControllerProvider).activeStudents;
});

final totalHoursProvider = StreamProvider<int>((ref) {
  return ref.watch(dashboardControllerProvider).totalHours;
});

final todaySessionsProvider = StreamProvider<List<TodaySessionData>>((ref) {
  return ref.watch(dashboardControllerProvider).todaySessions;
});

final upcomingSessionsProvider = StreamProvider<List<TodaySessionData>>((ref) {
  return ref.watch(dashboardControllerProvider).upcomingSessions;
});

/// Sesiones de días pasados que aún no han sido marcadas como impartidas.
/// Alimenta el banner de advertencia en el Dashboard.
final pendingPastSessionsProvider = StreamProvider<List<TodaySessionData>>((ref) {
  return ref.watch(bitacoraDaoProvider).watchPendingPastSessions();
});
