import '../../database/daos.dart';

abstract class IDashboardController {
  Stream<int> get totalModules;
  Stream<int> get activeBitacoras;
  Stream<int> get activeStudents;
  Stream<int> get totalHours;
  Stream<List<TodaySessionData>> get todaySessions;
  Stream<List<TodaySessionData>> get upcomingSessions;
}
