import 'package:flutter/foundation.dart';
import 'package:drift/drift.dart';
import '../database/app_database.dart';
import '../database/tables.dart';
import '../interfaces/controllers/i_student_controller.dart';
import '../interfaces/controllers/i_career_controller.dart';
import '../interfaces/controllers/i_class_group_controller.dart';
import '../interfaces/repositories/i_student_repository.dart';

class StudentController implements IStudentController {
  final IStudentRepository _repository;
  final ICareerController _careerController;
  final IClassGroupController _classGroupController;

  StudentController({
    required IStudentRepository studentRepository,
    required ICareerController careerController,
    required IClassGroupController classGroupController,
  })  : _repository = studentRepository,
        _careerController = careerController,
        _classGroupController = classGroupController;

  @override
  Future<List<Student>> getAllStudents() async {
    return await _repository.getAllStudents();
  }

  @override
  Stream<List<Student>> watchAllStudents() {
    return _repository.watchAllStudents();
  }

  @override
  Future<bool> existsStudentByCodigo(String codigo) async {
    final current = await _repository.getStudentByCodigo(codigo);
    return current != null;
  }

  @override
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
  }) async {
    final student = StudentsCompanion(
      codigo: Value(codigo.trim()),
      nombres: Value(nombres.trim()),
      apellidos: Value(apellidos.trim()),
      email: Value(email?.trim()),
      telefono: Value(telefono?.trim()),
      carrera: Value(carrera?.trim()),
      grupo: Value(grupo?.trim()),
      estado: Value(status),
      fechaIngreso: Value(fechaIngreso),
      fechaCreacion: Value(DateTime.now()),
    );

    await _repository.insertStudent(student);
  }

  @override
  Future<void> updateStudent(Student student) async {
    await _repository.updateStudent(student);
  }

  @override
  Future<void> deleteStudent(Student student) async {
    await _repository.deleteStudent(student);
  }

  @override
  Future<List<Student>> searchStudents(String query) async {
    if (query.trim().isEmpty) {
      return await getAllStudents();
    }
    return await _repository.searchStudents(query);
  }

  @override
  Future<List<String>> getAllCareers() =>
      _careerController.getAllCareerNames();

  @override
  Future<List<String>> getAllGroups() async {
    try {
      final groups = await _classGroupController.getAllGroups();
      return groups.map((g) => g.codigo).toList();
    } catch (e) {
      debugPrint('Error fetching groups: $e');
      return [];
    }
  }

  @override
  Future<String> generateNextStudentCodigo(String grupoCodigo) async {
    try {
      final all = await getAllStudents();
      final groupStudents = all
          .where(
            (s) =>
                s.grupo?.trim().toLowerCase() ==
                grupoCodigo.trim().toLowerCase(),
          )
          .toList();

      int maxNum = 0;
      final prefix = '${grupoCodigo.trim()}-';

      for (final s in groupStudents) {
        if (s.codigo.toLowerCase().startsWith(prefix.toLowerCase())) {
          final numStr = s.codigo.substring(prefix.length);
          final num = int.tryParse(numStr);
          if (num != null && num > maxNum) {
            maxNum = num;
          }
        }
      }

      final nextNum = maxNum + 1;
      final suffix = nextNum.toString().padLeft(2, '0');
      return '${grupoCodigo.trim()}-$suffix';
    } catch (e) {
      debugPrint('Error generating next student code: $e');
      return '${grupoCodigo.trim()}-01';
    }
  }
}
