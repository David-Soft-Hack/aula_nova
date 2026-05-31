import 'package:drift/drift.dart';
import '../database/app_database.dart';

/// Servicio responsable de ejecutar el algoritmo de dosificación de clases.
/// Decopla la lógica matemática/académica de la capa de interfaz de usuario (SOLID - SRP).
class DosificacionService {
  static List<CalendarioBitacorasCompanion> dosificar({
    required Module module,
    required List<Unit> units,
    required List<Activity> activities,
    required DateTime fechaInicio,
    required List<String> diasClase,
    required int horasSesion,
    List<String> fechasFeriadas = const [],
    bool usarHorasReloj = false,
  }) {
    List<CalendarioBitacorasCompanion> schedule = [];

    if (diasClase.isEmpty || activities.isEmpty) return schedule;

    // Ordenar actividades según el orden secuencial de las unidades
    List<Activity> sortedActivities = [];
    for (var unit in units) {
      var unitActs = activities.where((a) => a.idUnit == unit.codUnit).toList();
      sortedActivities.addAll(unitActs);
    }

    const mapDias = {
      'Lunes': DateTime.monday,
      'Martes': DateTime.tuesday,
      'Miércoles': DateTime.wednesday,
      'Jueves': DateTime.thursday,
      'Viernes': DateTime.friday,
      'Sábado': DateTime.saturday,
      'Domingo': DateTime.sunday,
    };

    String formatDate(DateTime d) {
      final year = d.year.toString();
      final month = d.month.toString().padLeft(2, '0');
      final day = d.day.toString().padLeft(2, '0');
      return '$year-$month-$day';
    }

    DateTime getNextClassDate(DateTime fromDate) {
      DateTime date = fromDate;
      int guard = 0;
      while (guard < 1000) {
        int weekday = date.weekday;
        String dayName = mapDias.entries.firstWhere((e) => e.value == weekday).key;
        final dateStr = formatDate(date);
        if (diasClase.contains(dayName) && !fechasFeriadas.contains(dateStr)) {
          return date;
        }
        date = date.add(const Duration(days: 1));
        guard++;
      }
      return date;
    }

    // Inicializamos el primer día de clases
    DateTime currentDate = getNextClassDate(fechaInicio);
    int currentSessionUsedUnits = 0;

    for (var activity in sortedActivities) {
      // Seleccionar la unidad de tiempo según el modo elegido por el docente
      // - HR (Horas Reloj): sesión de 60 min  → usa totalHoraReloj
      // - HA (Horas Académicas): sesión de 45 min → usa totalHoraAcademic
      int pendingUnits = usarHorasReloj
          ? activity.totalHoraReloj
          : activity.totalHoraAcademic;
      bool isContinuation = false;

      // Si la actividad no tiene horas definidas se saltea
      if (pendingUnits <= 0) continue;

      // Mientras la actividad tenga horas pendientes por acomodar
      while (pendingUnits > 0) {

        // Si el día actual ya alcanzó su límite (ej. llegó a horasSesion)
        if (currentSessionUsedUnits >= horasSesion) {
          // Abrimos una nueva sesión en la siguiente fecha
          currentDate = getNextClassDate(currentDate.add(const Duration(days: 1)));
          currentSessionUsedUnits = 0;
        }

        // ¿Cuántas horas podemos asignar hoy?
        int remainingUnits = horasSesion - currentSessionUsedUnits;
        int unitsToAssign = pendingUnits;
        if (unitsToAssign > remainingUnits) {
          unitsToAssign = remainingUnits;
        }

        // Registramos el fragmento de la actividad
        String actDisplay = activity.codActivity;
        if (isContinuation) {
          actDisplay += ' (Cont.)';
        }

        // El campo horaImpartir siempre guardará la cantidad en el formato que el docente seleccionó.
        schedule.add(CalendarioBitacorasCompanion(
          codUnidad: Value(activity.idUnit),
          codActividad: Value(actDisplay),
          fechaProgramada: Value(currentDate),
          estadoImpartido: const Value(false),
          horaImpartir: Value(unitsToAssign),
        ));

        // Actualizamos las horas usadas en esta sesión
        currentSessionUsedUnits += unitsToAssign;

        // Descontamos las horas que acabamos de ubicar
        pendingUnits -= unitsToAssign;

        // Si aún sobran horas, la siguiente entrada será continuación
        if (pendingUnits > 0) {
          isContinuation = true;
        }
      }
    }

    return schedule;
  }
}
