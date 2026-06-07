import 'package:drift/drift.dart';
import '../../database/app_database.dart';

abstract class IModuleRepository {
  Future<List<Module>> getAllModules();
  Stream<List<Module>> watchAllModules();
  Future<Module?> getModuleByCod(String cod);
  Future<void> insertModule(Insertable<Module> module);
  Future<void> updateModule(Insertable<Module> module);
  Future<void> deleteModule(Insertable<Module> module);
  Future<int> countModulesByCareer(String careerName);
  Stream<List<Module>> watchModulesByCareer(String careerName);

  // Units
  Future<List<Unit>> getUnitsByModule(String idModule);
  Future<Unit?> getUnitByCod(String codUnit);
  Stream<Unit?> watchUnitByCod(String codUnit);
  Future<void> insertUnit(Insertable<Unit> unit);
  Future<void> updateUnit(Insertable<Unit> unit);
  Future<void> deleteUnit(Insertable<Unit> unit);
  Future<void> deleteUnitsByModule(String idModule);

  // Activities
  Future<List<Activity>> getActivitiesByUnit(String idUnit);
  Future<Activity?> getActivityByCod(String codActivity);
  Stream<Activity?> watchActivityByCod(String codActivity);
  Future<void> insertActivity(Insertable<Activity> activity);
  Future<void> updateActivity(Insertable<Activity> activity);
  Future<void> deleteActivity(Insertable<Activity> activity);
  Future<void> deleteActivityByCode(String codActivity);
  Future<void> deleteActivitiesByUnit(String idUnit);
}
