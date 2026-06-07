import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/dashboard_controller.dart';
import '../database/daos.dart';
import 'database_providers.dart';

final dashboardControllerProvider = Provider<DashboardController>((ref) {
  return DashboardController(
    moduleDao: ref.watch(moduleDaoProvider),
    bitacoraDao: ref.watch(bitacoraDaoProvider),
    studentDao: ref.watch(studentDaoProvider),
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
