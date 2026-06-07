import 'package:flutter/foundation.dart';
import 'package:drift/drift.dart';
import '../database/app_database.dart';
import '../database/daos.dart';
import '../database/tables.dart';

class StudentController {
  final StudentDao studentDao;
  final CareerDao careerDao;
  final BitacoraDao bitacoraDao;

  StudentController({
    required this.studentDao,
    required this.careerDao,
    required this.bitacoraDao,
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

  Future<List<String>> getAllCareers() async {
    final careers = await careerDao.getAllCareers();
    return careers.map((career) => career.nombre).toList();
  }

  Future<List<String>> getAllGroups() async {
    try {
      final bitacoras = await bitacoraDao.getAllBitacoras();
      final grupos = <String>{};

      for (final bitacora in bitacoras) {
        if (bitacora.codigoGrupo != null && bitacora.codigoGrupo!.isNotEmpty) {
          grupos.add(bitacora.codigoGrupo!);
        }
      }

      return grupos.toList();
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
