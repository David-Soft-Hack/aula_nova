import '../../database/app_database.dart';
import '../../database/tables.dart';

abstract class IClassGroupController {
  Future<List<ClassGroup>> getAllGroups();
  Stream<List<ClassGroup>> watchAllGroups();
  Future<bool> existsGroupByCodigo(String codigo);
  Future<void> addGroup({
    required String codigo,
    required String carrera,
    String? turno,
    String? ciclo,
    EstadoGrupo estado = EstadoGrupo.activo,
    DateTime? fechaInicio,
    DateTime? fechaFin,
  });
  Future<void> updateGroup(ClassGroup group);
  Future<void> deleteGroup(ClassGroup group);
  Future<List<ClassGroup>> searchGroups(String query);
}
