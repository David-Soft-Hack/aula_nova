import '../../database/app_database.dart';

abstract class IModuleController {
  Future<void> createModuleWithDetails({
    required Module module,
    required List<Unit> units,
    required List<Activity> activities,
  });

  Future<void> updateModuleWithDetails({
    required Module module,
    required List<Unit> units,
    required List<Activity> activities,
  });

  Future<bool> checkModuleExists(String codModule);
  Future<List<Module>> getAllModules();
  Stream<List<Module>> watchModulesByCareer(String career);
  Future<void> updateModule(Module module);
  Future<List<Unit>> getUnitsByModule(String moduleCode);
  Future<void> updateUnit(Unit unit);
  Future<List<Activity>> getActivitiesByUnit(String unitCode);
  Future<void> updateActivity(Activity activity);
  Future<void> insertUnit(UnitsCompanion unit);
  Future<void> deleteUnit(String unitCode);
  Future<void> insertActivity(ActivitiesCompanion activity);
  Future<void> deleteActivity(String activityCode);

  Future<void> createModuleFromMaps({
    required String codModule,
    required String nombre,
    required String carrera,
    required int totalHoraAcademic,
    required int totalHoraReloj,
    required List<Map<String, dynamic>> units,
    required List<Map<String, dynamic>> activities,
  });

  Future<void> deleteModuleWithDetails(String moduleCode);
}
