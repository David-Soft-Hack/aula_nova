import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/app_database.dart';
import '../controllers/career_controller.dart';
import '../repositories/career_repository.dart';
import '../interfaces/controllers/i_career_controller.dart';
import 'database_providers.dart';

final careerRepositoryProvider = Provider<CareerRepository>((ref) {
  return CareerRepository(ref.watch(careerDaoProvider));
});

final careerControllerProvider = Provider<ICareerController>((ref) {
  return CareerController(
    careerRepository: ref.watch(careerRepositoryProvider),
  );
});

final allCareersStreamProvider = StreamProvider<List<Career>>((ref) {
  return ref.watch(careerControllerProvider).watchAllCareers();
});
