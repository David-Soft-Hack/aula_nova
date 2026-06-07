import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/bitacora_controller.dart';
import '../database/app_database.dart';
import '../database/daos.dart';
import 'database_providers.dart';

final bitacoraControllerProvider = Provider<BitacoraController>((ref) {
  return BitacoraController(
    db: ref.watch(appDatabaseProvider),
    bitacoraDao: ref.watch(bitacoraDaoProvider),
    moduleDao: ref.watch(moduleDaoProvider),
    careerDao: ref.watch(careerDaoProvider),
    unitDao: ref.watch(unitDaoProvider),
    activityDao: ref.watch(activityDaoProvider),
  );
});

final bitacorasWithModuleStreamProvider = StreamProvider<List<BitacoraWithModule>>((ref) {
  return ref.watch(bitacoraControllerProvider).watchBitacorasWithModule();
});

final calendarioStreamProvider = StreamProvider.family<List<CalendarioBitacora>, int>((ref, idBitacora) {
  return ref.watch(bitacoraControllerProvider).watchCalendario(idBitacora);
});
