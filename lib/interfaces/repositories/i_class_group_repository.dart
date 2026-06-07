import 'package:drift/drift.dart';
import '../../database/app_database.dart';

abstract class IClassGroupRepository {
  Future<List<ClassGroup>> getAllGroups();
  Stream<List<ClassGroup>> watchAllGroups();
  Future<ClassGroup?> getGroupByCodigo(String codigo);
  Future<List<ClassGroup>> searchGroups(String query);
  Future<void> insertGroup(Insertable<ClassGroup> group);
  Future<void> updateGroup(Insertable<ClassGroup> group);
  Future<void> deleteGroup(Insertable<ClassGroup> group);
}
