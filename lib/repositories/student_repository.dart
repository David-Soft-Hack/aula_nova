import 'package:drift/drift.dart';
import '../database/app_database.dart';
import '../database/daos.dart';
import '../interfaces/repositories/i_student_repository.dart';

class StudentRepository implements IStudentRepository {
  final StudentDao _dao;

  StudentRepository(this._dao);

  @override
  Future<List<Student>> getAllStudents() => _dao.getAllStudents();

  @override
  Stream<List<Student>> watchAllStudents() => _dao.watchAllStudents();

  @override
  Future<Student?> getStudentById(int id) => _dao.getStudentById(id);

  @override
  Future<Student?> getStudentByCodigo(String codigo) => _dao.getStudentByCodigo(codigo);

  @override
  Future<List<Student>> searchStudents(String query) => _dao.searchStudents(query);

  @override
  Future<List<Student>> getActiveStudentsByGroup(String groupCode) => _dao.getActiveStudentsByGroup(groupCode);

  @override
  Future<void> insertStudent(Insertable<Student> student) => _dao.insertStudent(student);

  @override
  Future<void> updateStudent(Insertable<Student> student) => _dao.updateStudent(student);

  @override
  Future<void> deleteStudent(Insertable<Student> student) => _dao.deleteStudent(student);
}
