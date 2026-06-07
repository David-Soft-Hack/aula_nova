import 'package:drift/drift.dart';
import '../database/app_database.dart';
import '../database/daos.dart';
import '../models/app_models.dart';
import '../interfaces/controllers/i_bitacora_controller.dart';
import '../interfaces/repositories/i_bitacora_repository.dart';
import '../interfaces/repositories/i_module_repository.dart';
import '../interfaces/services/i_dosificacion_service.dart';
import '../interfaces/services/i_student_status_service.dart';

class BitacoraController implements IBitacoraController {
  final AppDatabase _db;
  final IBitacoraRepository _bitacoraRepository;
  final IModuleRepository _moduleRepository;
  final IStudentStatusService _studentStatusService;
  final IDosificacionService _dosificacionService;

  BitacoraController({
    required AppDatabase db,
    required IBitacoraRepository bitacoraRepository,
    required IModuleRepository moduleRepository,
    required IStudentStatusService studentStatusService,
    required IDosificacionService dosificacionService,
  })  : _db = db,
        _bitacoraRepository = bitacoraRepository,
        _moduleRepository = moduleRepository,
        _studentStatusService = studentStatusService,
        _dosificacionService = dosificacionService;

  @override
  Stream<List<BitacoraWithModule>> watchBitacorasWithModule() =>
      _bitacoraRepository.watchBitacorasWithModule();

  @override
  Future<List<Module>> getAllModules() =>
      _moduleRepository.getAllModules();

  @override
  Future<List<Unit>> getUnitsByModule(String moduleCode) =>
      _moduleRepository.getUnitsByModule(moduleCode);

  @override
  Future<List<Activity>> getActivitiesByUnit(String unitCode) =>
      _moduleRepository.getActivitiesByUnit(unitCode);

  @override
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
    final schedule = _dosificacionService.dosificar(
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

    final bitacoraId = await _db.transaction(() async {
      final id = await _bitacoraRepository.createBitacora(BitacorasCompanion(
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

      await _bitacoraRepository.createCalendarioEntries(entries.toList());
      return id;
    });
    return bitacoraId;
  }

  @override
  Future<int> createBitacoraFromPreview({
    required BitacorasCompanion bitacora,
    required List<CalendarioBitacorasCompanion> sessions,
  }) async {
    return _db.transaction(() async {
      final id = await _bitacoraRepository.createBitacora(bitacora);
      await _bitacoraRepository.createCalendarioEntries(
        sessions.map((s) => s.copyWith(idBitacora: Value(id))).toList(),
      );
      return id;
    });
  }

  @override
  Future<void> finalizeBitacora(int idBitacora) async {
    await (_db.update(_db.bitacoras)
          ..where((t) => t.id.equals(idBitacora)))
        .write(BitacorasCompanion(
      estado: const Value(EstadoBitacora.finalizado),
      fechaFinal: Value(DateTime.now()),
    ));
  }

  @override
  Future<void> deleteBitacora(int idBitacora) async {
    final bitacora = await _bitacoraRepository.getAllBitacoras().then(
      (list) => list.where((b) => b.id == idBitacora).firstOrNull,
    );
    await _bitacoraRepository.deleteBitacora(idBitacora);
    if (bitacora?.codigoGrupo != null && bitacora!.codigoGrupo!.isNotEmpty) {
      final sessions = await _bitacoraRepository.getCalendarioForBitacora(idBitacora);
      final newStatus = await _studentStatusService.determineGroupFinalStatus(
        bitacora.codigoGrupo!,
        sessions,
      );
      await _studentStatusService.transitionActiveStudentsForGroup(
        bitacora.codigoGrupo!,
        newStatus,
      );
    }
  }

  @override
  Future<void> updateBitacora(Bitacora bitacora) =>
      _bitacoraRepository.updateBitacora(bitacora);

  @override
  Future<List<String>> getAllGroups() async {
    final bitacoras = await _bitacoraRepository.getAllBitacoras();
    final grupos = <String>{};
    for (final bitacora in bitacoras) {
      if (bitacora.codigoGrupo != null && bitacora.codigoGrupo!.isNotEmpty) {
        grupos.add(bitacora.codigoGrupo!);
      }
    }
    return grupos.toList();
  }

  @override
  Future<List<CalendarioBitacorasCompanion>> previewSchedule({
    required Module module,
    required DateTime fechaInicio,
    required List<String> diasClase,
    required int horasSesion,
    required List<String> fechasFeriadas,
    required bool usarHorasReloj,
  }) async {
    final units = await getUnitsByModule(module.codModule);
    final allActivities = <Activity>[];
    for (final unit in units) {
      final acts = await getActivitiesByUnit(unit.codUnit);
      allActivities.addAll(acts);
    }
    return _dosificacionService.dosificar(
      module: module,
      units: units,
      activities: allActivities,
      fechaInicio: fechaInicio,
      diasClase: diasClase,
      horasSesion: horasSesion,
      fechasFeriadas: fechasFeriadas,
      usarHorasReloj: usarHorasReloj,
    );
  }

  @override
  Future<List<CalendarioBitacora>> reDosifyBitacora({
    required int bitacoraId,
    required int frecuenciaClase,
    required bool usarHorasReloj,
    required Module module,
    required DateTime fechaInicio,
    required List<String> diasClase,
    required List<String> fechasFeriadas,
  }) async {
    await _bitacoraRepository.updateBitacora(BitacorasCompanion(
      frecuenciaClase: Value(frecuenciaClase),
      usarHorasReloj: Value(usarHorasReloj),
    ));

    final units = await _moduleRepository.getUnitsByModule(module.codModule);
    final allActivities = <Activity>[];
    for (final unit in units) {
      final acts = await _moduleRepository.getActivitiesByUnit(unit.codUnit);
      allActivities.addAll(acts);
    }

    final schedule = _dosificacionService.dosificar(
      module: module,
      units: units,
      activities: allActivities,
      fechaInicio: fechaInicio,
      diasClase: diasClase,
      horasSesion: frecuenciaClase,
      fechasFeriadas: fechasFeriadas,
      usarHorasReloj: usarHorasReloj,
    );

    await _db.transaction(() async {
      await _bitacoraRepository.deleteCalendarioForBitacora(bitacoraId);
      await _bitacoraRepository.createCalendarioEntries(
        schedule.map((s) => s.copyWith(idBitacora: Value(bitacoraId))).toList(),
      );
    });

    return _bitacoraRepository.getCalendarioForBitacora(bitacoraId);
  }

  @override
  Future<List<CalendarioBitacora>> getCalendario(int idBitacora) =>
      _bitacoraRepository.getCalendarioForBitacora(idBitacora);

  @override
  Stream<List<CalendarioBitacora>> watchCalendario(int idBitacora) =>
      _bitacoraRepository.watchCalendarioForBitacora(idBitacora);

  @override
  Future<void> updateCalendarioEntry(CalendarioBitacora entry) =>
      _bitacoraRepository.updateCalendarioEntry(entry);

  @override
  Stream<List<TodaySessionData>> watchAllSessions() =>
      _bitacoraRepository.watchAllSessions();
}
