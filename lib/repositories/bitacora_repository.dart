import 'package:drift/drift.dart';
import '../database/app_database.dart';
import '../database/daos.dart';
import '../interfaces/repositories/i_bitacora_repository.dart';

class BitacoraRepository implements IBitacoraRepository {
  final BitacoraDao _dao;

  BitacoraRepository(this._dao);

  @override
  Future<int> createBitacora(Insertable<Bitacora> bitacora) => _dao.createBitacora(bitacora);

  @override
  Future<List<Bitacora>> getAllBitacoras() => _dao.getAllBitacoras();

  @override
  Future<void> updateBitacora(Insertable<Bitacora> bitacora) => _dao.updateBitacora(bitacora);

  @override
  Future<void> autoCompletePastSessions() => _dao.autoCompletePastSessions();

  @override
  Stream<List<BitacoraWithModule>> watchBitacorasWithModule() => _dao.watchBitacorasWithModule();

  @override
  Future<List<Bitacora>> getBitacorasByModule(String moduleCode) => _dao.getBitacorasByModule(moduleCode);

  @override
  Future<void> deleteBitacorasByModule(String moduleCode) => _dao.deleteBitacorasByModule(moduleCode);

  @override
  Future<void> createCalendarioEntries(List<CalendarioBitacorasCompanion> entries) => _dao.createCalendarioEntries(entries);

  @override
  Stream<List<CalendarioBitacora>> watchCalendarioForBitacora(int idBitacora) => _dao.watchCalendarioForBitacora(idBitacora);

  @override
  Future<List<CalendarioBitacora>> getCalendarioForBitacora(int idBitacora) => _dao.getCalendarioForBitacora(idBitacora);

  @override
  Future<void> updateCalendarioEntry(Insertable<CalendarioBitacora> entry) => _dao.updateCalendarioEntry(entry);

  @override
  Future<void> deleteCalendarioForBitacora(int idBitacora) => _dao.deleteCalendarioForBitacora(idBitacora);

  @override
  Future<void> deleteBitacora(int idBitacora) => _dao.deleteBitacora(idBitacora);

  @override
  Stream<List<TodaySessionData>> watchTodaySessions() => _dao.watchTodaySessions();

  @override
  Stream<List<TodaySessionData>> watchUpcomingSessions({int days = 7}) => _dao.watchUpcomingSessions(days: days);
}
