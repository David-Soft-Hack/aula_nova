import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/app_database.dart';
import '../controllers/module_controller.dart';
import '../repositories/module_repository.dart';
import '../services/module_factory.dart';
import '../interfaces/controllers/i_module_controller.dart';
import 'database_providers.dart';

final moduleFactoryProvider = Provider<ModuleFactory>((ref) {
  return ModuleFactory(moduleDao: ref.watch(moduleDaoProvider));
});

final moduleRepositoryProvider = Provider<ModuleRepository>((ref) {
  return ModuleRepository(
    ref.watch(moduleDaoProvider),
    ref.watch(unitDaoProvider),
    ref.watch(activityDaoProvider),
  );
});

final moduleControllerProvider = Provider<IModuleController>((ref) {
  return ModuleController(
    db: ref.watch(appDatabaseProvider),
    moduleRepository: ref.watch(moduleRepositoryProvider),
    moduleFactory: ref.watch(moduleFactoryProvider),
    bitacoraDao: ref.watch(bitacoraDaoProvider),
  );
});

final allModulesStreamProvider = StreamProvider<List<Module>>((ref) {
  return ref.watch(moduleDaoProvider).watchAllModules();
});
