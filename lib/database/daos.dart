import 'package:drift/drift.dart';
import '../database/app_database.dart';
import '../database/tables.dart';

part 'daos.g.dart';

@DriftAccessor(tables: [Modules])
class ModuleDao extends DatabaseAccessor<AppDatabase> with _$ModuleDaoMixin {
  ModuleDao(super.db);

  Future<List<Module>> getAllModules() async {
    return select(modules).get();
  }

  Stream<List<Module>> watchAllModules() {
    return select(modules).watch();
  }

  Future insertModule(Insertable<Module> module) => into(modules).insert(module);
  Future updateModule(Insertable<Module> module) => update(modules).replace(module);
  Future deleteModule(Insertable<Module> module) => delete(modules).delete(module);
  Future<Module?> getModuleByCod(String cod) =>
      (select(modules)..where((t) => t.codModule.equals(cod))).getSingleOrNull();

  Future<int> countModulesByCareer(String careerName) async {
    final result = await db.customSelect(
      'SELECT COUNT(*) AS c FROM modules WHERE carrera = ?',
      variables: [Variable.withString(careerName)],
    ).getSingle();
    return result.read<int>('c');
  }

  Stream<List<Module>> watchModulesByCareer(String careerName) {
    return (select(modules)..where((t) => t.carrera.equals(careerName))).watch();
  }
}

@DriftAccessor(tables: [Careers])
class CareerDao extends DatabaseAccessor<AppDatabase> with _$CareerDaoMixin {
  CareerDao(super.db);

  Future<List<Career>> getAllCareers() => select(careers).get();
  Stream<List<Career>> watchAllCareers() => select(careers).watch();
  Future insertCareer(Insertable<Career> career) => into(careers).insert(career);
  Future updateCareer(Insertable<Career> career) => update(careers).replace(career);
  Future deleteCareer(Insertable<Career> career) => delete(careers).delete(career);
}

@DriftAccessor(tables: [ClassGroups])
class ClassGroupDao extends DatabaseAccessor<AppDatabase> with _$ClassGroupDaoMixin {
  ClassGroupDao(super.db);

  Future<List<ClassGroup>> getAllGroups() => select(classGroups).get();
  Stream<List<ClassGroup>> watchAllGroups() => select(classGroups).watch();
  Future insertGroup(Insertable<ClassGroup> group) => into(classGroups).insert(group);
  Future updateGroup(Insertable<ClassGroup> group) => update(classGroups).replace(group);
  Future deleteGroup(Insertable<ClassGroup> group) => delete(classGroups).delete(group);

  Future<ClassGroup?> getGroupByCodigo(String codigo) =>
      (select(classGroups)..where((g) => g.codigo.equals(codigo))).getSingleOrNull();

  Future<List<ClassGroup>> searchGroups(String query) {
    final likeQuery = '%${query.trim()}%';
    return (select(classGroups)
          ..where((g) =>
              g.codigo.like(likeQuery) |
              g.carrera.like(likeQuery)))
        .get();
  }
}

@DriftAccessor(tables: [Students])
class StudentDao extends DatabaseAccessor<AppDatabase> with _$StudentDaoMixin {
  StudentDao(super.db);

  Future<List<Student>> getAllStudents() => select(students).get();
  Stream<List<Student>> watchAllStudents() => select(students).watch();

  Future<Student?> getStudentById(int id) =>
      (select(students)..where((s) => s.id.equals(id))).getSingleOrNull();

  Future<Student?> getStudentByCodigo(String codigo) =>
      (select(students)..where((s) => s.codigo.equals(codigo))).getSingleOrNull();

  Future<List<Student>> searchStudents(String query) {
    final likeQuery = '%${query.trim()}%';
    return (select(students)
          ..where((s) =>
              s.nombres.like(likeQuery) |
              s.apellidos.like(likeQuery) |
              s.codigo.like(likeQuery) |
              s.carrera.like(likeQuery)))
        .get();
  }

  Future<List<Student>> getActiveStudentsByGroup(String groupCode) {
    final normalized = groupCode.trim().toLowerCase();
    return (select(students)
          ..where((s) =>
              s.grupo.lower().equals(normalized) &
              s.estado.equals(StudentStatus.activo.index)))
        .get();
  }

