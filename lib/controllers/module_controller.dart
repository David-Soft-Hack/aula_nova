import 'package:drift/drift.dart';
import '../models/database_provider.dart';
import '../database/app_database.dart';

class ModuleController {
  /// Crea un nuevo módulo junto con sus unidades didácticas y actividades
  /// utilizando las clases del modelo generadas por Drift.
  Future<void> createModuleWithDetails({
    required Module module,
    required List<Unit> units,
    required List<Activity> activities,
  }) async {
    // 1. Insert Module
    await DatabaseProvider.moduleDao.insertModule(
      ModulesCompanion.insert(
        codModule: module.codModule,
        nombre: module.nombre,
        totalHoraAcademic: module.totalHoraAcademic,
        totalHoraReloj: module.totalHoraReloj,
        carrera: Value(module.carrera),
        fechaCreacion: Value(module.fechaCreacion),
      ),
    );

    // 2. Insert Units
    for (final unit in units) {
      await DatabaseProvider.unitDao.insertUnit(
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

    // 3. Insert Activities using ActivityDao (SOLID - SRP & DIP compliant)
    for (final activity in activities) {
      await DatabaseProvider.activityDao.insertActivity(
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

  /// Elimina un módulo y todas sus dependencias (unidades, actividades, bitácoras)
  Future<void> deleteModuleWithDetails(String moduleCode) async {
    final db = DatabaseProvider.db;
    
    await db.transaction(() async {
      // 1. Delete Activities
      final units = await (db.select(db.units)..where((u) => u.idModule.equals(moduleCode))).get();
      for (final unit in units) {
        await (db.delete(db.activities)..where((a) => a.idUnit.equals(unit.codUnit))).go();
      }

      // 2. Delete Units
      await (db.delete(db.units)..where((u) => u.idModule.equals(moduleCode))).go();

      // 3. Delete Calendarios from Bitacoras
      final bitacoras = await (db.select(db.bitacoras)..where((b) => b.idModule.equals(moduleCode))).get();
      for (final bitacora in bitacoras) {
        await (db.delete(db.calendarioBitacoras)..where((c) => c.idBitacora.equals(bitacora.id))).go();
      }

      // 4. Delete Bitacoras
      await (db.delete(db.bitacoras)..where((b) => b.idModule.equals(moduleCode))).go();

      // 5. Delete Module
      await (db.delete(db.modules)..where((m) => m.codModule.equals(moduleCode))).go();
    });
  }
}
