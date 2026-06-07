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
  final BitacoraDao _bitacoraDao;

  ModuleController({
    required AppDatabase db,
    required IModuleRepository moduleRepository,
    required ModuleFactory moduleFactory,
    required BitacoraDao bitacoraDao,
  })  : _db = db,
        _repository = moduleRepository,
        _moduleFactory = moduleFactory,
        _bitacoraDao = bitacoraDao;

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
      for (final u in existingUnits) {
        await _repository.deleteActivitiesByUnit(u.codUnit);
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
      final units = await _repository.getUnitsByModule(moduleCode);
      for (final unit in units) {
        await _repository.deleteActivitiesByUnit(unit.codUnit);
      }
      await _repository.deleteUnitsByModule(moduleCode);

      final bitacoras = await _bitacoraDao.getBitacorasByModule(moduleCode);
      for (final bitacora in bitacoras) {
        await _bitacoraDao.deleteCalendarioForBitacora(bitacora.id);
      }
      await _bitacoraDao.deleteBitacorasByModule(moduleCode);

      await (_db.delete(_db.modules)..where((m) => m.codModule.equals(moduleCode))).go();
    });
  }
}
