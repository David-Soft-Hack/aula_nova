import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/daos.dart';
import 'bitacora_providers.dart';

/// Provider que transmite todas las sesiones de calendario desde la base de datos.
final allCalendarSessionsProvider = StreamProvider<List<TodaySessionData>>((ref) {
  final controller = ref.watch(bitacoraControllerProvider);
  return controller.watchAllSessions();
});

/// Mes activo que se muestra en la cuadrícula del calendario (Año, Mes, 1).
final activeMonthProvider = StateProvider<DateTime>((ref) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, 1);
});

/// Día seleccionado en el calendario.
final selectedDateProvider = StateProvider<DateTime>((ref) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
});

/// Filtros para la vista de calendario
class CalendarFiltersState {
  final String? career;
  final String? groupCode;
  final bool? onlyPending;

  const CalendarFiltersState({
    this.career,
    this.groupCode,
    this.onlyPending,
  });

  CalendarFiltersState copyWith({
    String? career,
    String? groupCode,
    bool? onlyPending,
    bool clearCareer = false,
    bool clearGroup = false,
    bool clearOnlyPending = false,
  }) {
    return CalendarFiltersState(
      career: clearCareer ? null : (career ?? this.career),
      groupCode: clearGroup ? null : (groupCode ?? this.groupCode),
      onlyPending: clearOnlyPending ? null : (onlyPending ?? this.onlyPending),
    );
  }
}

final calendarFiltersProvider = StateProvider<CalendarFiltersState>((ref) {
  return const CalendarFiltersState();
});

/// Filtra la lista completa de sesiones basándose en los filtros seleccionados.
final filteredCalendarSessionsProvider = Provider<List<TodaySessionData>>((ref) {
  final sessionsAsync = ref.watch(allCalendarSessionsProvider);
  final filters = ref.watch(calendarFiltersProvider);

  return sessionsAsync.maybeWhen(
    data: (sessions) {
      return sessions.where((session) {
        if (filters.career != null && session.career != filters.career) {
          return false;
        }
        if (filters.groupCode != null && session.groupCode != filters.groupCode) {
          return false;
        }
        if (filters.onlyPending != null && filters.onlyPending!) {
          if (session.entry.estadoImpartido) {
            return false;
          }
        }
        return true;
      }).toList();
    },
    orElse: () => [],
  );
});

/// Filtra las sesiones correspondientes al día seleccionado actualmente.
final sessionsForSelectedDateProvider = Provider<List<TodaySessionData>>((ref) {
  final filteredSessions = ref.watch(filteredCalendarSessionsProvider);
  final selectedDate = ref.watch(selectedDateProvider);

  return filteredSessions.where((session) {
    final date = session.entry.fechaProgramada;
    if (date == null) return false;
    return date.year == selectedDate.year &&
        date.month == selectedDate.month &&
        date.day == selectedDate.day;
  }).toList();
});
