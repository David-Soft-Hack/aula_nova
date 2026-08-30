import 'package:drift/drift.dart';
import '../database/app_database.dart';
import '../database/daos.dart';
import '../interfaces/controllers/i_module_controller.dart';
import '../interfaces/repositories/i_module_repository.dart';
import '../services/module_factory.dart';

class ModuleController implements IModuleController {
  final AppDatabase _db;
  final IModuleRepository _repository;
  final ModuleFactory _moduleFactory;

  ModuleController({
    required AppDatabase db,
    required IModuleRepository moduleRepository,
    required ModuleFactory moduleFactory,
    required BitacoraDao bitacoraDao,
  })  : _db = db,
        _repository = moduleRepository,
        _moduleFactory = moduleFactory;

  @override
  Future<void> createModuleWithDetails({
    required Module module,
    required List<Unit> units,
    required List<Activity> activities,
  }) async {
    await _db.transaction(() async {
      await _repository.insertModule(
        ModulesCompanion.insert(
          codModule: module.codModule,
          nombre: module.nombre,
          totalHoraAcademic: module.totalHoraAcademic,
          totalHoraReloj: module.totalHoraReloj,
          carrera: Value(module.carrera),
          fechaCreacion: Value(module.fechaCreacion),
        ),
      );

      for (final unit in units) {
        await _repository.insertUnit(
          UnitsCompanion.insert(
            codUnit: unit.codUnit,
            nombre: unit.nombre,
            totalHoraAcademic: unit.totalHoraAcademic,
            totalHoraReloj: unit.totalHoraReloj,
            ponderacion: unit.ponderacion,
            idModule: unit.idModule,
          ),
        );
      }

      for (final activity in activities) {
        await _repository.insertActivity(
          ActivitiesCompanion.insert(
            codActivity: activity.codActivity,
            descripcion: activity.descripcion,
            totalHoraAcademic: activity.totalHoraAcademic,
            totalHoraReloj: activity.totalHoraReloj,
            idUnit: activity.idUnit,
          ),
        );
      }
    });
  }

  @override
  Future<void> updateModuleWithDetails({
    required Module module,
    required List<Unit> units,
    required List<Activity> activities,
  }) async {
    await _db.transaction(() async {
      await _repository.updateModule(module);

      final existingUnits = await _repository.getUnitsByModule(module.codModule);
      final unitCodes = existingUnits.map((u) => u.codUnit).toList();
      if (unitCodes.isNotEmpty) {
        await _db.batch((batch) {
          for (final code in unitCodes) {
            batch.deleteWhere(_db.activities, (t) => t.idUnit.equals(code));
          }
        });
      }
      await _repository.deleteUnitsByModule(module.codModule);

      for (final unit in units) {
        await _repository.insertUnit(
          UnitsCompanion.insert(
            codUnit: unit.codUnit,
            nombre: unit.nombre,
            totalHoraAcademic: unit.totalHoraAcademic,
            totalHoraReloj: unit.totalHoraReloj,
            ponderacion: unit.ponderacion,
            idModule: unit.idModule,
          ),
        );
      }

      for (final activity in activities) {
        await _repository.insertActivity(
          ActivitiesCompanion.insert(
            codActivity: activity.codActivity,
            descripcion: activity.descripcion,
            totalHoraAcademic: activity.totalHoraAcademic,
            totalHoraReloj: activity.totalHoraReloj,
            idUnit: activity.idUnit,
          ),
        );
      }
    });
  }

  @override
  Future<bool> checkModuleExists(String codModule) async {
    final existing = await _repository.getModuleByCod(codModule);
    return existing != null;
  }

  @override
  Future<List<Module>> getAllModules() => _repository.getAllModules();

  @override
  Stream<List<Module>> watchModulesByCareer(String career) =>
      _repository.watchModulesByCareer(career);

  @override
  Future<void> updateModule(Module module) => _repository.updateModule(module);

  @override
  Future<List<Unit>> getUnitsByModule(String moduleCode) =>
      _repository.getUnitsByModule(moduleCode);

