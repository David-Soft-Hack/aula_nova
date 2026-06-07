import '../../database/app_database.dart';

abstract class IDosificacionService {
  List<CalendarioBitacorasCompanion> dosificar({
    required Module module,
    required List<Unit> units,
    required List<Activity> activities,
    required DateTime fechaInicio,
    required List<String> diasClase,
    required int horasSesion,
    List<String> fechasFeriadas = const [],
    bool usarHorasReloj = false,
  });
}
