import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/app_database.dart';
import '../controllers/student_controller.dart';
import '../repositories/student_repository.dart';
import '../interfaces/controllers/i_student_controller.dart';
import 'database_providers.dart';
import 'career_providers.dart';
import 'class_group_providers.dart';

final studentRepositoryProvider = Provider<StudentRepository>((ref) {
  return StudentRepository(ref.watch(studentDaoProvider));
});

final studentControllerProvider = Provider<IStudentController>((ref) {
  return StudentController(
    studentRepository: ref.watch(studentRepositoryProvider),
    careerController: ref.watch(careerControllerProvider),
    classGroupController: ref.watch(classGroupControllerProvider),
  );
});

final allStudentsStreamProvider = StreamProvider<List<Student>>((ref) {
  return ref.watch(studentControllerProvider).watchAllStudents();
});
