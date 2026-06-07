import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/student_controller.dart';
import '../database/app_database.dart';
import 'database_providers.dart';
import 'career_providers.dart';
import 'class_group_providers.dart';

final studentControllerProvider = Provider<StudentController>((ref) {
  return StudentController(
    studentDao: ref.watch(studentDaoProvider),
    careerController: ref.watch(careerControllerProvider),
    classGroupController: ref.watch(classGroupControllerProvider),
  );
});

final allStudentsStreamProvider = StreamProvider<List<Student>>((ref) {
  return ref.watch(studentControllerProvider).watchAllStudents();
});
