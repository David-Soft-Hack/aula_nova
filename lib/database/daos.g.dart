// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daos.dart';

// ignore_for_file: type=lint
mixin _$ModuleDaoMixin on DatabaseAccessor<AppDatabase> {
  $ModulesTable get modules => attachedDatabase.modules;
  ModuleDaoManager get managers => ModuleDaoManager(this);
}

class ModuleDaoManager {
  final _$ModuleDaoMixin _db;
  ModuleDaoManager(this._db);
  $$ModulesTableTableManager get modules =>
      $$ModulesTableTableManager(_db.attachedDatabase, _db.modules);
}

mixin _$CareerDaoMixin on DatabaseAccessor<AppDatabase> {
  $CareersTable get careers => attachedDatabase.careers;
  CareerDaoManager get managers => CareerDaoManager(this);
}

class CareerDaoManager {
  final _$CareerDaoMixin _db;
  CareerDaoManager(this._db);
  $$CareersTableTableManager get careers =>
      $$CareersTableTableManager(_db.attachedDatabase, _db.careers);
}

mixin _$StudentDaoMixin on DatabaseAccessor<AppDatabase> {
  $StudentsTable get students => attachedDatabase.students;
  StudentDaoManager get managers => StudentDaoManager(this);
}

class StudentDaoManager {
  final _$StudentDaoMixin _db;
  StudentDaoManager(this._db);
  $$StudentsTableTableManager get students =>
      $$StudentsTableTableManager(_db.attachedDatabase, _db.students);
}

mixin _$UnitDaoMixin on DatabaseAccessor<AppDatabase> {
  $ModulesTable get modules => attachedDatabase.modules;
  $UnitsTable get units => attachedDatabase.units;
  UnitDaoManager get managers => UnitDaoManager(this);
}

class UnitDaoManager {
  final _$UnitDaoMixin _db;
  UnitDaoManager(this._db);
  $$ModulesTableTableManager get modules =>
      $$ModulesTableTableManager(_db.attachedDatabase, _db.modules);
  $$UnitsTableTableManager get units =>
      $$UnitsTableTableManager(_db.attachedDatabase, _db.units);
}

mixin _$ActivityDaoMixin on DatabaseAccessor<AppDatabase> {
  $ModulesTable get modules => attachedDatabase.modules;
  $UnitsTable get units => attachedDatabase.units;
  $ActivitiesTable get activities => attachedDatabase.activities;
  ActivityDaoManager get managers => ActivityDaoManager(this);
}

class ActivityDaoManager {
  final _$ActivityDaoMixin _db;
  ActivityDaoManager(this._db);
  $$ModulesTableTableManager get modules =>
      $$ModulesTableTableManager(_db.attachedDatabase, _db.modules);
  $$UnitsTableTableManager get units =>
      $$UnitsTableTableManager(_db.attachedDatabase, _db.units);
  $$ActivitiesTableTableManager get activities =>
      $$ActivitiesTableTableManager(_db.attachedDatabase, _db.activities);
}

mixin _$BitacoraDaoMixin on DatabaseAccessor<AppDatabase> {
  $ModulesTable get modules => attachedDatabase.modules;
  $BitacorasTable get bitacoras => attachedDatabase.bitacoras;
  $CalendarioBitacorasTable get calendarioBitacoras =>
      attachedDatabase.calendarioBitacoras;
  BitacoraDaoManager get managers => BitacoraDaoManager(this);
}

class BitacoraDaoManager {
  final _$BitacoraDaoMixin _db;
  BitacoraDaoManager(this._db);
  $$ModulesTableTableManager get modules =>
      $$ModulesTableTableManager(_db.attachedDatabase, _db.modules);
  $$BitacorasTableTableManager get bitacoras =>
      $$BitacorasTableTableManager(_db.attachedDatabase, _db.bitacoras);
  $$CalendarioBitacorasTableTableManager get calendarioBitacoras =>
      $$CalendarioBitacorasTableTableManager(
        _db.attachedDatabase,
        _db.calendarioBitacoras,
      );
}
