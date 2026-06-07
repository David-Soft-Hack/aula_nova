import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/career_controller.dart';
import '../database/app_database.dart';
import 'database_providers.dart';

final careerControllerProvider = Provider<CareerController>((ref) {
  return CareerController(
    careerDao: ref.watch(careerDaoProvider),
  );
});

final allCareersStreamProvider = StreamProvider<List<Career>>((ref) {
  return ref.watch(careerControllerProvider).watchAllCareers();
});
