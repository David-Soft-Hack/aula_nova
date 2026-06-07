import '../../database/daos.dart';
import '../../models/app_models.dart';

abstract class IBitacoraController {
  Stream<List<BitacoraWithModule>> watchBitacorasWithModule();
  Future<List<Module>> getAllModules();
  Future<List<Unit>> getUnitsByModule(String moduleCode);
  Future<List<Activity>> getActivitiesByUnit(String unitCode);

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
  });

  Future<int> createBitacoraFromPreview({
    required BitacorasCompanion bitacora,
    required List<CalendarioBitacorasCompanion> sessions,
  });

  Future<void> finalizeBitacora(int idBitacora);
  Future<void> deleteBitacora(int idBitacora);
  Future<void> updateBitacora(Bitacora bitacora);
  Future<List<String>> getAllGroups();

  Future<List<CalendarioBitacorasCompanion>> previewSchedule({
    required Module module,
    required DateTime fechaInicio,
    required List<String> diasClase,
    required int horasSesion,
    required List<String> fechasFeriadas,
    required bool usarHorasReloj,
  });

  Future<List<CalendarioBitacora>> reDosifyBitacora({
    required int bitacoraId,
    required int frecuenciaClase,
    required bool usarHorasReloj,
    required Module module,
    required DateTime fechaInicio,
    required List<String> diasClase,
    required List<String> fechasFeriadas,
  });

  Future<List<CalendarioBitacora>> getCalendario(int idBitacora);
  Stream<List<CalendarioBitacora>> watchCalendario(int idBitacora);
  Future<void> updateCalendarioEntry(CalendarioBitacora entry);
  Stream<List<TodaySessionData>> watchAllSessions();
}
