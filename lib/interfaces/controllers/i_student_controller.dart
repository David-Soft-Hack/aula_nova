import '../../database/app_database.dart';
import '../../database/tables.dart';

abstract class IStudentController {
  Future<List<Student>> getAllStudents();
  Stream<List<Student>> watchAllStudents();
  Future<bool> existsStudentByCodigo(String codigo);
  Future<void> addStudent({
    required String codigo,
    required String nombres,
    required String apellidos,
    String? email,
    String? telefono,
    String? carrera,
    String? grupo,
    StudentStatus status = StudentStatus.activo,
    DateTime? fechaIngreso,
  });
  Future<void> updateStudent(Student student);
  Future<void> deleteStudent(Student student);
  Future<List<Student>> searchStudents(String query);
  Future<List<String>> getAllCareers();
  Future<List<String>> getAllGroups();
  Future<String> generateNextStudentCodigo(String grupoCodigo);
}
