import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/app_database.dart';
import '../controllers/class_group_controller.dart';
import '../repositories/class_group_repository.dart';
import '../interfaces/controllers/i_class_group_controller.dart';
import 'database_providers.dart';

final classGroupRepositoryProvider = Provider<ClassGroupRepository>((ref) {
  return ClassGroupRepository(ref.watch(classGroupDaoProvider));
});

final classGroupControllerProvider = Provider<IClassGroupController>((ref) {
  return ClassGroupController(
    classGroupRepository: ref.watch(classGroupRepositoryProvider),
  );
});

final allClassGroupsStreamProvider = StreamProvider<List<ClassGroup>>((ref) {
  return ref.watch(classGroupControllerProvider).watchAllGroups();
});
