import 'package:aula_nova/database/daos.dart';
import 'package:drift/drift.dart';
import '../../database/app_database.dart';

abstract class IBitacoraRepository {
  Future<int> createBitacora(Insertable<Bitacora> bitacora);
  Future<List<Bitacora>> getAllBitacoras();
  Future<void> autoCompletePastSessions();
  Stream<List<BitacoraWithModule>> watchBitacorasWithModule();
  Future<void> createCalendarioEntries(
    List<CalendarioBitacorasCompanion> entries,
  );
  Stream<List<CalendarioBitacora>> watchCalendarioForBitacora(int idBitacora);
  Future<List<CalendarioBitacora>> getCalendarioForBitacora(int idBitacora);
  Future<void> updateCalendarioEntry(Insertable<CalendarioBitacora> entry);
  Future<int> deleteCalendarioForBitacora(int idBitacora);
  Future<void> deleteBitacora(int idBitacora);
  Future<void> updateBitacora(Insertable<Bitacora> bitacora);
  Future<List<Bitacora>> getBitacorasByModule(String moduleCode);
  Future<void> deleteBitacorasByModule(String moduleCode);
  Stream<List<TodaySessionData>> watchTodaySessions();
  Stream<List<TodaySessionData>> watchUpcomingSessions({int days = 7});
}

abstract class IModuleRepository {
  Future<List<Module>> getAllModules();
  Stream<List<Module>> watchAllModules();
  Future<void> insertModule(Insertable<Module> module);
  Future<void> updateModule(Insertable<Module> module);
  Future<void> deleteModule(Insertable<Module> module);
  Future<Module?> getModuleByCod(String cod);
  Future<int> countModulesByCareer(String careerName);
  Stream<List<Module>> watchModulesByCareer(String careerName);
}

abstract class IUnitRepository {
  Future<List<Unit>> getUnitsByModule(String idModule);
  Future<void> insertUnit(Insertable<Unit> unit);
  Future<void> updateUnit(Insertable<Unit> unit);
  Future<void> deleteUnit(Insertable<Unit> unit);
  Future<void> deleteUnitsByModule(String idModule);
}

abstract class IActivityRepository {
  Future<void> insertActivity(Insertable<Activity> activity);
  Future<void> updateActivity(Insertable<Activity> activity);
  Future<void> deleteActivity(Insertable<Activity> activity);
  Future<void> deleteActivityByCode(String codActivity);
  Future<List<Activity>> getActivitiesByUnit(String idUnit);
  Future<void> deleteActivitiesByUnit(String idUnit);
}

abstract class ICareerRepository {
  Future<List<Career>> getAllCareers();
  Stream<List<Career>> watchAllCareers();
  Future<void> insertCareer(Insertable<Career> career);
  Future<void> updateCareer(Insertable<Career> career);
  Future<void> deleteCareer(Insertable<Career> career);
}

abstract class IClassGroupRepository {
  Future<List<ClassGroup>> getAllGroups();
  Stream<List<ClassGroup>> watchAllGroups();
  Future<void> insertGroup(Insertable<ClassGroup> group);
  Future<void> updateGroup(Insertable<ClassGroup> group);
  Future<void> deleteGroup(Insertable<ClassGroup> group);
  Future<ClassGroup?> getGroupByCodigo(String codigo);
  Future<List<ClassGroup>> searchGroups(String query);
}

abstract class IStudentRepository {
  Future<List<Student>> getAllStudents();
  Stream<List<Student>> watchAllStudents();
  Future<Student?> getStudentById(int id);
  Future<Student?> getStudentByCodigo(String codigo);
  Future<List<Student>> searchStudents(String query);
  Future<void> insertStudent(Insertable<Student> student);
  Future<void> updateStudent(Insertable<Student> student);
  Future<void> deleteStudent(Insertable<Student> student);
}

abstract class IAttendanceRepository {
  Future<List<Attendance>> getAttendancesBySession(int sessionId);
  Future<void> saveAttendances(List<AttendancesCompanion> records);
  Future<void> upsertAttendance(AttendancesCompanion record);
}

abstract class IDatabaseAccess {
  Future<void> transaction(Future<void> Function() fn);
}
