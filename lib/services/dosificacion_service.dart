import 'package:drift/drift.dart';
import '../database/app_database.dart';
import '../interfaces/services/i_dosificacion_service.dart';

class DosificacionService implements IDosificacionService {
  static const _maxClassSearchDays = 366;
  static const _continuationSuffix = ' (Cont.)';

  static const _weekdayNames = <int, String>{
    DateTime.monday: 'Lunes',
    DateTime.tuesday: 'Martes',
    DateTime.wednesday: 'Miércoles',
    DateTime.thursday: 'Jueves',
    DateTime.friday: 'Viernes',
    DateTime.saturday: 'Sábado',
    DateTime.sunday: 'Domingo',
  };

  @override
  List<CalendarioBitacorasCompanion> dosificar({
    required Module module,
    required List<Unit> units,
    required List<Activity> activities,
    required DateTime fechaInicio,
    required List<String> diasClase,
    required int horasSesion,
    List<String> fechasFeriadas = const [],
    bool usarHorasReloj = false,
  }) {
    final schedule = <CalendarioBitacorasCompanion>[];

    if (diasClase.isEmpty || activities.isEmpty) return schedule;

    final sortedActivities = <Activity>[];
    for (final unit in units) {
      sortedActivities.addAll(activities.where((a) => a.idUnit == unit.codUnit));
    }

    final feriadas = fechasFeriadas.toSet();

    DateTime getNextClassDate(DateTime fromDate) {
      var date = fromDate;
      var guard = 0;
      while (guard < _maxClassSearchDays) {
        final weekday = date.weekday;
        final dayName = _weekdayNames[weekday] ?? '';
        final dateStr = _formatDate(date);
        if (diasClase.contains(dayName) && !feriadas.contains(dateStr)) {
          return date;
        }
        date = date.add(const Duration(days: 1));
        guard++;
      }
      return date;
    }

    var currentDate = getNextClassDate(fechaInicio);
    var currentSessionUsedUnits = 0;

    for (final activity in sortedActivities) {
      var pendingUnits = usarHorasReloj ? activity.totalHoraReloj : activity.totalHoraAcademic;
      var isContinuation = false;

      if (pendingUnits <= 0) continue;

      while (pendingUnits > 0) {
        if (currentSessionUsedUnits >= horasSesion) {
          currentDate = getNextClassDate(currentDate.add(const Duration(days: 1)));
          currentSessionUsedUnits = 0;
        }

        final remainingUnits = horasSesion - currentSessionUsedUnits;
        final unitsToAssign = pendingUnits > remainingUnits ? remainingUnits : pendingUnits;

        final actDisplay = isContinuation ? '${activity.codActivity}$_continuationSuffix' : activity.codActivity;

        schedule.add(CalendarioBitacorasCompanion(
          codUnidad: Value(activity.idUnit),
          codActividad: Value(actDisplay),
          fechaProgramada: Value(currentDate),
          estadoImpartido: const Value(false),
          horaImpartir: Value(unitsToAssign),
        ));

        currentSessionUsedUnits += unitsToAssign;
        pendingUnits -= unitsToAssign;
        if (pendingUnits > 0) isContinuation = true;
      }
    }

    return schedule;
  }

  static String _formatDate(DateTime d) {
    final year = d.year.toString();
    final month = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }
}