  /// Stream reactivo: emite una nueva lista cada vez que cambia un estudiante del grupo.
  /// Esto permite que TakeAttendanceScreen detecte automáticamente nuevos estudiantes.
  Stream<List<Student>> watchActiveStudentsByGroup(String groupCode) {
    final normalized = groupCode.trim().toLowerCase();
    return (select(students)
          ..where((s) =>
              s.grupo.lower().equals(normalized) &
              s.estado.equals(StudentStatus.activo.index)))
        .watch();
  }

  Future insertStudent(Insertable<Student> student) => into(students).insert(student);
  Future updateStudent(Insertable<Student> student) => update(students).replace(student);
  Future deleteStudent(Insertable<Student> student) => delete(students).delete(student);
}

@DriftAccessor(tables: [Units])
class UnitDao extends DatabaseAccessor<AppDatabase> with _$UnitDaoMixin {
  UnitDao(super.db);

  Future<List<Unit>> getUnitsByModule(String idModule) =>
      (select(units)..where((t) => t.idModule.equals(idModule))).get();
  Future<List<Unit>> getAllUnits() => select(units).get();
  Future<Unit?> getUnitByCod(String codUnit) =>
      (select(units)..where((t) => t.codUnit.equals(codUnit))).getSingleOrNull();
  Stream<Unit?> watchUnitByCod(String codUnit) =>
      (select(units)..where((t) => t.codUnit.equals(codUnit))).watchSingleOrNull();
  Future insertUnit(Insertable<Unit> unit) => into(units).insert(unit);
  Future updateUnit(Insertable<Unit> unit) => update(units).replace(unit);
  Future deleteUnit(Insertable<Unit> unit) => delete(units).delete(unit);
  Future deleteUnitsByModule(String idModule) =>
      (delete(units)..where((t) => t.idModule.equals(idModule))).go();
}

@DriftAccessor(tables: [Activities])
class ActivityDao extends DatabaseAccessor<AppDatabase> with _$ActivityDaoMixin {
  ActivityDao(super.db);

  Future insertActivity(Insertable<Activity> activity) => into(activities).insert(activity);
  Future updateActivity(Insertable<Activity> activity) => update(activities).replace(activity);
  Future deleteActivity(Insertable<Activity> activity) => delete(activities).delete(activity);
  Future<void> deleteActivityByCode(String codActivity) =>
      (delete(activities)..where((t) => t.codActivity.equals(codActivity))).go();
  Future<List<Activity>> getActivitiesByUnit(String idUnit) =>
      (select(activities)..where((t) => t.idUnit.equals(idUnit))).get();
  Future<List<Activity>> getAllActivities() => select(activities).get();
  Future<Activity?> getActivityByCod(String codActivity) =>
      (select(activities)..where((t) => t.codActivity.equals(codActivity))).getSingleOrNull();
  Stream<Activity?> watchActivityByCod(String codActivity) =>
      (select(activities)..where((t) => t.codActivity.equals(codActivity))).watchSingleOrNull();
  Future deleteActivitiesByUnit(String idUnit) =>
      (delete(activities)..where((t) => t.idUnit.equals(idUnit))).go();
}

@DriftAccessor(tables: [Bitacoras, CalendarioBitacoras])
class BitacoraDao extends DatabaseAccessor<AppDatabase> with _$BitacoraDaoMixin {
  BitacoraDao(super.db);

  Future<int> createBitacora(Insertable<Bitacora> bitacora) => into(bitacoras).insert(bitacora);

  Future<List<Bitacora>> getAllBitacoras() => select(bitacoras).get();

  Future<void> autoCompletePastSessions() async {
    final now = DateTime.now();

    await (update(calendarioBitacoras)
          ..where((t) => t.fechaProgramada.isSmallerOrEqualValue(now) & t.estadoImpartido.equals(false)))
        .write(const CalendarioBitacorasCompanion(
      estadoImpartido: Value(true),
    ));

    final activeBitacoras = await (select(bitacoras)
          ..where((t) => t.estado.equals(EstadoBitacora.activo.index)))
        .get();

    for (final bitacora in activeBitacoras) {
      final sessions = await (select(calendarioBitacoras)
            ..where((t) => t.idBitacora.equals(bitacora.id)))
          .get();

      if (sessions.isNotEmpty && sessions.every((s) => s.estadoImpartido)) {
        await (update(bitacoras)..where((t) => t.id.equals(bitacora.id)))
            .write(BitacorasCompanion(
          estado: const Value(EstadoBitacora.finalizado),
          fechaFinal: Value(now),
        ));
      }
    }
  }