  @override
  Future<void> updateUnit(Unit unit) => _repository.updateUnit(unit);

  @override
  Future<List<Activity>> getActivitiesByUnit(String unitCode) =>
      _repository.getActivitiesByUnit(unitCode);

  @override
  Future<void> updateActivity(Activity activity) => _repository.updateActivity(activity);

  @override
  Future<void> insertUnit(UnitsCompanion unit) => _repository.insertUnit(unit);

  @override
  Future<void> deleteUnit(String unitCode) async {
    await _repository.deleteActivitiesByUnit(unitCode);
    await (_db.delete(_db.units)..where((t) => t.codUnit.equals(unitCode))).go();
  }

  @override
  Future<void> insertActivity(ActivitiesCompanion activity) =>
      _repository.insertActivity(activity);

  @override
  Future<void> deleteActivity(String activityCode) async {
    await _repository.deleteActivityByCode(activityCode);
  }

  @override
  Future<void> createModuleFromMaps({
    required String codModule,
    required String nombre,
    required String carrera,
    required int totalHoraAcademic,
    required int totalHoraReloj,
    required List<Map<String, dynamic>> units,
    required List<Map<String, dynamic>> activities,
  }) async {
    await _moduleFactory.validateModuleCodeNotExists(codModule);
    final unitsData = await _moduleFactory.createUnitsFromMaps(codModule, units);
    final activitiesData = await _moduleFactory.createActivitiesFromMaps(
      codModule,
      units,
      activities,
    );
    final module = _moduleFactory.createModule(
      codModule: codModule,
      nombre: nombre,
      carrera: carrera,
      totalHoraAcademic: totalHoraAcademic,
      totalHoraReloj: totalHoraReloj,
    );
    await createModuleWithDetails(
      module: module,
      units: unitsData,
      activities: activitiesData,
    );
  }

  @override
  Future<void> deleteModuleWithDetails(String moduleCode) async {
    await _db.transaction(() async {
      // 1. Obtener todas las bitácoras asociadas a este módulo utilizando directamente _db
      final bitacorasList = await (_db.select(_db.bitacoras)
            ..where((t) => t.idModule.equals(moduleCode)))
          .get();
      final bitacoraIds = bitacorasList.map((b) => b.id).toList();

      if (bitacoraIds.isNotEmpty) {
        // 2. Obtener todas las sesiones del calendario de estas bitácoras
        final sessions = await (_db.select(_db.calendarioBitacoras)
              ..where((t) => t.idBitacora.isIn(bitacoraIds)))
            .get();
        final sessionIds = sessions.map((s) => s.id).toList();

        if (sessionIds.isNotEmpty) {
          // 3. Eliminar todas las asistencias asociadas a estas sesiones
          await (_db.delete(_db.attendances)..where((t) => t.idSession.isIn(sessionIds))).go();
        }

        // 4. Eliminar las sesiones del calendario
        await (_db.delete(_db.calendarioBitacoras)..where((t) => t.idBitacora.isIn(bitacoraIds))).go();

        // 5. Eliminar las bitácoras
        await (_db.delete(_db.bitacoras)..where((t) => t.idModule.equals(moduleCode))).go();
      }

      // 6. Obtener unidades del módulo
      final units = await (_db.select(_db.units)
            ..where((t) => t.idModule.equals(moduleCode)))
          .get();
      final unitCodes = units.map((u) => u.codUnit).toList();

      if (unitCodes.isNotEmpty) {
        // 7. Eliminar todas las actividades asociadas a estas unidades
        await (_db.delete(_db.activities)..where((t) => t.idUnit.isIn(unitCodes))).go();
      }

      // 8. Eliminar las unidades
      await (_db.delete(_db.units)..where((t) => t.idModule.equals(moduleCode))).go();

      // 9. Finalmente, eliminar el módulo
      await (_db.delete(_db.modules)..where((m) => m.codModule.equals(moduleCode))).go();
    });
  }
}
