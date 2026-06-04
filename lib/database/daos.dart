import 'package:drift/drift.dart';
import '../database/app_database.dart';
import '../database/tables.dart';

part 'daos.g.dart';

@DriftAccessor(tables: [Modules])
class ModuleDao extends DatabaseAccessor<AppDatabase> with _$ModuleDaoMixin {
  ModuleDao(super.db);

  Future<void> _healHours() async {
    try {
      await db.customStatement('''
        UPDATE modules 
        SET total_hora_academic = -(total_hora_academic + total_hora_reloj) 
        WHERE total_hora_academic < total_hora_reloj;
      ''');
      await db.customStatement('''
        UPDATE modules 
        SET total_hora_reloj = -total_hora_academic - total_hora_reloj 
        WHERE total_hora_academic < 0;
      ''');
      await db.customStatement('''
        UPDATE modules 
        SET total_hora_academic = -total_hora_academic - total_hora_reloj 
        WHERE total_hora_academic < 0;
      ''');

      await db.customStatement('''
        UPDATE units 
        SET total_hora_academic = -(total_hora_academic + total_hora_reloj) 
        WHERE total_hora_academic < total_hora_reloj;
      ''');
      await db.customStatement('''
        UPDATE units 
        SET total_hora_reloj = -total_hora_academic - total_hora_reloj 
        WHERE total_hora_academic < 0;
      ''');
      await db.customStatement('''
        UPDATE units 
        SET total_hora_academic = -total_hora_academic - total_hora_reloj 
        WHERE total_hora_academic < 0;
      ''');

      await db.customStatement('''
        UPDATE activities 
        SET total_hora_academic = -(total_hora_academic + total_hora_reloj) 
        WHERE total_hora_academic < total_hora_reloj;
      ''');
      await db.customStatement('''
        UPDATE activities 
        SET total_hora_reloj = -total_hora_academic - total_hora_reloj 
        WHERE total_hora_academic < 0;
      ''');
      await db.customStatement('''
        UPDATE activities 
        SET total_hora_academic = -total_hora_academic - total_hora_reloj 
        WHERE total_hora_academic < 0;
      ''');
    } catch (_) {}
  }

  Future<List<Module>> getAllModules() async {
    await _healHours();
    return select(modules).get();
  }

  Stream<List<Module>> watchAllModules() {
    _healHours();
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
    _healHours();
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
  Future<List<Activity>> getActivitiesByUnit(String idUnit) =>
      (select(activities)..where((t) => t.idUnit.equals(idUnit))).get();
  Future<List<Activity>> getAllActivities() => select(activities).get();
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
    
    // 1. Mark past/today sessions as completed
    await (update(calendarioBitacoras)
          ..where((t) => t.fechaProgramada.isSmallerOrEqualValue(now) & t.estadoImpartido.equals(false)))
        .write(const CalendarioBitacorasCompanion(
      estadoImpartido: Value(true),
    ));

    // 2. Fetch active bitacoras
    final activeBitacoras = await (select(bitacoras)
          ..where((t) => t.estado.equals(EstadoBitacora.activo.index)))
        .get();

    for (final bitacora in activeBitacoras) {
      // Fetch all sessions for this bitacora
      final sessions = await (select(calendarioBitacoras)
            ..where((t) => t.idBitacora.equals(bitacora.id)))
          .get();

      if (sessions.isNotEmpty && sessions.every((s) => s.estadoImpartido)) {
        // If all sessions are completed, finalize the bitacora
        await (update(bitacoras)..where((t) => t.id.equals(bitacora.id)))
            .write(BitacorasCompanion(
          estado: const Value(EstadoBitacora.finalizado),
          fechaFinal: Value(now),
        ));

        // Transition active students in the group to 'finalizado'
        if (bitacora.codigoGrupo != null && bitacora.codigoGrupo!.isNotEmpty) {
          await _updateActiveStudentsForGroup(
            bitacora.codigoGrupo!,
            StudentStatus.finalizado,
          );
        }
      }
    }
  }
  