  Stream<List<BitacoraWithModule>> watchBitacorasWithModule() {
    final query = select(bitacoras).join([
      innerJoin(modules, modules.codModule.equalsExp(bitacoras.idModule)),
    ]);

    return query.watch().map((rows) {
      return rows.map((row) {
        return BitacoraWithModule(
          bitacora: row.readTable(bitacoras),
          module: row.readTable(modules),
        );
      }).toList();
    });
  }

  // Calendar entries methods
  Future<void> createCalendarioEntries(List<CalendarioBitacorasCompanion> entries) =>
      batch((batch) => batch.insertAll(calendarioBitacoras, entries));

  Stream<List<CalendarioBitacora>> watchCalendarioForBitacora(int idBitacora) {
    return (select(calendarioBitacoras)..where((t) => t.idBitacora.equals(idBitacora))).watch();
  }

  Future<List<CalendarioBitacora>> getCalendarioForBitacora(int idBitacora) =>
      (select(calendarioBitacoras)..where((t) => t.idBitacora.equals(idBitacora))).get();

  Future<void> updateCalendarioEntry(Insertable<CalendarioBitacora> entry) =>
      update(calendarioBitacoras).replace(entry);

  Future<int> deleteCalendarioForBitacora(int idBitacora) =>
      (delete(calendarioBitacoras)..where((t) => t.idBitacora.equals(idBitacora))).go();

  Future<void> deleteBitacora(int idBitacora) async {
    await db.transaction(() async {
      await deleteCalendarioForBitacora(idBitacora);
      await (delete(bitacoras)..where((t) => t.id.equals(idBitacora))).go();
    });
  }

  // Update a bitacora record
  Future<void> updateBitacora(Insertable<Bitacora> bitacora) => update(bitacoras).replace(bitacora);

  Future<List<Bitacora>> getBitacorasByModule(String moduleCode) =>
      (select(bitacoras)..where((t) => t.idModule.equals(moduleCode))).get();

  Future<void> deleteBitacorasByModule(String moduleCode) =>
      (delete(bitacoras)..where((t) => t.idModule.equals(moduleCode))).go();

  Stream<List<TodaySessionData>> watchTodaySessions() {
    final todayStart = DateTime.now();
    final todayEnd = DateTime(todayStart.year, todayStart.month, todayStart.day, 23, 59, 59);

    final query = select(calendarioBitacoras).join([
      innerJoin(bitacoras, bitacoras.id.equalsExp(calendarioBitacoras.idBitacora)),
      innerJoin(modules, modules.codModule.equalsExp(bitacoras.idModule)),
    ])
      ..where(calendarioBitacoras.fechaProgramada.isBetweenValues(todayStart, todayEnd) &
          calendarioBitacoras.estadoImpartido.equals(false) &
          bitacoras.estado.equals(EstadoBitacora.activo.index));

    return query.watch().map((rows) {
      return rows.map((row) {
        final bitacora = row.readTable(bitacoras);
        return TodaySessionData(
          entry: row.readTable(calendarioBitacoras),
          moduleName: row.readTable(modules).nombre,
          groupCode: bitacora.codigoGrupo,
          career: bitacora.carrera,
          turno: bitacora.turno,
        );
      }).toList();
    });
  }

