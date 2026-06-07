import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/module_controller.dart';
import '../database/app_database.dart';
import 'database_providers.dart';

final moduleControllerProvider = Provider<ModuleController>((ref) {
  return ModuleController(
    db: ref.watch(appDatabaseProvider),
    moduleDao: ref.watch(moduleDaoProvider),
    unitDao: ref.watch(unitDaoProvider),
    activityDao: ref.watch(activityDaoProvider),
    bitacoraDao: ref.watch(bitacoraDaoProvider),
  );
});

final allModulesStreamProvider = StreamProvider<List<Module>>((ref) {
  return ref.watch(moduleDaoProvider).watchAllModules();
});
