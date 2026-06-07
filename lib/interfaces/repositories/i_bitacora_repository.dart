import 'package:drift/drift.dart';
import '../../database/app_database.dart';
import '../../database/daos.dart';

abstract class IBitacoraRepository {
  // Bitacora CRUD
  Future<int> createBitacora(Insertable<Bitacora> bitacora);
  Future<List<Bitacora>> getAllBitacoras();
  Future<void> updateBitacora(Insertable<Bitacora> bitacora);
  Future<void> autoCompletePastSessions();
  Stream<List<BitacoraWithModule>> watchBitacorasWithModule();
  Future<List<Bitacora>> getBitacorasByModule(String moduleCode);
  Future<void> deleteBitacorasByModule(String moduleCode);

  // Calendar entries
  Future<void> createCalendarioEntries(List<CalendarioBitacorasCompanion> entries);
  Stream<List<CalendarioBitacora>> watchCalendarioForBitacora(int idBitacora);
  Future<List<CalendarioBitacora>> getCalendarioForBitacora(int idBitacora);
  Future<void> updateCalendarioEntry(Insertable<CalendarioBitacora> entry);
  Future<void> deleteCalendarioForBitacora(int idBitacora);
  Future<void> deleteBitacora(int idBitacora);

  // Dashboard queries
  Stream<List<TodaySessionData>> watchTodaySessions();
  Stream<List<TodaySessionData>> watchUpcomingSessions({int days = 7});
  Stream<List<TodaySessionData>> watchAllSessions();
}
