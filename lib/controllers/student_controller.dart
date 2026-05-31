import 'package:drift/drift.dart';
import '../database/app_database.dart';
import '../database/daos.dart';
import '../database/tables.dart';
import '../models/database_provider.dart';

class StudentController {
  final StudentDao _dao = DatabaseProvider.studentDao;

  Future<List<Student>> getAllStudents() async {
    return await _dao.getAllStudents();
  }

  Stream<List<Student>> watchAllStudents() {
    return _dao.watchAllStudents();
  }

  Future<bool> existsStudentByCodigo(String codigo) async {
    final current = await _dao.getStudentByCodigo(codigo);
    return current != null;
  }

  Future<String> getNextStudentCode(String? carrera, String? grupo) async {
    final year = DateTime.now().year.toString().substring(2);
    final base = <String>[];
    if ((carrera ?? '').trim().isNotEmpty) base.add(carrera!.trim());
    if ((grupo ?? '').trim().isNotEmpty) base.add(grupo!.trim());

    final prefix = base.isEmpty ? '$year' : '${base.join('-')}-$year';

    final existing = await _dao.getAllStudents();
    final matching = existing.where((s) {
      final code = s.codigo.trim();
      return code.startsWith(prefix);
    }).toList();

    int maxSeq = 0;
    for (final student in matching) {
      final code = student.codigo.trim();
      final parts = code.split('-');
      final last = parts.isNotEmpty ? parts.last : '';
      final num = int.tryParse(last) ?? 0;
      if (num > maxSeq) maxSeq = num;
    }

    final nextSeq = maxSeq + 1;
    final padded = nextSeq.toString().padLeft(3, '0');
    return '$prefix-$padded';
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

    await _dao.insertStudent(student);
  }

  Future<void> updateStudent(Student student) async {
    await _dao.updateStudent(student);
  }

  Future<void> deleteStudent(Student student) async {
    await _dao.deleteStudent(student);
  }

  Future<List<Student>> searchStudents(String query) async {
    if (query.trim().isEmpty) {
      return await getAllStudents();
    }
    return await _dao.searchStudents(query);
  }

  Future<List<String>> getAllCareers() async {
    final careers = await DatabaseProvider.careerDao.getAllCareers();
    return careers.map((career) => career.nombre).toList();
  }

  Future<List<String>> getAllGroups() async {
    try {
      final bitacoras = await DatabaseProvider.bitacoraDao.getAllBitacoras();
      final grupos = <String>{};

      for (final bitacora in bitacoras) {
        if (bitacora.codigoGrupo != null && bitacora.codigoGrupo!.isNotEmpty) {
          grupos.add(bitacora.codigoGrupo!);
        }
      }

      return grupos.toList();
    } catch (e) {
      print('Error fetching groups: $e');
      return [];
    }
  }
}
