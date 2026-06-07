import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/app_database.dart';
import '../database/daos.dart';
import '../services/student_status_service.dart';
import '../services/dosificacion_service.dart';
import '../repositories/bitacora_repository.dart';
import '../repositories/module_repository.dart';
import '../controllers/bitacora_controller.dart';
import '../interfaces/controllers/i_bitacora_controller.dart';
import 'database_providers.dart';

final dosificacionServiceProvider = Provider<DosificacionService>((ref) => DosificacionService());

final studentStatusServiceProvider = Provider<StudentStatusService>((ref) {
  return StudentStatusService(
    db: ref.watch(appDatabaseProvider),
    studentDao: ref.watch(studentDaoProvider),
  );
});

final bitacoraRepositoryProvider = Provider<BitacoraRepository>((ref) {
  return BitacoraRepository(ref.watch(bitacoraDaoProvider));
});

final moduleRepositoryForBitacoraProvider = Provider<ModuleRepository>((ref) {
  return ModuleRepository(
    ref.watch(moduleDaoProvider),
    ref.watch(unitDaoProvider),
    ref.watch(activityDaoProvider),
  );
});

final bitacoraControllerProvider = Provider<IBitacoraController>((ref) {
  return BitacoraController(
    db: ref.watch(appDatabaseProvider),
    bitacoraRepository: ref.watch(bitacoraRepositoryProvider),
    moduleRepository: ref.watch(moduleRepositoryForBitacoraProvider),
    studentStatusService: ref.watch(studentStatusServiceProvider),
    dosificacionService: ref.watch(dosificacionServiceProvider),
  );
});

final bitacorasWithModuleStreamProvider = StreamProvider<List<BitacoraWithModule>>((ref) {
  return ref.watch(bitacoraControllerProvider).watchBitacorasWithModule();
});

final calendarioStreamProvider = StreamProvider.family<List<CalendarioBitacora>, int>((ref, idBitacora) {
  return ref.watch(bitacoraControllerProvider).watchCalendario(idBitacora);
});

final unitByCodProvider = StreamProvider.family<Unit?, String>((ref, codUnit) {
  if (codUnit.isEmpty) return const Stream.empty();
  return ref.watch(moduleRepositoryForBitacoraProvider).watchUnitByCod(codUnit);
});

final activityByCodProvider = StreamProvider.family<Activity?, String>((ref, codActivity) {
  if (codActivity.isEmpty) return const Stream.empty();
  return ref.watch(moduleRepositoryForBitacoraProvider).watchActivityByCod(codActivity);
});
