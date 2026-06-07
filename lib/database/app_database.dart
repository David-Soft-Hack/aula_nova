import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'tables.dart';
import 'daos.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Careers,
    Modules,
    Units,
    Activities,
    Bitacoras,
    CalendarioBitacoras,
    Students,
  ],
  daos: [CareerDao, ModuleDao, UnitDao, ActivityDao, BitacoraDao, StudentDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 7;
  @override
  MigrationStrategy get migration => MigrationStrategy(
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
    },
    beforeOpen: (details) async {
      // Self-healing: Correct any crossed totalHoraAcademic and totalHoraReloj values.
      // In course planning, totalHoraAcademic is always strictly greater than totalHoraReloj.
      // If a row has academic hours less than clock hours, it means they are swapped.
      // We use a 3-step swap with negative sums to avoid SQLite's left-to-right evaluation gotcha.
      await customStatement('''
            UPDATE modules 
            SET total_hora_academic = -(total_hora_academic + total_hora_reloj) 
            WHERE total_hora_academic < total_hora_reloj;
          ''');
      await customStatement('''
            UPDATE modules 
            SET total_hora_reloj = -total_hora_academic - total_hora_reloj 
            WHERE total_hora_academic < 0;
          ''');
      await customStatement('''
            UPDATE modules 
            SET total_hora_academic = -total_hora_academic - total_hora_reloj 
            WHERE total_hora_academic < 0;
          ''');

      await customStatement('''
            UPDATE units 
            SET total_hora_academic = -(total_hora_academic + total_hora_reloj) 
            WHERE total_hora_academic < total_hora_reloj;
          ''');
      await customStatement('''
            UPDATE units 
            SET total_hora_reloj = -total_hora_academic - total_hora_reloj 
            WHERE total_hora_academic < 0;
          ''');
      await customStatement('''
            UPDATE units 
            SET total_hora_academic = -total_hora_academic - total_hora_reloj 
            WHERE total_hora_academic < 0;
          ''');

      await customStatement('''
            UPDATE activities 
            SET total_hora_academic = -(total_hora_academic + total_hora_reloj) 
            WHERE total_hora_academic < total_hora_reloj;
          ''');
      await customStatement('''
            UPDATE activities 
            SET total_hora_reloj = -total_hora_academic - total_hora_reloj 
            WHERE total_hora_academic < 0;
          ''');
      await customStatement('''
            UPDATE activities 
            SET total_hora_academic = -total_hora_academic - total_hora_reloj 
            WHERE total_hora_academic < 0;
          ''');
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
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
