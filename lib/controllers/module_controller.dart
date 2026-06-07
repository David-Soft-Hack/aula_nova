import 'package:drift/drift.dart';
import '../database/app_database.dart';
import '../database/daos.dart';

class ModuleController {
  final AppDatabase db;
  final ModuleDao moduleDao;
  final UnitDao unitDao;
  final ActivityDao activityDao;
  final BitacoraDao bitacoraDao;

  ModuleController({
    required this.db,
    required this.moduleDao,
    required this.unitDao,
    required this.activityDao,
    required this.bitacoraDao,
  });

  Future<void> createModuleWithDetails({
    required Module module,
    required List<Unit> units,
    required List<Activity> activities,
  }) async {
    await db.transaction(() async {
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
    });
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
        await activityDao.deleteActivitiesByUnit(u.codUnit);
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

  Future<bool> checkModuleExists(String codModule) async {
    final existing = await moduleDao.getModuleByCod(codModule);
    return existing != null;
  }

  Future<List<Unit>> getUnitsByModule(String moduleCode) =>
      unitDao.getUnitsByModule(moduleCode);
  Future<List<Activity>> getActivitiesByUnit(String unitCode) =>
      activityDao.getActivitiesByUnit(unitCode);
  Future<void> insertUnit(UnitsCompanion unit) => unitDao.insertUnit(unit);
  Future<void> deleteUnit(String unitCode) async {
    await activityDao.deleteActivitiesByUnit(unitCode);
    await (db.delete(db.units)..where((t) => t.codUnit.equals(unitCode))).go();
  }
  Future<void> insertActivity(ActivitiesCompanion activity) =>
      activityDao.insertActivity(activity);
  Future<void> deleteActivity(String activityCode) async {
    await activityDao.deleteActivityByCode(activityCode);
  }

  Future<void> createModuleFromMaps({
    required String codModule,
    required String nombre,
    required String carrera,
    required int totalHoraAcademic,
    required int totalHoraReloj,
    required List<Map<String, dynamic>> units,
    required List<Map<String, dynamic>> activities,
  }) async {
    final existing = await moduleDao.getModuleByCod(codModule);
    if (existing != null) {
      throw Exception('El módulo con código "$codModule" ya existe.');
    }

    final unitsData = <Unit>[];
    final activitiesData = <Activity>[];

    for (int i = 0; i < units.length; i++) {
      final u = units[i];
      final unitCode = '$codModule-U${i + 1}';

      unitsData.add(Unit(
        codUnit: unitCode,
        nombre: u['nombre'].toString().isEmpty
            ? 'Unidad ${i + 1}'
            : u['nombre'].toString(),
        totalHoraAcademic: u['ha'] as int? ?? 0,
        totalHoraReloj: u['hr'] as int? ?? 0,
        ponderacion: u['ponderacion'] as double? ?? 0.0,
        idModule: codModule,
      ));

      final actsForUnit = activities.where((a) => a['unitIndex'] == i).toList();
      for (int j = 0; j < actsForUnit.length; j++) {
        final act = actsForUnit[j];
        final customCode = (act['codigo']?.toString().trim() ?? '').isEmpty
            ? 'A${j + 1}'
            : act['codigo'].toString().trim();
        final actCode = '$unitCode-$customCode';

        activitiesData.add(Activity(
          codActivity: actCode,
          descripcion: act['descripcion'].toString().isEmpty
              ? 'Actividad ${j + 1}'
              : act['descripcion'].toString(),
          totalHoraAcademic: act['ha'] as int? ?? 0,
          totalHoraReloj: act['hr'] as int? ?? 0,
          idUnit: unitCode,
        ));
      }
    }

    await createModuleWithDetails(
      module: Module(
        codModule: codModule,
        nombre: nombre.isEmpty ? 'Nuevo Módulo' : nombre,
        totalHoraAcademic: totalHoraAcademic,
        totalHoraReloj: totalHoraReloj,
        carrera: carrera,
        fechaCreacion: DateTime.now(),
      ),
      units: unitsData,
      activities: activitiesData,
    );
  }

  Future<void> deleteModuleWithDetails(String moduleCode) async {
    await db.transaction(() async {
      final units = await unitDao.getUnitsByModule(moduleCode);
      for (final unit in units) {
        await activityDao.deleteActivitiesByUnit(unit.codUnit);
      }
      await unitDao.deleteUnitsByModule(moduleCode);

      final bitacoras = await bitacoraDao.getBitacorasByModule(moduleCode);
      for (final bitacora in bitacoras) {
        await bitacoraDao.deleteCalendarioForBitacora(bitacora.id);
      }
      await bitacoraDao.deleteBitacorasByModule(moduleCode);

      await (db.delete(db.modules)..where((m) => m.codModule.equals(moduleCode))).go();
    });
  }
}