  Stream<List<TodaySessionData>> watchUpcomingSessions({int days = 7}) {
    final today = DateTime.now();
    final start = DateTime(today.year, today.month, today.day, 0, 0, 0).add(const Duration(days: 1));
    final end = DateTime(today.year, today.month, today.day, 23, 59, 59).add(Duration(days: days));

    final query = select(calendarioBitacoras).join([
      innerJoin(bitacoras, bitacoras.id.equalsExp(calendarioBitacoras.idBitacora)),
      innerJoin(modules, modules.codModule.equalsExp(bitacoras.idModule)),
    ])
      ..where(calendarioBitacoras.fechaProgramada.isBetweenValues(start, end) &
          calendarioBitacoras.estadoImpartido.equals(false) &
          bitacoras.estado.equals(EstadoBitacora.activo.index))
      ..orderBy([OrderingTerm(expression: calendarioBitacoras.fechaProgramada, mode: OrderingMode.asc)]);

    return query.watch().map((rows) {
      return rows.map((row) {
        final bitacora = row.readTable(bitacoras);
        return TodaySessionData(
          entry: row.readTable(calendarioBitacoras),
          moduleName: row.readTable(modules).nombre,
          groupCode: bitacora.codigoGrupo,
          career: bitacora.carrera,
          turno: bitacora.turno,
        );
      }).toList();
    });
  }

  Stream<List<TodaySessionData>> watchAllSessions() {
    final query = select(calendarioBitacoras).join([
      innerJoin(bitacoras, bitacoras.id.equalsExp(calendarioBitacoras.idBitacora)),
      innerJoin(modules, modules.codModule.equalsExp(bitacoras.idModule)),
    ])
      ..where(bitacoras.estado.equals(EstadoBitacora.activo.index))
      ..orderBy([OrderingTerm(expression: calendarioBitacoras.fechaProgramada, mode: OrderingMode.asc)]);

    return query.watch().map((rows) {
      return rows.map((row) {
        final bitacora = row.readTable(bitacoras);
        return TodaySessionData(
          entry: row.readTable(calendarioBitacoras),
          moduleName: row.readTable(modules).nombre,
          groupCode: bitacora.codigoGrupo,
          career: bitacora.carrera,
          turno: bitacora.turno,
        );
      }).toList();
    });
  }
}

class BitacoraWithModule {
  final Bitacora bitacora;
  final Module module;
  BitacoraWithModule({required this.bitacora, required this.module});
}

class TodaySessionData {
  final CalendarioBitacora entry;
  final String moduleName;
  final String? groupCode;
  final String career;
  final String? turno;

  TodaySessionData({
    required this.entry,
    required this.moduleName,
    required this.groupCode,
    required this.career,
    required this.turno,
  });
}

@DriftAccessor(tables: [Attendances])
class AttendanceDao extends DatabaseAccessor<AppDatabase> with _$AttendanceDaoMixin {
  AttendanceDao(super.db);

  Future<List<Attendance>> getAttendancesBySession(int sessionId) {
    return (select(attendances)..where((t) => t.idSession.equals(sessionId))).get();
  }

  Future<void> saveAttendances(List<AttendancesCompanion> records) async {
    await batch((batch) {
      for (final record in records) {
        batch.insert(attendances, record, mode: InsertMode.insertOrReplace);
      }
    });
  }

  Future<void> upsertAttendance(AttendancesCompanion record) {
    return into(attendances).insertOnConflictUpdate(record);
  }

  Future<void> updateAttendanceJustification({
    required int sessionId,
    required int studentId,
    required String? detalle,
    required List<String>? rutas,
  }) async {
    final existing = await (select(attendances)
          ..where((t) => t.idSession.equals(sessionId) & t.idStudent.equals(studentId)))
        .getSingleOrNull();

    if (existing != null) {
      await (update(attendances)
            ..where((t) => t.idSession.equals(sessionId) & t.idStudent.equals(studentId)))
          .write(AttendancesCompanion(
            estado: const Value(EstadoAsistencia.justificado),
            justificacionDetalle: Value(detalle),
            rutasEvidencia: Value(rutas),
            fechaJustificacion: Value(DateTime.now()),
          ));
    } else {
      await into(attendances).insert(AttendancesCompanion.insert(
        idSession: sessionId,
        idStudent: studentId,
        estado: EstadoAsistencia.justificado,
        justificacionDetalle: Value(detalle),
        rutasEvidencia: Value(rutas),
        fechaJustificacion: Value(DateTime.now()),
      ));
    }
  }

  Future<void> markSessionAsImparted(int sessionId) async {
    await (db.update(db.calendarioBitacoras)..where((t) => t.id.equals(sessionId)))
        .write(const CalendarioBitacorasCompanion(estadoImpartido: Value(true)));
  }
}
