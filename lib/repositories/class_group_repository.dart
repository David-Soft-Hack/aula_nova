import 'package:drift/drift.dart';
import '../database/app_database.dart';
import '../database/daos.dart';
import '../interfaces/repositories/i_class_group_repository.dart';

class ClassGroupRepository implements IClassGroupRepository {
  final ClassGroupDao _dao;

  ClassGroupRepository(this._dao);

  @override
  Future<List<ClassGroup>> getAllGroups() => _dao.getAllGroups();

  @override
  Stream<List<ClassGroup>> watchAllGroups() => _dao.watchAllGroups();

  @override
  Future<ClassGroup?> getGroupByCodigo(String codigo) => _dao.getGroupByCodigo(codigo);

  @override
  Future<List<ClassGroup>> searchGroups(String query) => _dao.searchGroups(query);

  @override
  Future<void> insertGroup(Insertable<ClassGroup> group) => _dao.insertGroup(group);

  @override
  Future<void> updateGroup(Insertable<ClassGroup> group) => _dao.updateGroup(group);

  @override
  Future<void> deleteGroup(Insertable<ClassGroup> group) => _dao.deleteGroup(group);
}
