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

    final bitacoraId = await bitacoraDao.createBitacora(BitacorasCompanion(
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
      idBitacora: Value(bitacoraId),
    ));

    await bitacoraDao.createCalendarioEntries(entries.toList());
    return bitacoraId;
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

  Future<List<CalendarioBitacora>> getCalendario(int idBitacora) =>
      bitacoraDao.getCalendarioForBitacora(idBitacora);

  Stream<List<CalendarioBitacora>> watchCalendario(int idBitacora) =>
      bitacoraDao.watchCalendarioForBitacora(idBitacora);

  Future<void> updateCalendarioEntry(CalendarioBitacora entry) =>
      bitacoraDao.updateCalendarioEntry(entry);
}