  Stream<List<BitacoraWithModule>> watchBitacorasWithModule() {
    autoCompletePastSessions();
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
    autoCompletePastSessions();
    return (select(calendarioBitacoras)..where((t) => t.idBitacora.equals(idBitacora))).watch();
  }

  Future<List<CalendarioBitacora>> getCalendarioForBitacora(int idBitacora) => 
      (select(calendarioBitacoras)..where((t) => t.idBitacora.equals(idBitacora))).get();

  Future<void>
  updateCalendarioEntry(Insertable<CalendarioBitacora> entry) =>
      update(calendarioBitacoras).replace(entry);

  Future<int> deleteCalendarioForBitacora(int idBitacora) =>
      (delete(calendarioBitacoras)..where((t) => t.idBitacora.equals(idBitacora))).go();

  // Delete a bitacora and its associated calendar entries
  Future<void> deleteBitacora(int idBitacora) async {
    // 1. Obtain the bitacora to read its group code
    final bitacora = await (select(bitacoras)
          ..where((t) => t.id.equals(idBitacora)))
        .getSingleOrNull();

    if (bitacora != null &&
        bitacora.codigoGrupo != null &&
        bitacora.codigoGrupo!.isNotEmpty) {
      // 2. Determine if the calendar was fully completed
      final sessions = await getCalendarioForBitacora(idBitacora);
      final allCompleted =
          sessions.isNotEmpty && sessions.every((s) => s.estadoImpartido);

      // 3. Transition only ACTIVE students:
      //    - Calendar finished → finalizado
      //    - Calendar not finished → suspendido
      //    - Desertado students are never modified
      final newStatus =
          allCompleted ? StudentStatus.finalizado : StudentStatus.suspendido;
      await _updateActiveStudentsForGroup(bitacora.codigoGrupo!, newStatus);
    }

    // 4. Delete calendar entries then the bitacora
    await deleteCalendarioForBitacora(idBitacora);
    await (delete(bitacoras)..where((t) => t.id.equals(idBitacora))).go();
  }

  /// Transitions only [StudentStatus.activo] students in [grupo] to [newStatus].
  /// Students with any other status (inactivo, graduado, suspendido,
  /// finalizado, desertado) are NOT modified.
  Future<void> _updateActiveStudentsForGroup(
    String grupo,
    StudentStatus newStatus,
  ) async {
    await (db.update(db.students)
          ..where(
            (s) =>
                s.grupo.equals(grupo) &
                s.estado.equals(StudentStatus.activo.index),
          ))
        .write(StudentsCompanion(estado: Value(newStatus)));
  }
  // Update a bitacora record
  Future<void> updateBitacora(Insertable<Bitacora> bitacora) => update(bitacoras).replace(bitacora);

  Stream<List<TodaySessionData>> watchTodaySessions() {
    autoCompletePastSessions();
    final todayStart = DateTime.now();
    final todayEnd = DateTime(todayStart.year, todayStart.month, todayStart.day, 23, 59, 59);

    final query = select(calendarioBitacoras).join([
      innerJoin(bitacoras, bitacoras.id.equalsExp(calendarioBitacoras.idBitacora)),
      innerJoin(modules, modules.codModule.equalsExp(bitacoras.idModule)),
    ])
      ..where(calendarioBitacoras.fechaProgramada.isBetweenValues(todayStart, todayEnd) & calendarioBitacoras.estadoImpartido.equals(false));

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
    autoCompletePastSessions();
    final today = DateTime.now();
    final start = DateTime(today.year, today.month, today.day, 0, 0, 0).add(const Duration(days: 1));
    final end = DateTime(today.year, today.month, today.day, 23, 59, 59).add(Duration(days: days));

    final query = select(calendarioBitacoras).join([
      innerJoin(bitacoras, bitacoras.id.equalsExp(calendarioBitacoras.idBitacora)),
      innerJoin(modules, modules.codModule.equalsExp(bitacoras.idModule)),
    ])
      ..where(calendarioBitacoras.fechaProgramada.isBetweenValues(start, end) & calendarioBitacoras.estadoImpartido.equals(false))
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
