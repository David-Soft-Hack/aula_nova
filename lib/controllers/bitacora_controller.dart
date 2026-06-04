import 'package:drift/drift.dart';
import '../database/app_database.dart';
import '../database/daos.dart';
import '../database/tables.dart';
import '../models/database_provider.dart';
import '../services/dosificacion_service.dart';

class BitacoraController {
  final BitacoraDao _dao = DatabaseProvider.bitacoraDao;

  Stream<List<BitacoraWithModule>> watchBitacorasWithModule() =>
      _dao.watchBitacorasWithModule();

  Future<List<Module>> getAllModules() =>
      DatabaseProvider.moduleDao.getAllModules();

  Future<List<Career>> getAllCareers() =>
      DatabaseProvider.careerDao.getAllCareers();

  Future<List<Unit>> getUnitsByModule(String moduleCode) =>
      DatabaseProvider.unitDao.getUnitsByModule(moduleCode);

  Future<List<Activity>> getActivitiesByUnit(String unitCode) =>
      DatabaseProvider.activityDao.getActivitiesByUnit(unitCode);

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

    final bitacoraId = await _dao.createBitacora(BitacorasCompanion(
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

    await _dao.createCalendarioEntries(entries.toList());
    return bitacoraId;
  }

  Future<void> finalizeBitacora(int idBitacora) async {
    await (DatabaseProvider.db.update(DatabaseProvider.db.bitacoras)
          ..where((t) => t.id.equals(idBitacora)))
        .write(BitacorasCompanion(
      estado: const Value(EstadoBitacora.finalizado),
      fechaFinal: Value(DateTime.now()),
    ));
  }

  Future<void> deleteBitacora(int idBitacora) =>
      _dao.deleteBitacora(idBitacora);

  Future<void> updateBitacora(Bitacora bitacora) =>
      _dao.updateBitacora(bitacora);

  Future<List<CalendarioBitacora>> getCalendario(int idBitacora) =>
      _dao.getCalendarioForBitacora(idBitacora);

  Stream<List<CalendarioBitacora>> watchCalendario(int idBitacora) =>
      _dao.watchCalendarioForBitacora(idBitacora);

  Future<void> updateCalendarioEntry(CalendarioBitacora entry) =>
      _dao.updateCalendarioEntry(entry);
}
