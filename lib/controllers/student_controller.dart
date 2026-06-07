import 'package:flutter/foundation.dart';
import 'package:drift/drift.dart';
import '../database/app_database.dart';
import '../database/daos.dart';
import '../database/tables.dart';
import 'career_controller.dart';
import 'class_group_controller.dart';

class StudentController {
  final StudentDao studentDao;
  final CareerController careerController;
  final ClassGroupController classGroupController;

  StudentController({
    required this.studentDao,
    required this.careerController,
    required this.classGroupController,
  });

  Future<List<Student>> getAllStudents() async {
    return await studentDao.getAllStudents();
  }

  Stream<List<Student>> watchAllStudents() {
    return studentDao.watchAllStudents();
  }

  Future<bool> existsStudentByCodigo(String codigo) async {
    final current = await studentDao.getStudentByCodigo(codigo);
    return current != null;
  }

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

    await studentDao.insertStudent(student);
  }

  Future<void> updateStudent(Student student) async {
    await studentDao.updateStudent(student);
  }

  Future<void> deleteStudent(Student student) async {
    await studentDao.deleteStudent(student);
  }

  Future<List<Student>> searchStudents(String query) async {
    if (query.trim().isEmpty) {
      return await getAllStudents();
    }
    return await studentDao.searchStudents(query);
  }

  Future<List<String>> getAllCareers() =>
      careerController.getAllCareerNames();

  Future<List<String>> getAllGroups() async {
    try {
      final groups = await classGroupController.getAllGroups();
      return groups.map((g) => g.codigo).toList();
    } catch (e) {
      debugPrint('Error fetching groups: $e');
      return [];
    }
  }

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
