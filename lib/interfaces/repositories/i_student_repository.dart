import 'package:drift/drift.dart';
import '../../database/app_database.dart';

abstract class IStudentRepository {
  Future<List<Student>> getAllStudents();
  Stream<List<Student>> watchAllStudents();
  Future<Student?> getStudentById(int id);
  Future<Student?> getStudentByCodigo(String codigo);
  Future<List<Student>> searchStudents(String query);
  Future<List<Student>> getActiveStudentsByGroup(String groupCode);
  Stream<List<Student>> watchActiveStudentsByGroup(String groupCode);
  Future<void> insertStudent(Insertable<Student> student);
  Future<void> updateStudent(Insertable<Student> student);
  Future<void> deleteStudent(Insertable<Student> student);
}
