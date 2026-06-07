import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/student_controller.dart';
import '../database/app_database.dart';
import 'database_providers.dart';

final studentControllerProvider = Provider<StudentController>((ref) {
  return StudentController(
    studentDao: ref.watch(studentDaoProvider),
    careerDao: ref.watch(careerDaoProvider),
    bitacoraDao: ref.watch(bitacoraDaoProvider),
  );
});

final allStudentsStreamProvider = StreamProvider<List<Student>>((ref) {
  return ref.watch(studentControllerProvider).watchAllStudents();
});
