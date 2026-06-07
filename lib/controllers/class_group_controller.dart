import 'package:drift/drift.dart';
import '../database/app_database.dart';
import '../database/daos.dart';
import '../database/tables.dart';

class ClassGroupController {
  final ClassGroupDao classGroupDao;

  ClassGroupController({required this.classGroupDao});

  Future<List<ClassGroup>> getAllGroups() async {
    return await classGroupDao.getAllGroups();
  }

  Stream<List<ClassGroup>> watchAllGroups() {
    return classGroupDao.watchAllGroups();
  }

  Future<bool> existsGroupByCodigo(String codigo) async {
    final current = await classGroupDao.getGroupByCodigo(codigo);
    return current != null;
  }

  Future<void> addGroup({
    required String codigo,
    required String carrera,
    String? turno,
    String? ciclo,
    EstadoGrupo estado = EstadoGrupo.activo,
    DateTime? fechaInicio,
    DateTime? fechaFin,
  }) async {
    final newGroup = ClassGroupsCompanion(
      codigo: Value(codigo),
      carrera: Value(carrera),
      turno: Value(turno),
      ciclo: Value(ciclo),
      estado: Value(estado),
      fechaInicio: Value(fechaInicio),
      fechaFin: Value(fechaFin),
      fechaCreacion: Value(DateTime.now()),
    );
    await classGroupDao.insertGroup(newGroup);
  }

  Future<void> updateGroup(ClassGroup group) async {
    await classGroupDao.updateGroup(group);
  }

  Future<void> deleteGroup(ClassGroup group) async {
    await classGroupDao.deleteGroup(group);
  }

  Future<List<ClassGroup>> searchGroups(String query) async {
    if (query.isEmpty) {
      return await getAllGroups();
    }
    return await classGroupDao.searchGroups(query);
  }
}
