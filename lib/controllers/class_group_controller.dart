import 'package:drift/drift.dart';
import '../database/app_database.dart';
import '../database/tables.dart';
import '../interfaces/controllers/i_class_group_controller.dart';
import '../interfaces/repositories/i_class_group_repository.dart';

class ClassGroupController implements IClassGroupController {
  final IClassGroupRepository _repository;

  ClassGroupController({required IClassGroupRepository classGroupRepository}) : _repository = classGroupRepository;

  @override
  Future<List<ClassGroup>> getAllGroups() async {
    return await _repository.getAllGroups();
  }

  @override
  Stream<List<ClassGroup>> watchAllGroups() {
    return _repository.watchAllGroups();
  }

  @override
  Future<bool> existsGroupByCodigo(String codigo) async {
    final current = await _repository.getGroupByCodigo(codigo);
    return current != null;
  }

  @override
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
    await _repository.insertGroup(newGroup);
  }

  @override
  Future<void> updateGroup(ClassGroup group) async {
    await _repository.updateGroup(group);
  }

  @override
  Future<void> deleteGroup(ClassGroup group) async {
    await _repository.deleteGroup(group);
  }

  @override
  Future<List<ClassGroup>> searchGroups(String query) async {
    if (query.isEmpty) {
      return await getAllGroups();
    }
    return await _repository.searchGroups(query);
  }
}
