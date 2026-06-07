import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/class_group_controller.dart';
import '../database/app_database.dart';
import 'database_providers.dart';

final classGroupControllerProvider = Provider<ClassGroupController>((ref) {
  return ClassGroupController(
    classGroupDao: ref.watch(classGroupDaoProvider),
  );
});

final allClassGroupsStreamProvider = StreamProvider<List<ClassGroup>>((ref) {
  return ref.watch(classGroupControllerProvider).watchAllGroups();
});
