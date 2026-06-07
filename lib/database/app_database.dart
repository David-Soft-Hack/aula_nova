import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../services/student_status_service.dart';
import 'tables.dart';
import 'daos.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Careers,
    ClassGroups,
    Modules,
    Units,
    Activities,
    Bitacoras,
    CalendarioBitacoras,
    Students,
    Attendances,
  ],
  daos: [
    CareerDao,
    ClassGroupDao,
    ModuleDao,
    UnitDao,
    ActivityDao,
    BitacoraDao,
    StudentDao,
    AttendanceDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 10;
  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
    },
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.drop(calendarioBitacoras);
        await m.create(calendarioBitacoras);
      }
      if (from < 3) {
        await m.addColumn(bitacoras, bitacoras.usarHorasReloj);
      }
      if (from < 4) {
        await _addCalendarioEvalColumnsIfMissing(m);
      }
      if (from < 5) {
        await m.create(students);
      }
      // v6: StudentStatus gained suspendido/finalizado/desertado.
      // Stored as INTEGER, no DDL changes required.
      if (from < 6) {}
      if (from < 8) {
        await m.create(classGroups);
      }
      if (from < 9) {
        await m.create(attendances);
      }
      if (from < 10) {
        await m.addColumn(attendances, attendances.justificacionDetalle);
        await m.addColumn(attendances, attendances.rutasEvidencia);
        await m.addColumn(attendances, attendances.fechaJustificacion);
      }
    },
    beforeOpen: (details) async {
      await _selfHealHourSwaps();
      await bitacoraDao.autoCompletePastSessions();
      final statusService = StudentStatusService(db: this, studentDao: studentDao);
      await _finalizeStudentsForCompletedBitacoras(statusService);
    },
  );

  /// Adds evaluation columns only when absent (e.g. after v2 recreates the
  /// table with the current schema, or after a partial failed migration).
  Future<void> _addCalendarioEvalColumnsIfMissing(Migrator m) async {
    final rows = await m.database
        .customSelect('PRAGMA table_info(calendario_bitacoras)')
        .get();
    final existing = rows.map((row) => row.read<String>('name')).toSet();

    if (!existing.contains('es_evaluativa')) {
      await m.addColumn(calendarioBitacoras, calendarioBitacoras.esEvaluativa);
    }
    if (!existing.contains('puntaje')) {
      await m.addColumn(calendarioBitacoras, calendarioBitacoras.puntaje);
    }
    if (!existing.contains('ruta_documento')) {
      await m.addColumn(calendarioBitacoras, calendarioBitacoras.rutaDocumento);
    }
  }
  Future<void> _selfHealHourSwaps() async {
    for (final table in ['modules', 'units', 'activities']) {
      await customStatement('''
            UPDATE $table 
            SET total_hora_academic = -(total_hora_academic + total_hora_reloj) 
            WHERE total_hora_academic < total_hora_reloj;
          ''');
      await customStatement('''
            UPDATE $table 
            SET total_hora_reloj = -total_hora_academic - total_hora_reloj 
            WHERE total_hora_academic < 0;
          ''');
      await customStatement('''
            UPDATE $table 
            SET total_hora_academic = -total_hora_academic - total_hora_reloj 
            WHERE total_hora_academic < 0;
          ''');
    }
  }

  Future<void> _finalizeStudentsForCompletedBitacoras(StudentStatusService statusService) async {
    final activeBitacoras = await (select(bitacoras)
          ..where((t) => t.estado.equals(EstadoBitacora.finalizado.index)))
        .get();
    for (final bitacora in activeBitacoras) {
      if (bitacora.codigoGrupo != null && bitacora.codigoGrupo!.isNotEmpty) {
        await statusService.transitionActiveStudentsForGroup(
          bitacora.codigoGrupo!,
          StudentStatus.finalizado,
        );
      }
    }
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
