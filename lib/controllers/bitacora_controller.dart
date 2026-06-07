import 'package:drift/drift.dart';
import '../database/app_database.dart';
import '../database/daos.dart';
import '../database/tables.dart';
import '../services/dosificacion_service.dart';

class BitacoraController {
  final AppDatabase db;
  final BitacoraDao bitacoraDao;
  final ModuleDao moduleDao;
  final CareerDao careerDao;
  final UnitDao unitDao;
  final ActivityDao activityDao;

  BitacoraController({
    required this.db,
    required this.bitacoraDao,
    required this.moduleDao,
    required this.careerDao,
    required this.unitDao,
    required this.activityDao,
  });

  Stream<List<BitacoraWithModule>> watchBitacorasWithModule() =>
      bitacoraDao.watchBitacorasWithModule();

  Future<List<Module>> getAllModules() =>
      moduleDao.getAllModules();

  Future<List<Career>> getAllCareers() =>
      careerDao.getAllCareers();

  Future<List<Unit>> getUnitsByModule(String moduleCode) =>
      unitDao.getUnitsByModule(moduleCode);

  Future<List<Activity>> getActivitiesByUnit(String unitCode) =>
      activityDao.getActivitiesByUnit(unitCode);

  Future<int> createBitacora({
    required Module module,
    required List<Unit> units,
    required List<Activity> activities,
    required int frecuenciaClase,
    required DateTime fechaInicio,
    required List<String> diasClase,
    required List<String> fechasFeriadas,
    required String carrera,
    required TipoCarrera tipoCarrera,
    required bool usarHorasReloj,
    String? codigoGrupo,
  }) async {
    final schedule = DosificacionService.dosificar(
      module: module,
      units: units,
      activities: activities,
      fechaInicio: fechaInicio,
      diasClase: diasClase,
      horasSesion: frecuenciaClase,
      fechasFeriadas: fechasFeriadas,
      usarHorasReloj: usarHorasReloj,
    );

    if (schedule.isEmpty) return -1;

    final bitacoraId = await db.transaction(() async {
      final id = await bitacoraDao.createBitacora(BitacorasCompanion(
        frecuenciaClase: Value(frecuenciaClase),
        fechaInicio: Value(fechaInicio),
        usarHorasReloj: Value(usarHorasReloj),
        fechasFeriadas: Value(fechasFeriadas),
        diasClase: Value(diasClase),
        codigoGrupo: Value(codigoGrupo),
        carrera: Value(carrera),
        tipoCarrera: Value(tipoCarrera),
        estado: Value(EstadoBitacora.activo),
        idModule: Value(module.codModule),
      ));

      final entries = schedule.map((e) => e.copyWith(
        idBitacora: Value(id),
      ));

      await bitacoraDao.createCalendarioEntries(entries.toList());
      return id;
    });
    return bitacoraId;
  }

  Future<int> createBitacoraFromPreview({
    required BitacorasCompanion bitacora,
    required List<CalendarioBitacorasCompanion> sessions,
  }) async {
    return db.transaction(() async {
      final id = await bitacoraDao.createBitacora(bitacora);
      await bitacoraDao.createCalendarioEntries(
        sessions.map((s) => s.copyWith(idBitacora: Value(id))).toList(),
      );
      return id;
    });
  }

  Future<void> finalizeBitacora(int idBitacora) async {
    await (db.update(db.bitacoras)
          ..where((t) => t.id.equals(idBitacora)))
        .write(BitacorasCompanion(
      estado: const Value(EstadoBitacora.finalizado),
      fechaFinal: Value(DateTime.now()),
    ));
  }

  Future<void> deleteBitacora(int idBitacora) =>
      bitacoraDao.deleteBitacora(idBitacora);

  Future<void> updateBitacora(Bitacora bitacora) =>
      bitacoraDao.updateBitacora(bitacora);

  Future<List<String>> getAllGroups() async {
    final bitacoras = await bitacoraDao.getAllBitacoras();
    final grupos = <String>{};
    for (final bitacora in bitacoras) {
      if (bitacora.codigoGrupo != null && bitacora.codigoGrupo!.isNotEmpty) {
        grupos.add(bitacora.codigoGrupo!);
      }
    }
    return grupos.toList();
  }

  Future<List<CalendarioBitacora>> reDosifyBitacora({
    required int bitacoraId,
    required int frecuenciaClase,
    required bool usarHorasReloj,
    required Module module,
    required DateTime fechaInicio,
    required List<String> diasClase,
    required List<String> fechasFeriadas,
  }) async {
    await bitacoraDao.updateBitacora(BitacorasCompanion(
      frecuenciaClase: Value(frecuenciaClase),
      usarHorasReloj: Value(usarHorasReloj),
    ));

    final units = await unitDao.getUnitsByModule(module.codModule);
    final allActivities = <Activity>[];
    for (final unit in units) {
      final acts = await activityDao.getActivitiesByUnit(unit.codUnit);
      allActivities.addAll(acts);
    }

    final schedule = DosificacionService.dosificar(
      module: module,
      units: units,
      activities: allActivities,
      fechaInicio: fechaInicio,
      diasClase: diasClase,
      horasSesion: frecuenciaClase,
      fechasFeriadas: fechasFeriadas,
      usarHorasReloj: usarHorasReloj,
    );

    await db.transaction(() async {
      await bitacoraDao.deleteCalendarioForBitacora(bitacoraId);
      await bitacoraDao.createCalendarioEntries(
        schedule.map((s) => s.copyWith(idBitacora: Value(bitacoraId))).toList(),
      );
    });

    return bitacoraDao.getCalendarioForBitacora(bitacoraId);
  }

  Future<List<CalendarioBitacora>> getCalendario(int idBitacora) =>
      bitacoraDao.getCalendarioForBitacora(idBitacora);

  Stream<List<CalendarioBitacora>> watchCalendario(int idBitacora) =>
      bitacoraDao.watchCalendarioForBitacora(idBitacora);

  Future<void> updateCalendarioEntry(CalendarioBitacora entry) =>
      bitacoraDao.updateCalendarioEntry(entry);
}
