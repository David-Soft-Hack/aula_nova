import 'dart:convert';

import 'package:drift/drift.dart';

// --- Enums ---
enum TipoCarrera { tecnica, curso }
enum EstadoBitacora { activo, finalizado, sinCalendario }

// --- Tables ---

class Careers extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nombre => text().unique()();
  IntColumn get tipoCarrera => intEnum<TipoCarrera>()();
  DateTimeColumn get fechaCreacion => dateTime().nullable()();
}

class Modules extends Table {
  TextColumn get codModule => text()();
  TextColumn get nombre => text().unique()();
  IntColumn get totalHoraAcademic => integer()();
  IntColumn get totalHoraReloj => integer()();
  TextColumn get carrera => text().nullable()();
  DateTimeColumn get fechaCreacion => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {codModule};
}

class Units extends Table {
  TextColumn get codUnit => text()();
  TextColumn get nombre => text()();
  IntColumn get totalHoraAcademic => integer()();
  IntColumn get totalHoraReloj => integer()();
  RealColumn get ponderacion => real()();
  
  // Foreign Key to Modules
  TextColumn get idModule => text().references(Modules, #codModule)();

  @override
  Set<Column> get primaryKey => {codUnit};
}

class Activities extends Table {
  TextColumn get codActivity => text()();
  TextColumn get descripcion => text()();
  IntColumn get totalHoraAcademic => integer()();
  IntColumn get totalHoraReloj => integer()();
  
  // Foreign Key to Units
  TextColumn get idUnit => text().references(Units, #codUnit)();

  @override
  Set<Column> get primaryKey => {codActivity};
}

class Bitacoras extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get frecuenciaClase => integer()();
  DateTimeColumn get fechaInicio => dateTime()();
  DateTimeColumn get fechaFinal => dateTime().nullable()();
  
  BoolColumn get usarHorasReloj => boolean().withDefault(const Constant(false))();

  // List storage as Text (JSON)
  TextColumn get fechasFeriadas => text().map(const ListConverter())();
  TextColumn get diasClase => text().map(const ListConverter())();
  
  TextColumn get codigoGrupo => text().nullable()();
  TextColumn get carrera => text()();
  
  IntColumn get tipoCarrera => intEnum<TipoCarrera>()();
  IntColumn get estado => intEnum<EstadoBitacora>()();
  TextColumn get turno => text().nullable()();

  // Foreign Key to Modules
  TextColumn get idModule => text().references(Modules, #codModule)();
}

class CalendarioBitacoras extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get idBitacora => integer().references(Bitacoras, #id)();
  
  TextColumn get codUnidad => text().nullable()();
  TextColumn get codActividad => text().nullable()();
  DateTimeColumn get fechaProgramada => dateTime().nullable()();
  BoolColumn get estadoImpartido => boolean().withDefault(const Constant(false))();
  IntColumn get horaImpartir => integer().nullable()();

  // Evaluation fields
  BoolColumn get esEvaluativa => boolean().withDefault(const Constant(false))();
  RealColumn get puntaje => real().nullable()();
  TextColumn get rutaDocumento => text().nullable()();
}

enum StudentStatus { activo, inactivo, graduado, suspendido, finalizado, desertado }


class Students extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get codigo => text().withLength(min: 3, max: 24).unique()();
  TextColumn get nombres => text()();
  TextColumn get apellidos => text()();
  TextColumn get email => text().nullable()();
  TextColumn get telefono => text().nullable()();
  TextColumn get carrera => text().nullable()();
  TextColumn get grupo => text().nullable()();
  IntColumn get estado => intEnum<StudentStatus>().withDefault(const Constant(0))();
  DateTimeColumn get fechaIngreso => dateTime().nullable()();
  DateTimeColumn get fechaCreacion => dateTime().nullable()();
}

// --- Converters ---
class ListConverter extends TypeConverter<List<String>, String> {
  const ListConverter();

  @override
  List<String> fromSql(String fromDb) {
    if (fromDb.isEmpty) return [];
    try {
      final decoded = jsonDecode(fromDb);
      return List<String>.from(decoded);
    } catch (_) {
      return fromDb.split(',');
    }
  }

  @override
  String toSql(List<String> value) {
    return jsonEncode(value);
  }
}
