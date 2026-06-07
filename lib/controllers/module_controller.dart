import 'package:drift/drift.dart';
import '../database/app_database.dart';
import '../database/daos.dart';

class ModuleController {
  final AppDatabase db;
  final ModuleDao moduleDao;
  final UnitDao unitDao;
  final ActivityDao activityDao;

  ModuleController({
    required this.db,
    required this.moduleDao,
    required this.unitDao,
    required this.activityDao,
  });

  Future<void> createModuleWithDetails({
    required Module module,
    required List<Unit> units,
    required List<Activity> activities,
  }) async {
    await moduleDao.insertModule(
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
      await unitDao.insertUnit(
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
      await activityDao.insertActivity(
        ActivitiesCompanion.insert(
          codActivity: activity.codActivity,
          descripcion: activity.descripcion,
          totalHoraAcademic: activity.totalHoraAcademic,
          totalHoraReloj: activity.totalHoraReloj,
          idUnit: activity.idUnit,
        ),
      );
    }
  }

  Future<void> updateModuleWithDetails({
    required Module module,
    required List<Unit> units,
    required List<Activity> activities,
  }) async {
    await db.transaction(() async {
      await moduleDao.updateModule(module);

      final existingUnits = await unitDao.getUnitsByModule(module.codModule);
      for (final u in existingUnits) {
        await (db.delete(db.activities)..where((a) => a.idUnit.equals(u.codUnit))).go();
      }
      await unitDao.deleteUnitsByModule(module.codModule);

      for (final unit in units) {
        await unitDao.insertUnit(
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
        await activityDao.insertActivity(
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

  Future<void> deleteModuleWithDetails(String moduleCode) async {
    await db.transaction(() async {
      final units = await (db.select(db.units)..where((u) => u.idModule.equals(moduleCode))).get();
      for (final unit in units) {
        await (db.delete(db.activities)..where((a) => a.idUnit.equals(unit.codUnit))).go();
      }

      await (db.delete(db.units)..where((u) => u.idModule.equals(moduleCode))).go();

      final bitacoras = await (db.select(db.bitacoras)..where((b) => b.idModule.equals(moduleCode))).get();
      for (final bitacora in bitacoras) {
        await (db.delete(db.calendarioBitacoras)..where((c) => c.idBitacora.equals(bitacora.id))).go();
      }

      await (db.delete(db.bitacoras)..where((b) => b.idModule.equals(moduleCode))).go();

      await (db.delete(db.modules)..where((m) => m.codModule.equals(moduleCode))).go();
    });
  }
}
