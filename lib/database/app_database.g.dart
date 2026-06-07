// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CareersTable extends Careers with TableInfo<$CareersTable, Career> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CareersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  @override
  late final GeneratedColumnWithTypeConverter<TipoCarrera, int> tipoCarrera =
      GeneratedColumn<int>(
        'tipo_carrera',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<TipoCarrera>($CareersTable.$convertertipoCarrera);
  static const VerificationMeta _fechaCreacionMeta = const VerificationMeta(
    'fechaCreacion',
  );
  @override
  late final GeneratedColumn<DateTime> fechaCreacion =
      GeneratedColumn<DateTime>(
        'fecha_creacion',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nombre,
    tipoCarrera,
    fechaCreacion,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'careers';
  @override
  VerificationContext validateIntegrity(
    Insertable<Career> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('fecha_creacion')) {
      context.handle(
        _fechaCreacionMeta,
        fechaCreacion.isAcceptableOrUnknown(
          data['fecha_creacion']!,
          _fechaCreacionMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Career map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Career(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      tipoCarrera: $CareersTable.$convertertipoCarrera.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}tipo_carrera'],
        )!,
      ),
      fechaCreacion: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha_creacion'],
      ),
    );
  }

  @override
  $CareersTable createAlias(String alias) {
    return $CareersTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TipoCarrera, int, int> $convertertipoCarrera =
      const EnumIndexConverter<TipoCarrera>(TipoCarrera.values);
}

class Career extends DataClass implements Insertable<Career> {
  final int id;
  final String nombre;
  final TipoCarrera tipoCarrera;
  final DateTime? fechaCreacion;
  const Career({
    required this.id,
    required this.nombre,
    required this.tipoCarrera,
    this.fechaCreacion,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nombre'] = Variable<String>(nombre);
    {
      map['tipo_carrera'] = Variable<int>(
        $CareersTable.$convertertipoCarrera.toSql(tipoCarrera),
      );
    }
    if (!nullToAbsent || fechaCreacion != null) {
      map['fecha_creacion'] = Variable<DateTime>(fechaCreacion);
    }
    return map;
  }

  CareersCompanion toCompanion(bool nullToAbsent) {
    return CareersCompanion(
      id: Value(id),
      nombre: Value(nombre),
      tipoCarrera: Value(tipoCarrera),
      fechaCreacion: fechaCreacion == null && nullToAbsent
          ? const Value.absent()
          : Value(fechaCreacion),
    );
  }

  factory Career.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Career(
      id: serializer.fromJson<int>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      tipoCarrera: $CareersTable.$convertertipoCarrera.fromJson(
        serializer.fromJson<int>(json['tipoCarrera']),
      ),
      fechaCreacion: serializer.fromJson<DateTime?>(json['fechaCreacion']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nombre': serializer.toJson<String>(nombre),
      'tipoCarrera': serializer.toJson<int>(
        $CareersTable.$convertertipoCarrera.toJson(tipoCarrera),
      ),
      'fechaCreacion': serializer.toJson<DateTime?>(fechaCreacion),
    };
  }

  Career copyWith({
    int? id,
    String? nombre,
    TipoCarrera? tipoCarrera,
    Value<DateTime?> fechaCreacion = const Value.absent(),
  }) => Career(
    id: id ?? this.id,
    nombre: nombre ?? this.nombre,
    tipoCarrera: tipoCarrera ?? this.tipoCarrera,
    fechaCreacion: fechaCreacion.present
        ? fechaCreacion.value
        : this.fechaCreacion,
  );
  Career copyWithCompanion(CareersCompanion data) {
    return Career(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      tipoCarrera: data.tipoCarrera.present
          ? data.tipoCarrera.value
          : this.tipoCarrera,
      fechaCreacion: data.fechaCreacion.present
          ? data.fechaCreacion.value
          : this.fechaCreacion,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Career(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('tipoCarrera: $tipoCarrera, ')
          ..write('fechaCreacion: $fechaCreacion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nombre, tipoCarrera, fechaCreacion);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Career &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.tipoCarrera == this.tipoCarrera &&
          other.fechaCreacion == this.fechaCreacion);
}

class CareersCompanion extends UpdateCompanion<Career> {
  final Value<int> id;
  final Value<String> nombre;
  final Value<TipoCarrera> tipoCarrera;
  final Value<DateTime?> fechaCreacion;
  const CareersCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.tipoCarrera = const Value.absent(),
    this.fechaCreacion = const Value.absent(),
  });
  CareersCompanion.insert({
    this.id = const Value.absent(),
    required String nombre,
    required TipoCarrera tipoCarrera,
    this.fechaCreacion = const Value.absent(),
  }) : nombre = Value(nombre),
       tipoCarrera = Value(tipoCarrera);
  static Insertable<Career> custom({
    Expression<int>? id,
    Expression<String>? nombre,
    Expression<int>? tipoCarrera,
    Expression<DateTime>? fechaCreacion,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (tipoCarrera != null) 'tipo_carrera': tipoCarrera,
      if (fechaCreacion != null) 'fecha_creacion': fechaCreacion,
    });
  }

  CareersCompanion copyWith({
    Value<int>? id,
    Value<String>? nombre,
    Value<TipoCarrera>? tipoCarrera,
    Value<DateTime?>? fechaCreacion,
  }) {
    return CareersCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      tipoCarrera: tipoCarrera ?? this.tipoCarrera,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (tipoCarrera.present) {
      map['tipo_carrera'] = Variable<int>(
        $CareersTable.$convertertipoCarrera.toSql(tipoCarrera.value),
      );
    }
    if (fechaCreacion.present) {
      map['fecha_creacion'] = Variable<DateTime>(fechaCreacion.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CareersCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('tipoCarrera: $tipoCarrera, ')
          ..write('fechaCreacion: $fechaCreacion')
          ..write(')'))
        .toString();
  }
}

class $ClassGroupsTable extends ClassGroups
    with TableInfo<$ClassGroupsTable, ClassGroup> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ClassGroupsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _codigoMeta = const VerificationMeta('codigo');
  @override
  late final GeneratedColumn<String> codigo = GeneratedColumn<String>(
    'codigo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _carreraMeta = const VerificationMeta(
    'carrera',
  );
  @override
  late final GeneratedColumn<String> carrera = GeneratedColumn<String>(
    'carrera',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES careers (nombre)',
    ),
  );
  static const VerificationMeta _turnoMeta = const VerificationMeta('turno');
  @override
  late final GeneratedColumn<String> turno = GeneratedColumn<String>(
    'turno',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cicloMeta = const VerificationMeta('ciclo');
  @override
  late final GeneratedColumn<String> ciclo = GeneratedColumn<String>(
    'ciclo',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<EstadoGrupo, int> estado =
      GeneratedColumn<int>(
        'estado',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
      ).withConverter<EstadoGrupo>($ClassGroupsTable.$converterestado);
  static const VerificationMeta _fechaInicioMeta = const VerificationMeta(
    'fechaInicio',
  );
  @override
  late final GeneratedColumn<DateTime> fechaInicio = GeneratedColumn<DateTime>(
    'fecha_inicio',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fechaFinMeta = const VerificationMeta(
    'fechaFin',
  );
  @override
  late final GeneratedColumn<DateTime> fechaFin = GeneratedColumn<DateTime>(
    'fecha_fin',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fechaCreacionMeta = const VerificationMeta(
    'fechaCreacion',
  );
  @override
  late final GeneratedColumn<DateTime> fechaCreacion =
      GeneratedColumn<DateTime>(
        'fecha_creacion',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    codigo,
    carrera,
    turno,
    ciclo,
    estado,
    fechaInicio,
    fechaFin,
    fechaCreacion,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'class_groups';
  @override
  VerificationContext validateIntegrity(
    Insertable<ClassGroup> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('codigo')) {
      context.handle(
        _codigoMeta,
        codigo.isAcceptableOrUnknown(data['codigo']!, _codigoMeta),
      );
    } else if (isInserting) {
      context.missing(_codigoMeta);
    }
    if (data.containsKey('carrera')) {
      context.handle(
        _carreraMeta,
        carrera.isAcceptableOrUnknown(data['carrera']!, _carreraMeta),
      );
    } else if (isInserting) {
      context.missing(_carreraMeta);
    }
    if (data.containsKey('turno')) {
      context.handle(
        _turnoMeta,
        turno.isAcceptableOrUnknown(data['turno']!, _turnoMeta),
      );
    }
    if (data.containsKey('ciclo')) {
      context.handle(
        _cicloMeta,
        ciclo.isAcceptableOrUnknown(data['ciclo']!, _cicloMeta),
      );
    }
    if (data.containsKey('fecha_inicio')) {
      context.handle(
        _fechaInicioMeta,
        fechaInicio.isAcceptableOrUnknown(
          data['fecha_inicio']!,
          _fechaInicioMeta,
        ),
      );
    }
    if (data.containsKey('fecha_fin')) {
      context.handle(
        _fechaFinMeta,
        fechaFin.isAcceptableOrUnknown(data['fecha_fin']!, _fechaFinMeta),
      );
    }
    if (data.containsKey('fecha_creacion')) {
      context.handle(
        _fechaCreacionMeta,
        fechaCreacion.isAcceptableOrUnknown(
          data['fecha_creacion']!,
          _fechaCreacionMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ClassGroup map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ClassGroup(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      codigo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}codigo'],
      )!,
      carrera: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}carrera'],
      )!,
      turno: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}turno'],
      ),
      ciclo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ciclo'],
      ),
      estado: $ClassGroupsTable.$converterestado.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}estado'],
        )!,
      ),
      fechaInicio: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha_inicio'],
      ),
      fechaFin: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha_fin'],
      ),
      fechaCreacion: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha_creacion'],
      ),
    );
  }

  @override
  $ClassGroupsTable createAlias(String alias) {
    return $ClassGroupsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<EstadoGrupo, int, int> $converterestado =
      const EnumIndexConverter<EstadoGrupo>(EstadoGrupo.values);
}

class ClassGroup extends DataClass implements Insertable<ClassGroup> {
  final int id;
  final String codigo;
  final String carrera;
  final String? turno;
  final String? ciclo;
  final EstadoGrupo estado;
  final DateTime? fechaInicio;
  final DateTime? fechaFin;
  final DateTime? fechaCreacion;
  const ClassGroup({
    required this.id,
    required this.codigo,
    required this.carrera,
    this.turno,
    this.ciclo,
    required this.estado,
    this.fechaInicio,
    this.fechaFin,
    this.fechaCreacion,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['codigo'] = Variable<String>(codigo);
    map['carrera'] = Variable<String>(carrera);
    if (!nullToAbsent || turno != null) {
      map['turno'] = Variable<String>(turno);
    }
    if (!nullToAbsent || ciclo != null) {
      map['ciclo'] = Variable<String>(ciclo);
    }
    {
      map['estado'] = Variable<int>(
        $ClassGroupsTable.$converterestado.toSql(estado),
      );
    }
    if (!nullToAbsent || fechaInicio != null) {
      map['fecha_inicio'] = Variable<DateTime>(fechaInicio);
    }
    if (!nullToAbsent || fechaFin != null) {
      map['fecha_fin'] = Variable<DateTime>(fechaFin);
    }
    if (!nullToAbsent || fechaCreacion != null) {
      map['fecha_creacion'] = Variable<DateTime>(fechaCreacion);
    }
    return map;
  }

  ClassGroupsCompanion toCompanion(bool nullToAbsent) {
    return ClassGroupsCompanion(
      id: Value(id),
      codigo: Value(codigo),
      carrera: Value(carrera),
      turno: turno == null && nullToAbsent
          ? const Value.absent()
          : Value(turno),
      ciclo: ciclo == null && nullToAbsent
          ? const Value.absent()
          : Value(ciclo),
      estado: Value(estado),
      fechaInicio: fechaInicio == null && nullToAbsent
          ? const Value.absent()
          : Value(fechaInicio),
      fechaFin: fechaFin == null && nullToAbsent
          ? const Value.absent()
          : Value(fechaFin),
      fechaCreacion: fechaCreacion == null && nullToAbsent
          ? const Value.absent()
          : Value(fechaCreacion),
    );
  }

  factory ClassGroup.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ClassGroup(
      id: serializer.fromJson<int>(json['id']),
      codigo: serializer.fromJson<String>(json['codigo']),
      carrera: serializer.fromJson<String>(json['carrera']),
      turno: serializer.fromJson<String?>(json['turno']),
      ciclo: serializer.fromJson<String?>(json['ciclo']),
      estado: $ClassGroupsTable.$converterestado.fromJson(
        serializer.fromJson<int>(json['estado']),
      ),
      fechaInicio: serializer.fromJson<DateTime?>(json['fechaInicio']),
      fechaFin: serializer.fromJson<DateTime?>(json['fechaFin']),
      fechaCreacion: serializer.fromJson<DateTime?>(json['fechaCreacion']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'codigo': serializer.toJson<String>(codigo),
      'carrera': serializer.toJson<String>(carrera),
      'turno': serializer.toJson<String?>(turno),
      'ciclo': serializer.toJson<String?>(ciclo),
      'estado': serializer.toJson<int>(
        $ClassGroupsTable.$converterestado.toJson(estado),
      ),
      'fechaInicio': serializer.toJson<DateTime?>(fechaInicio),
      'fechaFin': serializer.toJson<DateTime?>(fechaFin),
      'fechaCreacion': serializer.toJson<DateTime?>(fechaCreacion),
    };
  }

  ClassGroup copyWith({
    int? id,
    String? codigo,
    String? carrera,
    Value<String?> turno = const Value.absent(),
    Value<String?> ciclo = const Value.absent(),
    EstadoGrupo? estado,
    Value<DateTime?> fechaInicio = const Value.absent(),
    Value<DateTime?> fechaFin = const Value.absent(),
    Value<DateTime?> fechaCreacion = const Value.absent(),
  }) => ClassGroup(
    id: id ?? this.id,
    codigo: codigo ?? this.codigo,
    carrera: carrera ?? this.carrera,
    turno: turno.present ? turno.value : this.turno,
    ciclo: ciclo.present ? ciclo.value : this.ciclo,
    estado: estado ?? this.estado,
    fechaInicio: fechaInicio.present ? fechaInicio.value : this.fechaInicio,
    fechaFin: fechaFin.present ? fechaFin.value : this.fechaFin,
    fechaCreacion: fechaCreacion.present
        ? fechaCreacion.value
        : this.fechaCreacion,
  );
  ClassGroup copyWithCompanion(ClassGroupsCompanion data) {
    return ClassGroup(
      id: data.id.present ? data.id.value : this.id,
      codigo: data.codigo.present ? data.codigo.value : this.codigo,
      carrera: data.carrera.present ? data.carrera.value : this.carrera,
      turno: data.turno.present ? data.turno.value : this.turno,
      ciclo: data.ciclo.present ? data.ciclo.value : this.ciclo,
      estado: data.estado.present ? data.estado.value : this.estado,
      fechaInicio: data.fechaInicio.present
          ? data.fechaInicio.value
          : this.fechaInicio,
      fechaFin: data.fechaFin.present ? data.fechaFin.value : this.fechaFin,
      fechaCreacion: data.fechaCreacion.present
          ? data.fechaCreacion.value
          : this.fechaCreacion,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ClassGroup(')
          ..write('id: $id, ')
          ..write('codigo: $codigo, ')
          ..write('carrera: $carrera, ')
          ..write('turno: $turno, ')
          ..write('ciclo: $ciclo, ')
          ..write('estado: $estado, ')
          ..write('fechaInicio: $fechaInicio, ')
          ..write('fechaFin: $fechaFin, ')
          ..write('fechaCreacion: $fechaCreacion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    codigo,
    carrera,
    turno,
    ciclo,
    estado,
    fechaInicio,
    fechaFin,
    fechaCreacion,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ClassGroup &&
          other.id == this.id &&
          other.codigo == this.codigo &&
          other.carrera == this.carrera &&
          other.turno == this.turno &&
          other.ciclo == this.ciclo &&
          other.estado == this.estado &&
          other.fechaInicio == this.fechaInicio &&
          other.fechaFin == this.fechaFin &&
          other.fechaCreacion == this.fechaCreacion);
}

class ClassGroupsCompanion extends UpdateCompanion<ClassGroup> {
  final Value<int> id;
  final Value<String> codigo;
  final Value<String> carrera;
  final Value<String?> turno;
  final Value<String?> ciclo;
  final Value<EstadoGrupo> estado;
  final Value<DateTime?> fechaInicio;
  final Value<DateTime?> fechaFin;
  final Value<DateTime?> fechaCreacion;
  const ClassGroupsCompanion({
    this.id = const Value.absent(),
    this.codigo = const Value.absent(),
    this.carrera = const Value.absent(),
    this.turno = const Value.absent(),
    this.ciclo = const Value.absent(),
    this.estado = const Value.absent(),
    this.fechaInicio = const Value.absent(),
    this.fechaFin = const Value.absent(),
    this.fechaCreacion = const Value.absent(),
  });
  ClassGroupsCompanion.insert({
    this.id = const Value.absent(),
    required String codigo,
    required String carrera,
    this.turno = const Value.absent(),
    this.ciclo = const Value.absent(),
    this.estado = const Value.absent(),
    this.fechaInicio = const Value.absent(),
    this.fechaFin = const Value.absent(),
    this.fechaCreacion = const Value.absent(),
  }) : codigo = Value(codigo),
       carrera = Value(carrera);
  static Insertable<ClassGroup> custom({
    Expression<int>? id,
    Expression<String>? codigo,
    Expression<String>? carrera,
    Expression<String>? turno,
    Expression<String>? ciclo,
    Expression<int>? estado,
    Expression<DateTime>? fechaInicio,
    Expression<DateTime>? fechaFin,
    Expression<DateTime>? fechaCreacion,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (codigo != null) 'codigo': codigo,
      if (carrera != null) 'carrera': carrera,
      if (turno != null) 'turno': turno,
      if (ciclo != null) 'ciclo': ciclo,
      if (estado != null) 'estado': estado,
      if (fechaInicio != null) 'fecha_inicio': fechaInicio,
      if (fechaFin != null) 'fecha_fin': fechaFin,
      if (fechaCreacion != null) 'fecha_creacion': fechaCreacion,
    });
  }

  ClassGroupsCompanion copyWith({
    Value<int>? id,
    Value<String>? codigo,
    Value<String>? carrera,
    Value<String?>? turno,
    Value<String?>? ciclo,
    Value<EstadoGrupo>? estado,
    Value<DateTime?>? fechaInicio,
    Value<DateTime?>? fechaFin,
    Value<DateTime?>? fechaCreacion,
  }) {
    return ClassGroupsCompanion(
      id: id ?? this.id,
      codigo: codigo ?? this.codigo,
      carrera: carrera ?? this.carrera,
      turno: turno ?? this.turno,
      ciclo: ciclo ?? this.ciclo,
      estado: estado ?? this.estado,
      fechaInicio: fechaInicio ?? this.fechaInicio,
      fechaFin: fechaFin ?? this.fechaFin,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (codigo.present) {
      map['codigo'] = Variable<String>(codigo.value);
    }
    if (carrera.present) {
      map['carrera'] = Variable<String>(carrera.value);
    }
    if (turno.present) {
      map['turno'] = Variable<String>(turno.value);
    }
    if (ciclo.present) {
      map['ciclo'] = Variable<String>(ciclo.value);
    }
    if (estado.present) {
      map['estado'] = Variable<int>(
        $ClassGroupsTable.$converterestado.toSql(estado.value),
      );
    }
    if (fechaInicio.present) {
      map['fecha_inicio'] = Variable<DateTime>(fechaInicio.value);
    }
    if (fechaFin.present) {
      map['fecha_fin'] = Variable<DateTime>(fechaFin.value);
    }
    if (fechaCreacion.present) {
      map['fecha_creacion'] = Variable<DateTime>(fechaCreacion.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ClassGroupsCompanion(')
          ..write('id: $id, ')
          ..write('codigo: $codigo, ')
          ..write('carrera: $carrera, ')
          ..write('turno: $turno, ')
          ..write('ciclo: $ciclo, ')
          ..write('estado: $estado, ')
          ..write('fechaInicio: $fechaInicio, ')
          ..write('fechaFin: $fechaFin, ')
          ..write('fechaCreacion: $fechaCreacion')
          ..write(')'))
        .toString();
  }
}

class $ModulesTable extends Modules with TableInfo<$ModulesTable, Module> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ModulesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _codModuleMeta = const VerificationMeta(
    'codModule',
  );
  @override
  late final GeneratedColumn<String> codModule = GeneratedColumn<String>(
    'cod_module',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _totalHoraAcademicMeta = const VerificationMeta(
    'totalHoraAcademic',
  );
  @override
  late final GeneratedColumn<int> totalHoraAcademic = GeneratedColumn<int>(
    'total_hora_academic',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalHoraRelojMeta = const VerificationMeta(
    'totalHoraReloj',
  );
  @override
  late final GeneratedColumn<int> totalHoraReloj = GeneratedColumn<int>(
    'total_hora_reloj',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _carreraMeta = const VerificationMeta(
    'carrera',
  );
  @override
  late final GeneratedColumn<String> carrera = GeneratedColumn<String>(
    'carrera',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fechaCreacionMeta = const VerificationMeta(
    'fechaCreacion',
  );
  @override
  late final GeneratedColumn<DateTime> fechaCreacion =
      GeneratedColumn<DateTime>(
        'fecha_creacion',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    codModule,
    nombre,
    totalHoraAcademic,
    totalHoraReloj,
    carrera,
    fechaCreacion,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'modules';
  @override
  VerificationContext validateIntegrity(
    Insertable<Module> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('cod_module')) {
      context.handle(
        _codModuleMeta,
        codModule.isAcceptableOrUnknown(data['cod_module']!, _codModuleMeta),
      );
    } else if (isInserting) {
      context.missing(_codModuleMeta);
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('total_hora_academic')) {
      context.handle(
        _totalHoraAcademicMeta,
        totalHoraAcademic.isAcceptableOrUnknown(
          data['total_hora_academic']!,
          _totalHoraAcademicMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalHoraAcademicMeta);
    }
    if (data.containsKey('total_hora_reloj')) {
      context.handle(
        _totalHoraRelojMeta,
        totalHoraReloj.isAcceptableOrUnknown(
          data['total_hora_reloj']!,
          _totalHoraRelojMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalHoraRelojMeta);
    }
    if (data.containsKey('carrera')) {
      context.handle(
        _carreraMeta,
        carrera.isAcceptableOrUnknown(data['carrera']!, _carreraMeta),
      );
    }
    if (data.containsKey('fecha_creacion')) {
      context.handle(
        _fechaCreacionMeta,
        fechaCreacion.isAcceptableOrUnknown(
          data['fecha_creacion']!,
          _fechaCreacionMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {codModule};
  @override
  Module map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Module(
      codModule: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cod_module'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      totalHoraAcademic: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_hora_academic'],
      )!,
      totalHoraReloj: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_hora_reloj'],
      )!,
      carrera: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}carrera'],
      ),
      fechaCreacion: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha_creacion'],
      ),
    );
  }

  @override
  $ModulesTable createAlias(String alias) {
    return $ModulesTable(attachedDatabase, alias);
  }
}

class Module extends DataClass implements Insertable<Module> {
  final String codModule;
  final String nombre;
  final int totalHoraAcademic;
  final int totalHoraReloj;
  final String? carrera;
  final DateTime? fechaCreacion;
  const Module({
    required this.codModule,
    required this.nombre,
    required this.totalHoraAcademic,
    required this.totalHoraReloj,
    this.carrera,
    this.fechaCreacion,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['cod_module'] = Variable<String>(codModule);
    map['nombre'] = Variable<String>(nombre);
    map['total_hora_academic'] = Variable<int>(totalHoraAcademic);
    map['total_hora_reloj'] = Variable<int>(totalHoraReloj);
    if (!nullToAbsent || carrera != null) {
      map['carrera'] = Variable<String>(carrera);
    }
    if (!nullToAbsent || fechaCreacion != null) {
      map['fecha_creacion'] = Variable<DateTime>(fechaCreacion);
    }
    return map;
  }

  ModulesCompanion toCompanion(bool nullToAbsent) {
    return ModulesCompanion(
      codModule: Value(codModule),
      nombre: Value(nombre),
      totalHoraAcademic: Value(totalHoraAcademic),
      totalHoraReloj: Value(totalHoraReloj),
      carrera: carrera == null && nullToAbsent
          ? const Value.absent()
          : Value(carrera),
      fechaCreacion: fechaCreacion == null && nullToAbsent
          ? const Value.absent()
          : Value(fechaCreacion),
    );
  }

  factory Module.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Module(
      codModule: serializer.fromJson<String>(json['codModule']),
      nombre: serializer.fromJson<String>(json['nombre']),
      totalHoraAcademic: serializer.fromJson<int>(json['totalHoraAcademic']),
      totalHoraReloj: serializer.fromJson<int>(json['totalHoraReloj']),
      carrera: serializer.fromJson<String?>(json['carrera']),
      fechaCreacion: serializer.fromJson<DateTime?>(json['fechaCreacion']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'codModule': serializer.toJson<String>(codModule),
      'nombre': serializer.toJson<String>(nombre),
      'totalHoraAcademic': serializer.toJson<int>(totalHoraAcademic),
      'totalHoraReloj': serializer.toJson<int>(totalHoraReloj),
      'carrera': serializer.toJson<String?>(carrera),
      'fechaCreacion': serializer.toJson<DateTime?>(fechaCreacion),
    };
  }

  Module copyWith({
    String? codModule,
    String? nombre,
    int? totalHoraAcademic,
    int? totalHoraReloj,
    Value<String?> carrera = const Value.absent(),
    Value<DateTime?> fechaCreacion = const Value.absent(),
  }) => Module(
    codModule: codModule ?? this.codModule,
    nombre: nombre ?? this.nombre,
    totalHoraAcademic: totalHoraAcademic ?? this.totalHoraAcademic,
    totalHoraReloj: totalHoraReloj ?? this.totalHoraReloj,
    carrera: carrera.present ? carrera.value : this.carrera,
    fechaCreacion: fechaCreacion.present
        ? fechaCreacion.value
        : this.fechaCreacion,
  );
  Module copyWithCompanion(ModulesCompanion data) {
    return Module(
      codModule: data.codModule.present ? data.codModule.value : this.codModule,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      totalHoraAcademic: data.totalHoraAcademic.present
          ? data.totalHoraAcademic.value
          : this.totalHoraAcademic,
      totalHoraReloj: data.totalHoraReloj.present
          ? data.totalHoraReloj.value
          : this.totalHoraReloj,
      carrera: data.carrera.present ? data.carrera.value : this.carrera,
      fechaCreacion: data.fechaCreacion.present
          ? data.fechaCreacion.value
          : this.fechaCreacion,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Module(')
          ..write('codModule: $codModule, ')
          ..write('nombre: $nombre, ')
          ..write('totalHoraAcademic: $totalHoraAcademic, ')
          ..write('totalHoraReloj: $totalHoraReloj, ')
          ..write('carrera: $carrera, ')
          ..write('fechaCreacion: $fechaCreacion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    codModule,
    nombre,
    totalHoraAcademic,
    totalHoraReloj,
    carrera,
    fechaCreacion,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Module &&
          other.codModule == this.codModule &&
          other.nombre == this.nombre &&
          other.totalHoraAcademic == this.totalHoraAcademic &&
          other.totalHoraReloj == this.totalHoraReloj &&
          other.carrera == this.carrera &&
          other.fechaCreacion == this.fechaCreacion);
}

class ModulesCompanion extends UpdateCompanion<Module> {
  final Value<String> codModule;
  final Value<String> nombre;
  final Value<int> totalHoraAcademic;
  final Value<int> totalHoraReloj;
  final Value<String?> carrera;
  final Value<DateTime?> fechaCreacion;
  final Value<int> rowid;
  const ModulesCompanion({
    this.codModule = const Value.absent(),
    this.nombre = const Value.absent(),
    this.totalHoraAcademic = const Value.absent(),
    this.totalHoraReloj = const Value.absent(),
    this.carrera = const Value.absent(),
    this.fechaCreacion = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ModulesCompanion.insert({
    required String codModule,
    required String nombre,
    required int totalHoraAcademic,
    required int totalHoraReloj,
    this.carrera = const Value.absent(),
    this.fechaCreacion = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : codModule = Value(codModule),
       nombre = Value(nombre),
       totalHoraAcademic = Value(totalHoraAcademic),
       totalHoraReloj = Value(totalHoraReloj);
  static Insertable<Module> custom({
    Expression<String>? codModule,
    Expression<String>? nombre,
    Expression<int>? totalHoraAcademic,
    Expression<int>? totalHoraReloj,
    Expression<String>? carrera,
    Expression<DateTime>? fechaCreacion,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (codModule != null) 'cod_module': codModule,
      if (nombre != null) 'nombre': nombre,
      if (totalHoraAcademic != null) 'total_hora_academic': totalHoraAcademic,
      if (totalHoraReloj != null) 'total_hora_reloj': totalHoraReloj,
      if (carrera != null) 'carrera': carrera,
      if (fechaCreacion != null) 'fecha_creacion': fechaCreacion,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ModulesCompanion copyWith({
    Value<String>? codModule,
    Value<String>? nombre,
    Value<int>? totalHoraAcademic,
    Value<int>? totalHoraReloj,
    Value<String?>? carrera,
    Value<DateTime?>? fechaCreacion,
    Value<int>? rowid,
  }) {
    return ModulesCompanion(
      codModule: codModule ?? this.codModule,
      nombre: nombre ?? this.nombre,
      totalHoraAcademic: totalHoraAcademic ?? this.totalHoraAcademic,
      totalHoraReloj: totalHoraReloj ?? this.totalHoraReloj,
      carrera: carrera ?? this.carrera,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (codModule.present) {
      map['cod_module'] = Variable<String>(codModule.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (totalHoraAcademic.present) {
      map['total_hora_academic'] = Variable<int>(totalHoraAcademic.value);
    }
    if (totalHoraReloj.present) {
      map['total_hora_reloj'] = Variable<int>(totalHoraReloj.value);
    }
    if (carrera.present) {
      map['carrera'] = Variable<String>(carrera.value);
    }
    if (fechaCreacion.present) {
      map['fecha_creacion'] = Variable<DateTime>(fechaCreacion.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ModulesCompanion(')
          ..write('codModule: $codModule, ')
          ..write('nombre: $nombre, ')
          ..write('totalHoraAcademic: $totalHoraAcademic, ')
          ..write('totalHoraReloj: $totalHoraReloj, ')
          ..write('carrera: $carrera, ')
          ..write('fechaCreacion: $fechaCreacion, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UnitsTable extends Units with TableInfo<$UnitsTable, Unit> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UnitsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _codUnitMeta = const VerificationMeta(
    'codUnit',
  );
  @override
  late final GeneratedColumn<String> codUnit = GeneratedColumn<String>(
    'cod_unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalHoraAcademicMeta = const VerificationMeta(
    'totalHoraAcademic',
  );
  @override
  late final GeneratedColumn<int> totalHoraAcademic = GeneratedColumn<int>(
    'total_hora_academic',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalHoraRelojMeta = const VerificationMeta(
    'totalHoraReloj',
  );
  @override
  late final GeneratedColumn<int> totalHoraReloj = GeneratedColumn<int>(
    'total_hora_reloj',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ponderacionMeta = const VerificationMeta(
    'ponderacion',
  );
  @override
  late final GeneratedColumn<double> ponderacion = GeneratedColumn<double>(
    'ponderacion',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _idModuleMeta = const VerificationMeta(
    'idModule',
  );
  @override
  late final GeneratedColumn<String> idModule = GeneratedColumn<String>(
    'id_module',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES modules (cod_module)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    codUnit,
    nombre,
    totalHoraAcademic,
    totalHoraReloj,
    ponderacion,
    idModule,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'units';
  @override
  VerificationContext validateIntegrity(
    Insertable<Unit> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('cod_unit')) {
      context.handle(
        _codUnitMeta,
        codUnit.isAcceptableOrUnknown(data['cod_unit']!, _codUnitMeta),
      );
    } else if (isInserting) {
      context.missing(_codUnitMeta);
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('total_hora_academic')) {
      context.handle(
        _totalHoraAcademicMeta,
        totalHoraAcademic.isAcceptableOrUnknown(
          data['total_hora_academic']!,
          _totalHoraAcademicMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalHoraAcademicMeta);
    }
    if (data.containsKey('total_hora_reloj')) {
      context.handle(
        _totalHoraRelojMeta,
        totalHoraReloj.isAcceptableOrUnknown(
          data['total_hora_reloj']!,
          _totalHoraRelojMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalHoraRelojMeta);
    }
    if (data.containsKey('ponderacion')) {
      context.handle(
        _ponderacionMeta,
        ponderacion.isAcceptableOrUnknown(
          data['ponderacion']!,
          _ponderacionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_ponderacionMeta);
    }
    if (data.containsKey('id_module')) {
      context.handle(
        _idModuleMeta,
        idModule.isAcceptableOrUnknown(data['id_module']!, _idModuleMeta),
      );
    } else if (isInserting) {
      context.missing(_idModuleMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {codUnit};
  @override
  Unit map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Unit(
      codUnit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cod_unit'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      totalHoraAcademic: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_hora_academic'],
      )!,
      totalHoraReloj: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_hora_reloj'],
      )!,
      ponderacion: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}ponderacion'],
      )!,
      idModule: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id_module'],
      )!,
    );
  }

  @override
  $UnitsTable createAlias(String alias) {
    return $UnitsTable(attachedDatabase, alias);
  }
}

class Unit extends DataClass implements Insertable<Unit> {
  final String codUnit;
  final String nombre;
  final int totalHoraAcademic;
  final int totalHoraReloj;
  final double ponderacion;
  final String idModule;
  const Unit({
    required this.codUnit,
    required this.nombre,
    required this.totalHoraAcademic,
    required this.totalHoraReloj,
    required this.ponderacion,
    required this.idModule,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['cod_unit'] = Variable<String>(codUnit);
    map['nombre'] = Variable<String>(nombre);
    map['total_hora_academic'] = Variable<int>(totalHoraAcademic);
    map['total_hora_reloj'] = Variable<int>(totalHoraReloj);
    map['ponderacion'] = Variable<double>(ponderacion);
    map['id_module'] = Variable<String>(idModule);
    return map;
  }

  UnitsCompanion toCompanion(bool nullToAbsent) {
    return UnitsCompanion(
      codUnit: Value(codUnit),
      nombre: Value(nombre),
      totalHoraAcademic: Value(totalHoraAcademic),
      totalHoraReloj: Value(totalHoraReloj),
      ponderacion: Value(ponderacion),
      idModule: Value(idModule),
    );
  }

  factory Unit.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Unit(
      codUnit: serializer.fromJson<String>(json['codUnit']),
      nombre: serializer.fromJson<String>(json['nombre']),
      totalHoraAcademic: serializer.fromJson<int>(json['totalHoraAcademic']),
      totalHoraReloj: serializer.fromJson<int>(json['totalHoraReloj']),
      ponderacion: serializer.fromJson<double>(json['ponderacion']),
      idModule: serializer.fromJson<String>(json['idModule']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'codUnit': serializer.toJson<String>(codUnit),
      'nombre': serializer.toJson<String>(nombre),
      'totalHoraAcademic': serializer.toJson<int>(totalHoraAcademic),
      'totalHoraReloj': serializer.toJson<int>(totalHoraReloj),
      'ponderacion': serializer.toJson<double>(ponderacion),
      'idModule': serializer.toJson<String>(idModule),
    };
  }

  Unit copyWith({
    String? codUnit,
    String? nombre,
    int? totalHoraAcademic,
    int? totalHoraReloj,
    double? ponderacion,
    String? idModule,
  }) => Unit(
    codUnit: codUnit ?? this.codUnit,
    nombre: nombre ?? this.nombre,
    totalHoraAcademic: totalHoraAcademic ?? this.totalHoraAcademic,
    totalHoraReloj: totalHoraReloj ?? this.totalHoraReloj,
    ponderacion: ponderacion ?? this.ponderacion,
    idModule: idModule ?? this.idModule,
  );
  Unit copyWithCompanion(UnitsCompanion data) {
    return Unit(
      codUnit: data.codUnit.present ? data.codUnit.value : this.codUnit,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      totalHoraAcademic: data.totalHoraAcademic.present
          ? data.totalHoraAcademic.value
          : this.totalHoraAcademic,
      totalHoraReloj: data.totalHoraReloj.present
          ? data.totalHoraReloj.value
          : this.totalHoraReloj,
      ponderacion: data.ponderacion.present
          ? data.ponderacion.value
          : this.ponderacion,
      idModule: data.idModule.present ? data.idModule.value : this.idModule,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Unit(')
          ..write('codUnit: $codUnit, ')
          ..write('nombre: $nombre, ')
          ..write('totalHoraAcademic: $totalHoraAcademic, ')
          ..write('totalHoraReloj: $totalHoraReloj, ')
          ..write('ponderacion: $ponderacion, ')
          ..write('idModule: $idModule')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    codUnit,
    nombre,
    totalHoraAcademic,
    totalHoraReloj,
    ponderacion,
    idModule,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Unit &&
          other.codUnit == this.codUnit &&
          other.nombre == this.nombre &&
          other.totalHoraAcademic == this.totalHoraAcademic &&
          other.totalHoraReloj == this.totalHoraReloj &&
          other.ponderacion == this.ponderacion &&
          other.idModule == this.idModule);
}

class UnitsCompanion extends UpdateCompanion<Unit> {
  final Value<String> codUnit;
  final Value<String> nombre;
  final Value<int> totalHoraAcademic;
  final Value<int> totalHoraReloj;
  final Value<double> ponderacion;
  final Value<String> idModule;
  final Value<int> rowid;
  const UnitsCompanion({
    this.codUnit = const Value.absent(),
    this.nombre = const Value.absent(),
    this.totalHoraAcademic = const Value.absent(),
    this.totalHoraReloj = const Value.absent(),
    this.ponderacion = const Value.absent(),
    this.idModule = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UnitsCompanion.insert({
    required String codUnit,
    required String nombre,
    required int totalHoraAcademic,
    required int totalHoraReloj,
    required double ponderacion,
    required String idModule,
    this.rowid = const Value.absent(),
  }) : codUnit = Value(codUnit),
       nombre = Value(nombre),
       totalHoraAcademic = Value(totalHoraAcademic),
       totalHoraReloj = Value(totalHoraReloj),
       ponderacion = Value(ponderacion),
       idModule = Value(idModule);
  static Insertable<Unit> custom({
    Expression<String>? codUnit,
    Expression<String>? nombre,
    Expression<int>? totalHoraAcademic,
    Expression<int>? totalHoraReloj,
    Expression<double>? ponderacion,
    Expression<String>? idModule,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (codUnit != null) 'cod_unit': codUnit,
      if (nombre != null) 'nombre': nombre,
      if (totalHoraAcademic != null) 'total_hora_academic': totalHoraAcademic,
      if (totalHoraReloj != null) 'total_hora_reloj': totalHoraReloj,
      if (ponderacion != null) 'ponderacion': ponderacion,
      if (idModule != null) 'id_module': idModule,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UnitsCompanion copyWith({
    Value<String>? codUnit,
    Value<String>? nombre,
    Value<int>? totalHoraAcademic,
    Value<int>? totalHoraReloj,
    Value<double>? ponderacion,
    Value<String>? idModule,
    Value<int>? rowid,
  }) {
    return UnitsCompanion(
      codUnit: codUnit ?? this.codUnit,
      nombre: nombre ?? this.nombre,
      totalHoraAcademic: totalHoraAcademic ?? this.totalHoraAcademic,
      totalHoraReloj: totalHoraReloj ?? this.totalHoraReloj,
      ponderacion: ponderacion ?? this.ponderacion,
      idModule: idModule ?? this.idModule,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (codUnit.present) {
      map['cod_unit'] = Variable<String>(codUnit.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (totalHoraAcademic.present) {
      map['total_hora_academic'] = Variable<int>(totalHoraAcademic.value);
    }
    if (totalHoraReloj.present) {
      map['total_hora_reloj'] = Variable<int>(totalHoraReloj.value);
    }
    if (ponderacion.present) {
      map['ponderacion'] = Variable<double>(ponderacion.value);
    }
    if (idModule.present) {
      map['id_module'] = Variable<String>(idModule.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UnitsCompanion(')
          ..write('codUnit: $codUnit, ')
          ..write('nombre: $nombre, ')
          ..write('totalHoraAcademic: $totalHoraAcademic, ')
          ..write('totalHoraReloj: $totalHoraReloj, ')
          ..write('ponderacion: $ponderacion, ')
          ..write('idModule: $idModule, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ActivitiesTable extends Activities
    with TableInfo<$ActivitiesTable, Activity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ActivitiesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _codActivityMeta = const VerificationMeta(
    'codActivity',
  );
  @override
  late final GeneratedColumn<String> codActivity = GeneratedColumn<String>(
    'cod_activity',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descripcionMeta = const VerificationMeta(
    'descripcion',
  );
  @override
  late final GeneratedColumn<String> descripcion = GeneratedColumn<String>(
    'descripcion',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalHoraAcademicMeta = const VerificationMeta(
    'totalHoraAcademic',
  );
  @override
  late final GeneratedColumn<int> totalHoraAcademic = GeneratedColumn<int>(
    'total_hora_academic',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalHoraRelojMeta = const VerificationMeta(
    'totalHoraReloj',
  );
  @override
  late final GeneratedColumn<int> totalHoraReloj = GeneratedColumn<int>(
    'total_hora_reloj',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _idUnitMeta = const VerificationMeta('idUnit');
  @override
  late final GeneratedColumn<String> idUnit = GeneratedColumn<String>(
    'id_unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES units (cod_unit)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    codActivity,
    descripcion,
    totalHoraAcademic,
    totalHoraReloj,
    idUnit,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'activities';
  @override
  VerificationContext validateIntegrity(
    Insertable<Activity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('cod_activity')) {
      context.handle(
        _codActivityMeta,
        codActivity.isAcceptableOrUnknown(
          data['cod_activity']!,
          _codActivityMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_codActivityMeta);
    }
    if (data.containsKey('descripcion')) {
      context.handle(
        _descripcionMeta,
        descripcion.isAcceptableOrUnknown(
          data['descripcion']!,
          _descripcionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descripcionMeta);
    }
    if (data.containsKey('total_hora_academic')) {
      context.handle(
        _totalHoraAcademicMeta,
        totalHoraAcademic.isAcceptableOrUnknown(
          data['total_hora_academic']!,
          _totalHoraAcademicMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalHoraAcademicMeta);
    }
    if (data.containsKey('total_hora_reloj')) {
      context.handle(
        _totalHoraRelojMeta,
        totalHoraReloj.isAcceptableOrUnknown(
          data['total_hora_reloj']!,
          _totalHoraRelojMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalHoraRelojMeta);
    }
    if (data.containsKey('id_unit')) {
      context.handle(
        _idUnitMeta,
        idUnit.isAcceptableOrUnknown(data['id_unit']!, _idUnitMeta),
      );
    } else if (isInserting) {
      context.missing(_idUnitMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {codActivity};
  @override
  Activity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Activity(
      codActivity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cod_activity'],
      )!,
      descripcion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}descripcion'],
      )!,
      totalHoraAcademic: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_hora_academic'],
      )!,
      totalHoraReloj: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_hora_reloj'],
      )!,
      idUnit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id_unit'],
      )!,
    );
  }

  @override
  $ActivitiesTable createAlias(String alias) {
    return $ActivitiesTable(attachedDatabase, alias);
  }
}

class Activity extends DataClass implements Insertable<Activity> {
  final String codActivity;
  final String descripcion;
  final int totalHoraAcademic;
  final int totalHoraReloj;
  final String idUnit;
  const Activity({
    required this.codActivity,
    required this.descripcion,
    required this.totalHoraAcademic,
    required this.totalHoraReloj,
    required this.idUnit,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['cod_activity'] = Variable<String>(codActivity);
    map['descripcion'] = Variable<String>(descripcion);
    map['total_hora_academic'] = Variable<int>(totalHoraAcademic);
    map['total_hora_reloj'] = Variable<int>(totalHoraReloj);
    map['id_unit'] = Variable<String>(idUnit);
    return map;
  }

  ActivitiesCompanion toCompanion(bool nullToAbsent) {
    return ActivitiesCompanion(
      codActivity: Value(codActivity),
      descripcion: Value(descripcion),
      totalHoraAcademic: Value(totalHoraAcademic),
      totalHoraReloj: Value(totalHoraReloj),
      idUnit: Value(idUnit),
    );
  }

  factory Activity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Activity(
      codActivity: serializer.fromJson<String>(json['codActivity']),
      descripcion: serializer.fromJson<String>(json['descripcion']),
      totalHoraAcademic: serializer.fromJson<int>(json['totalHoraAcademic']),
      totalHoraReloj: serializer.fromJson<int>(json['totalHoraReloj']),
      idUnit: serializer.fromJson<String>(json['idUnit']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'codActivity': serializer.toJson<String>(codActivity),
      'descripcion': serializer.toJson<String>(descripcion),
      'totalHoraAcademic': serializer.toJson<int>(totalHoraAcademic),
      'totalHoraReloj': serializer.toJson<int>(totalHoraReloj),
      'idUnit': serializer.toJson<String>(idUnit),
    };
  }

  Activity copyWith({
    String? codActivity,
    String? descripcion,
    int? totalHoraAcademic,
    int? totalHoraReloj,
    String? idUnit,
  }) => Activity(
    codActivity: codActivity ?? this.codActivity,
    descripcion: descripcion ?? this.descripcion,
    totalHoraAcademic: totalHoraAcademic ?? this.totalHoraAcademic,
    totalHoraReloj: totalHoraReloj ?? this.totalHoraReloj,
    idUnit: idUnit ?? this.idUnit,
  );
  Activity copyWithCompanion(ActivitiesCompanion data) {
    return Activity(
      codActivity: data.codActivity.present
          ? data.codActivity.value
          : this.codActivity,
      descripcion: data.descripcion.present
          ? data.descripcion.value
          : this.descripcion,
      totalHoraAcademic: data.totalHoraAcademic.present
          ? data.totalHoraAcademic.value
          : this.totalHoraAcademic,
      totalHoraReloj: data.totalHoraReloj.present
          ? data.totalHoraReloj.value
          : this.totalHoraReloj,
      idUnit: data.idUnit.present ? data.idUnit.value : this.idUnit,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Activity(')
          ..write('codActivity: $codActivity, ')
          ..write('descripcion: $descripcion, ')
          ..write('totalHoraAcademic: $totalHoraAcademic, ')
          ..write('totalHoraReloj: $totalHoraReloj, ')
          ..write('idUnit: $idUnit')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    codActivity,
    descripcion,
    totalHoraAcademic,
    totalHoraReloj,
    idUnit,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Activity &&
          other.codActivity == this.codActivity &&
          other.descripcion == this.descripcion &&
          other.totalHoraAcademic == this.totalHoraAcademic &&
          other.totalHoraReloj == this.totalHoraReloj &&
          other.idUnit == this.idUnit);
}

class ActivitiesCompanion extends UpdateCompanion<Activity> {
  final Value<String> codActivity;
  final Value<String> descripcion;
  final Value<int> totalHoraAcademic;
  final Value<int> totalHoraReloj;
  final Value<String> idUnit;
  final Value<int> rowid;
  const ActivitiesCompanion({
    this.codActivity = const Value.absent(),
    this.descripcion = const Value.absent(),
    this.totalHoraAcademic = const Value.absent(),
    this.totalHoraReloj = const Value.absent(),
    this.idUnit = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ActivitiesCompanion.insert({
    required String codActivity,
    required String descripcion,
    required int totalHoraAcademic,
    required int totalHoraReloj,
    required String idUnit,
    this.rowid = const Value.absent(),
  }) : codActivity = Value(codActivity),
       descripcion = Value(descripcion),
       totalHoraAcademic = Value(totalHoraAcademic),
       totalHoraReloj = Value(totalHoraReloj),
       idUnit = Value(idUnit);
  static Insertable<Activity> custom({
    Expression<String>? codActivity,
    Expression<String>? descripcion,
    Expression<int>? totalHoraAcademic,
    Expression<int>? totalHoraReloj,
    Expression<String>? idUnit,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (codActivity != null) 'cod_activity': codActivity,
      if (descripcion != null) 'descripcion': descripcion,
      if (totalHoraAcademic != null) 'total_hora_academic': totalHoraAcademic,
      if (totalHoraReloj != null) 'total_hora_reloj': totalHoraReloj,
      if (idUnit != null) 'id_unit': idUnit,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ActivitiesCompanion copyWith({
    Value<String>? codActivity,
    Value<String>? descripcion,
    Value<int>? totalHoraAcademic,
    Value<int>? totalHoraReloj,
    Value<String>? idUnit,
    Value<int>? rowid,
  }) {
    return ActivitiesCompanion(
      codActivity: codActivity ?? this.codActivity,
      descripcion: descripcion ?? this.descripcion,
      totalHoraAcademic: totalHoraAcademic ?? this.totalHoraAcademic,
      totalHoraReloj: totalHoraReloj ?? this.totalHoraReloj,
      idUnit: idUnit ?? this.idUnit,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (codActivity.present) {
      map['cod_activity'] = Variable<String>(codActivity.value);
    }
    if (descripcion.present) {
      map['descripcion'] = Variable<String>(descripcion.value);
    }
    if (totalHoraAcademic.present) {
      map['total_hora_academic'] = Variable<int>(totalHoraAcademic.value);
    }
    if (totalHoraReloj.present) {
      map['total_hora_reloj'] = Variable<int>(totalHoraReloj.value);
    }
    if (idUnit.present) {
      map['id_unit'] = Variable<String>(idUnit.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActivitiesCompanion(')
          ..write('codActivity: $codActivity, ')
          ..write('descripcion: $descripcion, ')
          ..write('totalHoraAcademic: $totalHoraAcademic, ')
          ..write('totalHoraReloj: $totalHoraReloj, ')
          ..write('idUnit: $idUnit, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BitacorasTable extends Bitacoras
    with TableInfo<$BitacorasTable, Bitacora> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BitacorasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _frecuenciaClaseMeta = const VerificationMeta(
    'frecuenciaClase',
  );
  @override
  late final GeneratedColumn<int> frecuenciaClase = GeneratedColumn<int>(
    'frecuencia_clase',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fechaInicioMeta = const VerificationMeta(
    'fechaInicio',
  );
  @override
  late final GeneratedColumn<DateTime> fechaInicio = GeneratedColumn<DateTime>(
    'fecha_inicio',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fechaFinalMeta = const VerificationMeta(
    'fechaFinal',
  );
  @override
  late final GeneratedColumn<DateTime> fechaFinal = GeneratedColumn<DateTime>(
    'fecha_final',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _usarHorasRelojMeta = const VerificationMeta(
    'usarHorasReloj',
  );
  @override
  late final GeneratedColumn<bool> usarHorasReloj = GeneratedColumn<bool>(
    'usar_horas_reloj',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("usar_horas_reloj" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String>
  fechasFeriadas = GeneratedColumn<String>(
    'fechas_feriadas',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<List<String>>($BitacorasTable.$converterfechasFeriadas);
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String> diasClase =
      GeneratedColumn<String>(
        'dias_clase',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<List<String>>($BitacorasTable.$converterdiasClase);
  static const VerificationMeta _codigoGrupoMeta = const VerificationMeta(
    'codigoGrupo',
  );
  @override
  late final GeneratedColumn<String> codigoGrupo = GeneratedColumn<String>(
    'codigo_grupo',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _carreraMeta = const VerificationMeta(
    'carrera',
  );
  @override
  late final GeneratedColumn<String> carrera = GeneratedColumn<String>(
    'carrera',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<TipoCarrera, int> tipoCarrera =
      GeneratedColumn<int>(
        'tipo_carrera',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<TipoCarrera>($BitacorasTable.$convertertipoCarrera);
  @override
  late final GeneratedColumnWithTypeConverter<EstadoBitacora, int> estado =
      GeneratedColumn<int>(
        'estado',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<EstadoBitacora>($BitacorasTable.$converterestado);
  static const VerificationMeta _turnoMeta = const VerificationMeta('turno');
  @override
  late final GeneratedColumn<String> turno = GeneratedColumn<String>(
    'turno',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _idModuleMeta = const VerificationMeta(
    'idModule',
  );
  @override
  late final GeneratedColumn<String> idModule = GeneratedColumn<String>(
    'id_module',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES modules (cod_module)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    frecuenciaClase,
    fechaInicio,
    fechaFinal,
    usarHorasReloj,
    fechasFeriadas,
    diasClase,
    codigoGrupo,
    carrera,
    tipoCarrera,
    estado,
    turno,
    idModule,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bitacoras';
  @override
  VerificationContext validateIntegrity(
    Insertable<Bitacora> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('frecuencia_clase')) {
      context.handle(
        _frecuenciaClaseMeta,
        frecuenciaClase.isAcceptableOrUnknown(
          data['frecuencia_clase']!,
          _frecuenciaClaseMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_frecuenciaClaseMeta);
    }
    if (data.containsKey('fecha_inicio')) {
      context.handle(
        _fechaInicioMeta,
        fechaInicio.isAcceptableOrUnknown(
          data['fecha_inicio']!,
          _fechaInicioMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fechaInicioMeta);
    }
    if (data.containsKey('fecha_final')) {
      context.handle(
        _fechaFinalMeta,
        fechaFinal.isAcceptableOrUnknown(data['fecha_final']!, _fechaFinalMeta),
      );
    }
    if (data.containsKey('usar_horas_reloj')) {
      context.handle(
        _usarHorasRelojMeta,
        usarHorasReloj.isAcceptableOrUnknown(
          data['usar_horas_reloj']!,
          _usarHorasRelojMeta,
        ),
      );
    }
    if (data.containsKey('codigo_grupo')) {
      context.handle(
        _codigoGrupoMeta,
        codigoGrupo.isAcceptableOrUnknown(
          data['codigo_grupo']!,
          _codigoGrupoMeta,
        ),
      );
    }
    if (data.containsKey('carrera')) {
      context.handle(
        _carreraMeta,
        carrera.isAcceptableOrUnknown(data['carrera']!, _carreraMeta),
      );
    } else if (isInserting) {
      context.missing(_carreraMeta);
    }
    if (data.containsKey('turno')) {
      context.handle(
        _turnoMeta,
        turno.isAcceptableOrUnknown(data['turno']!, _turnoMeta),
      );
    }
    if (data.containsKey('id_module')) {
      context.handle(
        _idModuleMeta,
        idModule.isAcceptableOrUnknown(data['id_module']!, _idModuleMeta),
      );
    } else if (isInserting) {
      context.missing(_idModuleMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Bitacora map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Bitacora(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      frecuenciaClase: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}frecuencia_clase'],
      )!,
      fechaInicio: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha_inicio'],
      )!,
      fechaFinal: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha_final'],
      ),
      usarHorasReloj: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}usar_horas_reloj'],
      )!,
      fechasFeriadas: $BitacorasTable.$converterfechasFeriadas.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}fechas_feriadas'],
        )!,
      ),
      diasClase: $BitacorasTable.$converterdiasClase.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}dias_clase'],
        )!,
      ),
      codigoGrupo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}codigo_grupo'],
      ),
      carrera: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}carrera'],
      )!,
      tipoCarrera: $BitacorasTable.$convertertipoCarrera.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}tipo_carrera'],
        )!,
      ),
      estado: $BitacorasTable.$converterestado.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}estado'],
        )!,
      ),
      turno: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}turno'],
      ),
      idModule: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id_module'],
      )!,
    );
  }

  @override
  $BitacorasTable createAlias(String alias) {
    return $BitacorasTable(attachedDatabase, alias);
  }

  static TypeConverter<List<String>, String> $converterfechasFeriadas =
      const ListConverter();
  static TypeConverter<List<String>, String> $converterdiasClase =
      const ListConverter();
  static JsonTypeConverter2<TipoCarrera, int, int> $convertertipoCarrera =
      const EnumIndexConverter<TipoCarrera>(TipoCarrera.values);
  static JsonTypeConverter2<EstadoBitacora, int, int> $converterestado =
      const EnumIndexConverter<EstadoBitacora>(EstadoBitacora.values);
}

class Bitacora extends DataClass implements Insertable<Bitacora> {
  final int id;
  final int frecuenciaClase;
  final DateTime fechaInicio;
  final DateTime? fechaFinal;
  final bool usarHorasReloj;
  final List<String> fechasFeriadas;
  final List<String> diasClase;
  final String? codigoGrupo;
  final String carrera;
  final TipoCarrera tipoCarrera;
  final EstadoBitacora estado;
  final String? turno;
  final String idModule;
  const Bitacora({
    required this.id,
    required this.frecuenciaClase,
    required this.fechaInicio,
    this.fechaFinal,
    required this.usarHorasReloj,
    required this.fechasFeriadas,
    required this.diasClase,
    this.codigoGrupo,
    required this.carrera,
    required this.tipoCarrera,
    required this.estado,
    this.turno,
    required this.idModule,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['frecuencia_clase'] = Variable<int>(frecuenciaClase);
    map['fecha_inicio'] = Variable<DateTime>(fechaInicio);
    if (!nullToAbsent || fechaFinal != null) {
      map['fecha_final'] = Variable<DateTime>(fechaFinal);
    }
    map['usar_horas_reloj'] = Variable<bool>(usarHorasReloj);
    {
      map['fechas_feriadas'] = Variable<String>(
        $BitacorasTable.$converterfechasFeriadas.toSql(fechasFeriadas),
      );
    }
    {
      map['dias_clase'] = Variable<String>(
        $BitacorasTable.$converterdiasClase.toSql(diasClase),
      );
    }
    if (!nullToAbsent || codigoGrupo != null) {
      map['codigo_grupo'] = Variable<String>(codigoGrupo);
    }
    map['carrera'] = Variable<String>(carrera);
    {
      map['tipo_carrera'] = Variable<int>(
        $BitacorasTable.$convertertipoCarrera.toSql(tipoCarrera),
      );
    }
    {
      map['estado'] = Variable<int>(
        $BitacorasTable.$converterestado.toSql(estado),
      );
    }
    if (!nullToAbsent || turno != null) {
      map['turno'] = Variable<String>(turno);
    }
    map['id_module'] = Variable<String>(idModule);
    return map;
  }

  BitacorasCompanion toCompanion(bool nullToAbsent) {
    return BitacorasCompanion(
      id: Value(id),
      frecuenciaClase: Value(frecuenciaClase),
      fechaInicio: Value(fechaInicio),
      fechaFinal: fechaFinal == null && nullToAbsent
          ? const Value.absent()
          : Value(fechaFinal),
      usarHorasReloj: Value(usarHorasReloj),
      fechasFeriadas: Value(fechasFeriadas),
      diasClase: Value(diasClase),
      codigoGrupo: codigoGrupo == null && nullToAbsent
          ? const Value.absent()
          : Value(codigoGrupo),
      carrera: Value(carrera),
      tipoCarrera: Value(tipoCarrera),
      estado: Value(estado),
      turno: turno == null && nullToAbsent
          ? const Value.absent()
          : Value(turno),
      idModule: Value(idModule),
    );
  }

  factory Bitacora.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Bitacora(
      id: serializer.fromJson<int>(json['id']),
      frecuenciaClase: serializer.fromJson<int>(json['frecuenciaClase']),
      fechaInicio: serializer.fromJson<DateTime>(json['fechaInicio']),
      fechaFinal: serializer.fromJson<DateTime?>(json['fechaFinal']),
      usarHorasReloj: serializer.fromJson<bool>(json['usarHorasReloj']),
      fechasFeriadas: serializer.fromJson<List<String>>(json['fechasFeriadas']),
      diasClase: serializer.fromJson<List<String>>(json['diasClase']),
      codigoGrupo: serializer.fromJson<String?>(json['codigoGrupo']),
      carrera: serializer.fromJson<String>(json['carrera']),
      tipoCarrera: $BitacorasTable.$convertertipoCarrera.fromJson(
        serializer.fromJson<int>(json['tipoCarrera']),
      ),
      estado: $BitacorasTable.$converterestado.fromJson(
        serializer.fromJson<int>(json['estado']),
      ),
      turno: serializer.fromJson<String?>(json['turno']),
      idModule: serializer.fromJson<String>(json['idModule']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'frecuenciaClase': serializer.toJson<int>(frecuenciaClase),
      'fechaInicio': serializer.toJson<DateTime>(fechaInicio),
      'fechaFinal': serializer.toJson<DateTime?>(fechaFinal),
      'usarHorasReloj': serializer.toJson<bool>(usarHorasReloj),
      'fechasFeriadas': serializer.toJson<List<String>>(fechasFeriadas),
      'diasClase': serializer.toJson<List<String>>(diasClase),
      'codigoGrupo': serializer.toJson<String?>(codigoGrupo),
      'carrera': serializer.toJson<String>(carrera),
      'tipoCarrera': serializer.toJson<int>(
        $BitacorasTable.$convertertipoCarrera.toJson(tipoCarrera),
      ),
      'estado': serializer.toJson<int>(
        $BitacorasTable.$converterestado.toJson(estado),
      ),
      'turno': serializer.toJson<String?>(turno),
      'idModule': serializer.toJson<String>(idModule),
    };
  }

  Bitacora copyWith({
    int? id,
    int? frecuenciaClase,
    DateTime? fechaInicio,
    Value<DateTime?> fechaFinal = const Value.absent(),
    bool? usarHorasReloj,
    List<String>? fechasFeriadas,
    List<String>? diasClase,
    Value<String?> codigoGrupo = const Value.absent(),
    String? carrera,
    TipoCarrera? tipoCarrera,
    EstadoBitacora? estado,
    Value<String?> turno = const Value.absent(),
    String? idModule,
  }) => Bitacora(
    id: id ?? this.id,
    frecuenciaClase: frecuenciaClase ?? this.frecuenciaClase,
    fechaInicio: fechaInicio ?? this.fechaInicio,
    fechaFinal: fechaFinal.present ? fechaFinal.value : this.fechaFinal,
    usarHorasReloj: usarHorasReloj ?? this.usarHorasReloj,
    fechasFeriadas: fechasFeriadas ?? this.fechasFeriadas,
    diasClase: diasClase ?? this.diasClase,
    codigoGrupo: codigoGrupo.present ? codigoGrupo.value : this.codigoGrupo,
    carrera: carrera ?? this.carrera,
    tipoCarrera: tipoCarrera ?? this.tipoCarrera,
    estado: estado ?? this.estado,
    turno: turno.present ? turno.value : this.turno,
    idModule: idModule ?? this.idModule,
  );
  Bitacora copyWithCompanion(BitacorasCompanion data) {
    return Bitacora(
      id: data.id.present ? data.id.value : this.id,
      frecuenciaClase: data.frecuenciaClase.present
          ? data.frecuenciaClase.value
          : this.frecuenciaClase,
      fechaInicio: data.fechaInicio.present
          ? data.fechaInicio.value
          : this.fechaInicio,
      fechaFinal: data.fechaFinal.present
          ? data.fechaFinal.value
          : this.fechaFinal,
      usarHorasReloj: data.usarHorasReloj.present
          ? data.usarHorasReloj.value
          : this.usarHorasReloj,
      fechasFeriadas: data.fechasFeriadas.present
          ? data.fechasFeriadas.value
          : this.fechasFeriadas,
      diasClase: data.diasClase.present ? data.diasClase.value : this.diasClase,
      codigoGrupo: data.codigoGrupo.present
          ? data.codigoGrupo.value
          : this.codigoGrupo,
      carrera: data.carrera.present ? data.carrera.value : this.carrera,
      tipoCarrera: data.tipoCarrera.present
          ? data.tipoCarrera.value
          : this.tipoCarrera,
      estado: data.estado.present ? data.estado.value : this.estado,
      turno: data.turno.present ? data.turno.value : this.turno,
      idModule: data.idModule.present ? data.idModule.value : this.idModule,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Bitacora(')
          ..write('id: $id, ')
          ..write('frecuenciaClase: $frecuenciaClase, ')
          ..write('fechaInicio: $fechaInicio, ')
          ..write('fechaFinal: $fechaFinal, ')
          ..write('usarHorasReloj: $usarHorasReloj, ')
          ..write('fechasFeriadas: $fechasFeriadas, ')
          ..write('diasClase: $diasClase, ')
          ..write('codigoGrupo: $codigoGrupo, ')
          ..write('carrera: $carrera, ')
          ..write('tipoCarrera: $tipoCarrera, ')
          ..write('estado: $estado, ')
          ..write('turno: $turno, ')
          ..write('idModule: $idModule')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    frecuenciaClase,
    fechaInicio,
    fechaFinal,
    usarHorasReloj,
    fechasFeriadas,
    diasClase,
    codigoGrupo,
    carrera,
    tipoCarrera,
    estado,
    turno,
    idModule,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Bitacora &&
          other.id == this.id &&
          other.frecuenciaClase == this.frecuenciaClase &&
          other.fechaInicio == this.fechaInicio &&
          other.fechaFinal == this.fechaFinal &&
          other.usarHorasReloj == this.usarHorasReloj &&
          other.fechasFeriadas == this.fechasFeriadas &&
          other.diasClase == this.diasClase &&
          other.codigoGrupo == this.codigoGrupo &&
          other.carrera == this.carrera &&
          other.tipoCarrera == this.tipoCarrera &&
          other.estado == this.estado &&
          other.turno == this.turno &&
          other.idModule == this.idModule);
}

class BitacorasCompanion extends UpdateCompanion<Bitacora> {
  final Value<int> id;
  final Value<int> frecuenciaClase;
  final Value<DateTime> fechaInicio;
  final Value<DateTime?> fechaFinal;
  final Value<bool> usarHorasReloj;
  final Value<List<String>> fechasFeriadas;
  final Value<List<String>> diasClase;
  final Value<String?> codigoGrupo;
  final Value<String> carrera;
  final Value<TipoCarrera> tipoCarrera;
  final Value<EstadoBitacora> estado;
  final Value<String?> turno;
  final Value<String> idModule;
  const BitacorasCompanion({
    this.id = const Value.absent(),
    this.frecuenciaClase = const Value.absent(),
    this.fechaInicio = const Value.absent(),
    this.fechaFinal = const Value.absent(),
    this.usarHorasReloj = const Value.absent(),
    this.fechasFeriadas = const Value.absent(),
    this.diasClase = const Value.absent(),
    this.codigoGrupo = const Value.absent(),
    this.carrera = const Value.absent(),
    this.tipoCarrera = const Value.absent(),
    this.estado = const Value.absent(),
    this.turno = const Value.absent(),
    this.idModule = const Value.absent(),
  });
  BitacorasCompanion.insert({
    this.id = const Value.absent(),
    required int frecuenciaClase,
    required DateTime fechaInicio,
    this.fechaFinal = const Value.absent(),
    this.usarHorasReloj = const Value.absent(),
    required List<String> fechasFeriadas,
    required List<String> diasClase,
    this.codigoGrupo = const Value.absent(),
    required String carrera,
    required TipoCarrera tipoCarrera,
    required EstadoBitacora estado,
    this.turno = const Value.absent(),
    required String idModule,
  }) : frecuenciaClase = Value(frecuenciaClase),
       fechaInicio = Value(fechaInicio),
       fechasFeriadas = Value(fechasFeriadas),
       diasClase = Value(diasClase),
       carrera = Value(carrera),
       tipoCarrera = Value(tipoCarrera),
       estado = Value(estado),
       idModule = Value(idModule);
  static Insertable<Bitacora> custom({
    Expression<int>? id,
    Expression<int>? frecuenciaClase,
    Expression<DateTime>? fechaInicio,
    Expression<DateTime>? fechaFinal,
    Expression<bool>? usarHorasReloj,
    Expression<String>? fechasFeriadas,
    Expression<String>? diasClase,
    Expression<String>? codigoGrupo,
    Expression<String>? carrera,
    Expression<int>? tipoCarrera,
    Expression<int>? estado,
    Expression<String>? turno,
    Expression<String>? idModule,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (frecuenciaClase != null) 'frecuencia_clase': frecuenciaClase,
      if (fechaInicio != null) 'fecha_inicio': fechaInicio,
      if (fechaFinal != null) 'fecha_final': fechaFinal,
      if (usarHorasReloj != null) 'usar_horas_reloj': usarHorasReloj,
      if (fechasFeriadas != null) 'fechas_feriadas': fechasFeriadas,
      if (diasClase != null) 'dias_clase': diasClase,
      if (codigoGrupo != null) 'codigo_grupo': codigoGrupo,
      if (carrera != null) 'carrera': carrera,
      if (tipoCarrera != null) 'tipo_carrera': tipoCarrera,
      if (estado != null) 'estado': estado,
      if (turno != null) 'turno': turno,
      if (idModule != null) 'id_module': idModule,
    });
  }

  BitacorasCompanion copyWith({
    Value<int>? id,
    Value<int>? frecuenciaClase,
    Value<DateTime>? fechaInicio,
    Value<DateTime?>? fechaFinal,
    Value<bool>? usarHorasReloj,
    Value<List<String>>? fechasFeriadas,
    Value<List<String>>? diasClase,
    Value<String?>? codigoGrupo,
    Value<String>? carrera,
    Value<TipoCarrera>? tipoCarrera,
    Value<EstadoBitacora>? estado,
    Value<String?>? turno,
    Value<String>? idModule,
  }) {
    return BitacorasCompanion(
      id: id ?? this.id,
      frecuenciaClase: frecuenciaClase ?? this.frecuenciaClase,
      fechaInicio: fechaInicio ?? this.fechaInicio,
      fechaFinal: fechaFinal ?? this.fechaFinal,
      usarHorasReloj: usarHorasReloj ?? this.usarHorasReloj,
      fechasFeriadas: fechasFeriadas ?? this.fechasFeriadas,
      diasClase: diasClase ?? this.diasClase,
      codigoGrupo: codigoGrupo ?? this.codigoGrupo,
      carrera: carrera ?? this.carrera,
      tipoCarrera: tipoCarrera ?? this.tipoCarrera,
      estado: estado ?? this.estado,
      turno: turno ?? this.turno,
      idModule: idModule ?? this.idModule,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (frecuenciaClase.present) {
      map['frecuencia_clase'] = Variable<int>(frecuenciaClase.value);
    }
    if (fechaInicio.present) {
      map['fecha_inicio'] = Variable<DateTime>(fechaInicio.value);
    }
    if (fechaFinal.present) {
      map['fecha_final'] = Variable<DateTime>(fechaFinal.value);
    }
    if (usarHorasReloj.present) {
      map['usar_horas_reloj'] = Variable<bool>(usarHorasReloj.value);
    }
    if (fechasFeriadas.present) {
      map['fechas_feriadas'] = Variable<String>(
        $BitacorasTable.$converterfechasFeriadas.toSql(fechasFeriadas.value),
      );
    }
    if (diasClase.present) {
      map['dias_clase'] = Variable<String>(
        $BitacorasTable.$converterdiasClase.toSql(diasClase.value),
      );
    }
    if (codigoGrupo.present) {
      map['codigo_grupo'] = Variable<String>(codigoGrupo.value);
    }
    if (carrera.present) {
      map['carrera'] = Variable<String>(carrera.value);
    }
    if (tipoCarrera.present) {
      map['tipo_carrera'] = Variable<int>(
        $BitacorasTable.$convertertipoCarrera.toSql(tipoCarrera.value),
      );
    }
    if (estado.present) {
      map['estado'] = Variable<int>(
        $BitacorasTable.$converterestado.toSql(estado.value),
      );
    }
    if (turno.present) {
      map['turno'] = Variable<String>(turno.value);
    }
    if (idModule.present) {
      map['id_module'] = Variable<String>(idModule.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BitacorasCompanion(')
          ..write('id: $id, ')
          ..write('frecuenciaClase: $frecuenciaClase, ')
          ..write('fechaInicio: $fechaInicio, ')
          ..write('fechaFinal: $fechaFinal, ')
          ..write('usarHorasReloj: $usarHorasReloj, ')
          ..write('fechasFeriadas: $fechasFeriadas, ')
          ..write('diasClase: $diasClase, ')
          ..write('codigoGrupo: $codigoGrupo, ')
          ..write('carrera: $carrera, ')
          ..write('tipoCarrera: $tipoCarrera, ')
          ..write('estado: $estado, ')
          ..write('turno: $turno, ')
          ..write('idModule: $idModule')
          ..write(')'))
        .toString();
  }
}

class $CalendarioBitacorasTable extends CalendarioBitacoras
    with TableInfo<$CalendarioBitacorasTable, CalendarioBitacora> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CalendarioBitacorasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _idBitacoraMeta = const VerificationMeta(
    'idBitacora',
  );
  @override
  late final GeneratedColumn<int> idBitacora = GeneratedColumn<int>(
    'id_bitacora',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES bitacoras (id)',
    ),
  );
  static const VerificationMeta _codUnidadMeta = const VerificationMeta(
    'codUnidad',
  );
  @override
  late final GeneratedColumn<String> codUnidad = GeneratedColumn<String>(
    'cod_unidad',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _codActividadMeta = const VerificationMeta(
    'codActividad',
  );
  @override
  late final GeneratedColumn<String> codActividad = GeneratedColumn<String>(
    'cod_actividad',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fechaProgramadaMeta = const VerificationMeta(
    'fechaProgramada',
  );
  @override
  late final GeneratedColumn<DateTime> fechaProgramada =
      GeneratedColumn<DateTime>(
        'fecha_programada',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _estadoImpartidoMeta = const VerificationMeta(
    'estadoImpartido',
  );
  @override
  late final GeneratedColumn<bool> estadoImpartido = GeneratedColumn<bool>(
    'estado_impartido',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("estado_impartido" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _horaImpartirMeta = const VerificationMeta(
    'horaImpartir',
  );
  @override
  late final GeneratedColumn<int> horaImpartir = GeneratedColumn<int>(
    'hora_impartir',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _esEvaluativaMeta = const VerificationMeta(
    'esEvaluativa',
  );
  @override
  late final GeneratedColumn<bool> esEvaluativa = GeneratedColumn<bool>(
    'es_evaluativa',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("es_evaluativa" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _puntajeMeta = const VerificationMeta(
    'puntaje',
  );
  @override
  late final GeneratedColumn<double> puntaje = GeneratedColumn<double>(
    'puntaje',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rutaDocumentoMeta = const VerificationMeta(
    'rutaDocumento',
  );
  @override
  late final GeneratedColumn<String> rutaDocumento = GeneratedColumn<String>(
    'ruta_documento',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    idBitacora,
    codUnidad,
    codActividad,
    fechaProgramada,
    estadoImpartido,
    horaImpartir,
    esEvaluativa,
    puntaje,
    rutaDocumento,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'calendario_bitacoras';
  @override
  VerificationContext validateIntegrity(
    Insertable<CalendarioBitacora> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('id_bitacora')) {
      context.handle(
        _idBitacoraMeta,
        idBitacora.isAcceptableOrUnknown(data['id_bitacora']!, _idBitacoraMeta),
      );
    } else if (isInserting) {
      context.missing(_idBitacoraMeta);
    }
    if (data.containsKey('cod_unidad')) {
      context.handle(
        _codUnidadMeta,
        codUnidad.isAcceptableOrUnknown(data['cod_unidad']!, _codUnidadMeta),
      );
    }
    if (data.containsKey('cod_actividad')) {
      context.handle(
        _codActividadMeta,
        codActividad.isAcceptableOrUnknown(
          data['cod_actividad']!,
          _codActividadMeta,
        ),
      );
    }
    if (data.containsKey('fecha_programada')) {
      context.handle(
        _fechaProgramadaMeta,
        fechaProgramada.isAcceptableOrUnknown(
          data['fecha_programada']!,
          _fechaProgramadaMeta,
        ),
      );
    }
    if (data.containsKey('estado_impartido')) {
      context.handle(
        _estadoImpartidoMeta,
        estadoImpartido.isAcceptableOrUnknown(
          data['estado_impartido']!,
          _estadoImpartidoMeta,
        ),
      );
    }
    if (data.containsKey('hora_impartir')) {
      context.handle(
        _horaImpartirMeta,
        horaImpartir.isAcceptableOrUnknown(
          data['hora_impartir']!,
          _horaImpartirMeta,
        ),
      );
    }
    if (data.containsKey('es_evaluativa')) {
      context.handle(
        _esEvaluativaMeta,
        esEvaluativa.isAcceptableOrUnknown(
          data['es_evaluativa']!,
          _esEvaluativaMeta,
        ),
      );
    }
    if (data.containsKey('puntaje')) {
      context.handle(
        _puntajeMeta,
        puntaje.isAcceptableOrUnknown(data['puntaje']!, _puntajeMeta),
      );
    }
    if (data.containsKey('ruta_documento')) {
      context.handle(
        _rutaDocumentoMeta,
        rutaDocumento.isAcceptableOrUnknown(
          data['ruta_documento']!,
          _rutaDocumentoMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CalendarioBitacora map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CalendarioBitacora(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      idBitacora: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id_bitacora'],
      )!,
      codUnidad: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cod_unidad'],
      ),
      codActividad: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cod_actividad'],
      ),
      fechaProgramada: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha_programada'],
      ),
      estadoImpartido: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}estado_impartido'],
      )!,
      horaImpartir: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hora_impartir'],
      ),
      esEvaluativa: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}es_evaluativa'],
      )!,
      puntaje: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}puntaje'],
      ),
      rutaDocumento: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ruta_documento'],
      ),
    );
  }

  @override
  $CalendarioBitacorasTable createAlias(String alias) {
    return $CalendarioBitacorasTable(attachedDatabase, alias);
  }
}

class CalendarioBitacora extends DataClass
    implements Insertable<CalendarioBitacora> {
  final int id;
  final int idBitacora;
  final String? codUnidad;
  final String? codActividad;
  final DateTime? fechaProgramada;
  final bool estadoImpartido;
  final int? horaImpartir;
  final bool esEvaluativa;
  final double? puntaje;
  final String? rutaDocumento;
  const CalendarioBitacora({
    required this.id,
    required this.idBitacora,
    this.codUnidad,
    this.codActividad,
    this.fechaProgramada,
    required this.estadoImpartido,
    this.horaImpartir,
    required this.esEvaluativa,
    this.puntaje,
    this.rutaDocumento,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['id_bitacora'] = Variable<int>(idBitacora);
    if (!nullToAbsent || codUnidad != null) {
      map['cod_unidad'] = Variable<String>(codUnidad);
    }
    if (!nullToAbsent || codActividad != null) {
      map['cod_actividad'] = Variable<String>(codActividad);
    }
    if (!nullToAbsent || fechaProgramada != null) {
      map['fecha_programada'] = Variable<DateTime>(fechaProgramada);
    }
    map['estado_impartido'] = Variable<bool>(estadoImpartido);
    if (!nullToAbsent || horaImpartir != null) {
      map['hora_impartir'] = Variable<int>(horaImpartir);
    }
    map['es_evaluativa'] = Variable<bool>(esEvaluativa);
    if (!nullToAbsent || puntaje != null) {
      map['puntaje'] = Variable<double>(puntaje);
    }
    if (!nullToAbsent || rutaDocumento != null) {
      map['ruta_documento'] = Variable<String>(rutaDocumento);
    }
    return map;
  }

  CalendarioBitacorasCompanion toCompanion(bool nullToAbsent) {
    return CalendarioBitacorasCompanion(
      id: Value(id),
      idBitacora: Value(idBitacora),
      codUnidad: codUnidad == null && nullToAbsent
          ? const Value.absent()
          : Value(codUnidad),
      codActividad: codActividad == null && nullToAbsent
          ? const Value.absent()
          : Value(codActividad),
      fechaProgramada: fechaProgramada == null && nullToAbsent
          ? const Value.absent()
          : Value(fechaProgramada),
      estadoImpartido: Value(estadoImpartido),
      horaImpartir: horaImpartir == null && nullToAbsent
          ? const Value.absent()
          : Value(horaImpartir),
      esEvaluativa: Value(esEvaluativa),
      puntaje: puntaje == null && nullToAbsent
          ? const Value.absent()
          : Value(puntaje),
      rutaDocumento: rutaDocumento == null && nullToAbsent
          ? const Value.absent()
          : Value(rutaDocumento),
    );
  }

  factory CalendarioBitacora.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CalendarioBitacora(
      id: serializer.fromJson<int>(json['id']),
      idBitacora: serializer.fromJson<int>(json['idBitacora']),
      codUnidad: serializer.fromJson<String?>(json['codUnidad']),
      codActividad: serializer.fromJson<String?>(json['codActividad']),
      fechaProgramada: serializer.fromJson<DateTime?>(json['fechaProgramada']),
      estadoImpartido: serializer.fromJson<bool>(json['estadoImpartido']),
      horaImpartir: serializer.fromJson<int?>(json['horaImpartir']),
      esEvaluativa: serializer.fromJson<bool>(json['esEvaluativa']),
      puntaje: serializer.fromJson<double?>(json['puntaje']),
      rutaDocumento: serializer.fromJson<String?>(json['rutaDocumento']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'idBitacora': serializer.toJson<int>(idBitacora),
      'codUnidad': serializer.toJson<String?>(codUnidad),
      'codActividad': serializer.toJson<String?>(codActividad),
      'fechaProgramada': serializer.toJson<DateTime?>(fechaProgramada),
      'estadoImpartido': serializer.toJson<bool>(estadoImpartido),
      'horaImpartir': serializer.toJson<int?>(horaImpartir),
      'esEvaluativa': serializer.toJson<bool>(esEvaluativa),
      'puntaje': serializer.toJson<double?>(puntaje),
      'rutaDocumento': serializer.toJson<String?>(rutaDocumento),
    };
  }

  CalendarioBitacora copyWith({
    int? id,
    int? idBitacora,
    Value<String?> codUnidad = const Value.absent(),
    Value<String?> codActividad = const Value.absent(),
    Value<DateTime?> fechaProgramada = const Value.absent(),
    bool? estadoImpartido,
    Value<int?> horaImpartir = const Value.absent(),
    bool? esEvaluativa,
    Value<double?> puntaje = const Value.absent(),
    Value<String?> rutaDocumento = const Value.absent(),
  }) => CalendarioBitacora(
    id: id ?? this.id,
    idBitacora: idBitacora ?? this.idBitacora,
    codUnidad: codUnidad.present ? codUnidad.value : this.codUnidad,
    codActividad: codActividad.present ? codActividad.value : this.codActividad,
    fechaProgramada: fechaProgramada.present
        ? fechaProgramada.value
        : this.fechaProgramada,
    estadoImpartido: estadoImpartido ?? this.estadoImpartido,
    horaImpartir: horaImpartir.present ? horaImpartir.value : this.horaImpartir,
    esEvaluativa: esEvaluativa ?? this.esEvaluativa,
    puntaje: puntaje.present ? puntaje.value : this.puntaje,
    rutaDocumento: rutaDocumento.present
        ? rutaDocumento.value
        : this.rutaDocumento,
  );
  CalendarioBitacora copyWithCompanion(CalendarioBitacorasCompanion data) {
    return CalendarioBitacora(
      id: data.id.present ? data.id.value : this.id,
      idBitacora: data.idBitacora.present
          ? data.idBitacora.value
          : this.idBitacora,
      codUnidad: data.codUnidad.present ? data.codUnidad.value : this.codUnidad,
      codActividad: data.codActividad.present
          ? data.codActividad.value
          : this.codActividad,
      fechaProgramada: data.fechaProgramada.present
          ? data.fechaProgramada.value
          : this.fechaProgramada,
      estadoImpartido: data.estadoImpartido.present
          ? data.estadoImpartido.value
          : this.estadoImpartido,
      horaImpartir: data.horaImpartir.present
          ? data.horaImpartir.value
          : this.horaImpartir,
      esEvaluativa: data.esEvaluativa.present
          ? data.esEvaluativa.value
          : this.esEvaluativa,
      puntaje: data.puntaje.present ? data.puntaje.value : this.puntaje,
      rutaDocumento: data.rutaDocumento.present
          ? data.rutaDocumento.value
          : this.rutaDocumento,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CalendarioBitacora(')
          ..write('id: $id, ')
          ..write('idBitacora: $idBitacora, ')
          ..write('codUnidad: $codUnidad, ')
          ..write('codActividad: $codActividad, ')
          ..write('fechaProgramada: $fechaProgramada, ')
          ..write('estadoImpartido: $estadoImpartido, ')
          ..write('horaImpartir: $horaImpartir, ')
          ..write('esEvaluativa: $esEvaluativa, ')
          ..write('puntaje: $puntaje, ')
          ..write('rutaDocumento: $rutaDocumento')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    idBitacora,
    codUnidad,
    codActividad,
    fechaProgramada,
    estadoImpartido,
    horaImpartir,
    esEvaluativa,
    puntaje,
    rutaDocumento,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CalendarioBitacora &&
          other.id == this.id &&
          other.idBitacora == this.idBitacora &&
          other.codUnidad == this.codUnidad &&
          other.codActividad == this.codActividad &&
          other.fechaProgramada == this.fechaProgramada &&
          other.estadoImpartido == this.estadoImpartido &&
          other.horaImpartir == this.horaImpartir &&
          other.esEvaluativa == this.esEvaluativa &&
          other.puntaje == this.puntaje &&
          other.rutaDocumento == this.rutaDocumento);
}

class CalendarioBitacorasCompanion extends UpdateCompanion<CalendarioBitacora> {
  final Value<int> id;
  final Value<int> idBitacora;
  final Value<String?> codUnidad;
  final Value<String?> codActividad;
  final Value<DateTime?> fechaProgramada;
  final Value<bool> estadoImpartido;
  final Value<int?> horaImpartir;
  final Value<bool> esEvaluativa;
  final Value<double?> puntaje;
  final Value<String?> rutaDocumento;
  const CalendarioBitacorasCompanion({
    this.id = const Value.absent(),
    this.idBitacora = const Value.absent(),
    this.codUnidad = const Value.absent(),
    this.codActividad = const Value.absent(),
    this.fechaProgramada = const Value.absent(),
    this.estadoImpartido = const Value.absent(),
    this.horaImpartir = const Value.absent(),
    this.esEvaluativa = const Value.absent(),
    this.puntaje = const Value.absent(),
    this.rutaDocumento = const Value.absent(),
  });
  CalendarioBitacorasCompanion.insert({
    this.id = const Value.absent(),
    required int idBitacora,
    this.codUnidad = const Value.absent(),
    this.codActividad = const Value.absent(),
    this.fechaProgramada = const Value.absent(),
    this.estadoImpartido = const Value.absent(),
    this.horaImpartir = const Value.absent(),
    this.esEvaluativa = const Value.absent(),
    this.puntaje = const Value.absent(),
    this.rutaDocumento = const Value.absent(),
  }) : idBitacora = Value(idBitacora);
  static Insertable<CalendarioBitacora> custom({
    Expression<int>? id,
    Expression<int>? idBitacora,
    Expression<String>? codUnidad,
    Expression<String>? codActividad,
    Expression<DateTime>? fechaProgramada,
    Expression<bool>? estadoImpartido,
    Expression<int>? horaImpartir,
    Expression<bool>? esEvaluativa,
    Expression<double>? puntaje,
    Expression<String>? rutaDocumento,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (idBitacora != null) 'id_bitacora': idBitacora,
      if (codUnidad != null) 'cod_unidad': codUnidad,
      if (codActividad != null) 'cod_actividad': codActividad,
      if (fechaProgramada != null) 'fecha_programada': fechaProgramada,
      if (estadoImpartido != null) 'estado_impartido': estadoImpartido,
      if (horaImpartir != null) 'hora_impartir': horaImpartir,
      if (esEvaluativa != null) 'es_evaluativa': esEvaluativa,
      if (puntaje != null) 'puntaje': puntaje,
      if (rutaDocumento != null) 'ruta_documento': rutaDocumento,
    });
  }

  CalendarioBitacorasCompanion copyWith({
    Value<int>? id,
    Value<int>? idBitacora,
    Value<String?>? codUnidad,
    Value<String?>? codActividad,
    Value<DateTime?>? fechaProgramada,
    Value<bool>? estadoImpartido,
    Value<int?>? horaImpartir,
    Value<bool>? esEvaluativa,
    Value<double?>? puntaje,
    Value<String?>? rutaDocumento,
  }) {
    return CalendarioBitacorasCompanion(
      id: id ?? this.id,
      idBitacora: idBitacora ?? this.idBitacora,
      codUnidad: codUnidad ?? this.codUnidad,
      codActividad: codActividad ?? this.codActividad,
      fechaProgramada: fechaProgramada ?? this.fechaProgramada,
      estadoImpartido: estadoImpartido ?? this.estadoImpartido,
      horaImpartir: horaImpartir ?? this.horaImpartir,
      esEvaluativa: esEvaluativa ?? this.esEvaluativa,
      puntaje: puntaje ?? this.puntaje,
      rutaDocumento: rutaDocumento ?? this.rutaDocumento,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (idBitacora.present) {
      map['id_bitacora'] = Variable<int>(idBitacora.value);
    }
    if (codUnidad.present) {
      map['cod_unidad'] = Variable<String>(codUnidad.value);
    }
    if (codActividad.present) {
      map['cod_actividad'] = Variable<String>(codActividad.value);
    }
    if (fechaProgramada.present) {
      map['fecha_programada'] = Variable<DateTime>(fechaProgramada.value);
    }
    if (estadoImpartido.present) {
      map['estado_impartido'] = Variable<bool>(estadoImpartido.value);
    }
    if (horaImpartir.present) {
      map['hora_impartir'] = Variable<int>(horaImpartir.value);
    }
    if (esEvaluativa.present) {
      map['es_evaluativa'] = Variable<bool>(esEvaluativa.value);
    }
    if (puntaje.present) {
      map['puntaje'] = Variable<double>(puntaje.value);
    }
    if (rutaDocumento.present) {
      map['ruta_documento'] = Variable<String>(rutaDocumento.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CalendarioBitacorasCompanion(')
          ..write('id: $id, ')
          ..write('idBitacora: $idBitacora, ')
          ..write('codUnidad: $codUnidad, ')
          ..write('codActividad: $codActividad, ')
          ..write('fechaProgramada: $fechaProgramada, ')
          ..write('estadoImpartido: $estadoImpartido, ')
          ..write('horaImpartir: $horaImpartir, ')
          ..write('esEvaluativa: $esEvaluativa, ')
          ..write('puntaje: $puntaje, ')
          ..write('rutaDocumento: $rutaDocumento')
          ..write(')'))
        .toString();
  }
}

class $StudentsTable extends Students with TableInfo<$StudentsTable, Student> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StudentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _codigoMeta = const VerificationMeta('codigo');
  @override
  late final GeneratedColumn<String> codigo = GeneratedColumn<String>(
    'codigo',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 3,
      maxTextLength: 24,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _nombresMeta = const VerificationMeta(
    'nombres',
  );
  @override
  late final GeneratedColumn<String> nombres = GeneratedColumn<String>(
    'nombres',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _apellidosMeta = const VerificationMeta(
    'apellidos',
  );
  @override
  late final GeneratedColumn<String> apellidos = GeneratedColumn<String>(
    'apellidos',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _telefonoMeta = const VerificationMeta(
    'telefono',
  );
  @override
  late final GeneratedColumn<String> telefono = GeneratedColumn<String>(
    'telefono',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _carreraMeta = const VerificationMeta(
    'carrera',
  );
  @override
  late final GeneratedColumn<String> carrera = GeneratedColumn<String>(
    'carrera',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _grupoMeta = const VerificationMeta('grupo');
  @override
  late final GeneratedColumn<String> grupo = GeneratedColumn<String>(
    'grupo',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<StudentStatus, int> estado =
      GeneratedColumn<int>(
        'estado',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
      ).withConverter<StudentStatus>($StudentsTable.$converterestado);
  static const VerificationMeta _fechaIngresoMeta = const VerificationMeta(
    'fechaIngreso',
  );
  @override
  late final GeneratedColumn<DateTime> fechaIngreso = GeneratedColumn<DateTime>(
    'fecha_ingreso',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fechaCreacionMeta = const VerificationMeta(
    'fechaCreacion',
  );
  @override
  late final GeneratedColumn<DateTime> fechaCreacion =
      GeneratedColumn<DateTime>(
        'fecha_creacion',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    codigo,
    nombres,
    apellidos,
    email,
    telefono,
    carrera,
    grupo,
    estado,
    fechaIngreso,
    fechaCreacion,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'students';
  @override
  VerificationContext validateIntegrity(
    Insertable<Student> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('codigo')) {
      context.handle(
        _codigoMeta,
        codigo.isAcceptableOrUnknown(data['codigo']!, _codigoMeta),
      );
    } else if (isInserting) {
      context.missing(_codigoMeta);
    }
    if (data.containsKey('nombres')) {
      context.handle(
        _nombresMeta,
        nombres.isAcceptableOrUnknown(data['nombres']!, _nombresMeta),
      );
    } else if (isInserting) {
      context.missing(_nombresMeta);
    }
    if (data.containsKey('apellidos')) {
      context.handle(
        _apellidosMeta,
        apellidos.isAcceptableOrUnknown(data['apellidos']!, _apellidosMeta),
      );
    } else if (isInserting) {
      context.missing(_apellidosMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('telefono')) {
      context.handle(
        _telefonoMeta,
        telefono.isAcceptableOrUnknown(data['telefono']!, _telefonoMeta),
      );
    }
    if (data.containsKey('carrera')) {
      context.handle(
        _carreraMeta,
        carrera.isAcceptableOrUnknown(data['carrera']!, _carreraMeta),
      );
    }
    if (data.containsKey('grupo')) {
      context.handle(
        _grupoMeta,
        grupo.isAcceptableOrUnknown(data['grupo']!, _grupoMeta),
      );
    }
    if (data.containsKey('fecha_ingreso')) {
      context.handle(
        _fechaIngresoMeta,
        fechaIngreso.isAcceptableOrUnknown(
          data['fecha_ingreso']!,
          _fechaIngresoMeta,
        ),
      );
    }
    if (data.containsKey('fecha_creacion')) {
      context.handle(
        _fechaCreacionMeta,
        fechaCreacion.isAcceptableOrUnknown(
          data['fecha_creacion']!,
          _fechaCreacionMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Student map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Student(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      codigo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}codigo'],
      )!,
      nombres: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombres'],
      )!,
      apellidos: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}apellidos'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      ),
      telefono: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}telefono'],
      ),
      carrera: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}carrera'],
      ),
      grupo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}grupo'],
      ),
      estado: $StudentsTable.$converterestado.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}estado'],
        )!,
      ),
      fechaIngreso: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha_ingreso'],
      ),
      fechaCreacion: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha_creacion'],
      ),
    );
  }

  @override
  $StudentsTable createAlias(String alias) {
    return $StudentsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<StudentStatus, int, int> $converterestado =
      const EnumIndexConverter<StudentStatus>(StudentStatus.values);
}

class Student extends DataClass implements Insertable<Student> {
  final int id;
  final String codigo;
  final String nombres;
  final String apellidos;
  final String? email;
  final String? telefono;
  final String? carrera;
  final String? grupo;
  final StudentStatus estado;
  final DateTime? fechaIngreso;
  final DateTime? fechaCreacion;
  const Student({
    required this.id,
    required this.codigo,
    required this.nombres,
    required this.apellidos,
    this.email,
    this.telefono,
    this.carrera,
    this.grupo,
    required this.estado,
    this.fechaIngreso,
    this.fechaCreacion,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['codigo'] = Variable<String>(codigo);
    map['nombres'] = Variable<String>(nombres);
    map['apellidos'] = Variable<String>(apellidos);
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || telefono != null) {
      map['telefono'] = Variable<String>(telefono);
    }
    if (!nullToAbsent || carrera != null) {
      map['carrera'] = Variable<String>(carrera);
    }
    if (!nullToAbsent || grupo != null) {
      map['grupo'] = Variable<String>(grupo);
    }
    {
      map['estado'] = Variable<int>(
        $StudentsTable.$converterestado.toSql(estado),
      );
    }
    if (!nullToAbsent || fechaIngreso != null) {
      map['fecha_ingreso'] = Variable<DateTime>(fechaIngreso);
    }
    if (!nullToAbsent || fechaCreacion != null) {
      map['fecha_creacion'] = Variable<DateTime>(fechaCreacion);
    }
    return map;
  }

  StudentsCompanion toCompanion(bool nullToAbsent) {
    return StudentsCompanion(
      id: Value(id),
      codigo: Value(codigo),
      nombres: Value(nombres),
      apellidos: Value(apellidos),
      email: email == null && nullToAbsent
          ? const Value.absent()
          : Value(email),
      telefono: telefono == null && nullToAbsent
          ? const Value.absent()
          : Value(telefono),
      carrera: carrera == null && nullToAbsent
          ? const Value.absent()
          : Value(carrera),
      grupo: grupo == null && nullToAbsent
          ? const Value.absent()
          : Value(grupo),
      estado: Value(estado),
      fechaIngreso: fechaIngreso == null && nullToAbsent
          ? const Value.absent()
          : Value(fechaIngreso),
      fechaCreacion: fechaCreacion == null && nullToAbsent
          ? const Value.absent()
          : Value(fechaCreacion),
    );
  }

  factory Student.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Student(
      id: serializer.fromJson<int>(json['id']),
      codigo: serializer.fromJson<String>(json['codigo']),
      nombres: serializer.fromJson<String>(json['nombres']),
      apellidos: serializer.fromJson<String>(json['apellidos']),
      email: serializer.fromJson<String?>(json['email']),
      telefono: serializer.fromJson<String?>(json['telefono']),
      carrera: serializer.fromJson<String?>(json['carrera']),
      grupo: serializer.fromJson<String?>(json['grupo']),
      estado: $StudentsTable.$converterestado.fromJson(
        serializer.fromJson<int>(json['estado']),
      ),
      fechaIngreso: serializer.fromJson<DateTime?>(json['fechaIngreso']),
      fechaCreacion: serializer.fromJson<DateTime?>(json['fechaCreacion']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'codigo': serializer.toJson<String>(codigo),
      'nombres': serializer.toJson<String>(nombres),
      'apellidos': serializer.toJson<String>(apellidos),
      'email': serializer.toJson<String?>(email),
      'telefono': serializer.toJson<String?>(telefono),
      'carrera': serializer.toJson<String?>(carrera),
      'grupo': serializer.toJson<String?>(grupo),
      'estado': serializer.toJson<int>(
        $StudentsTable.$converterestado.toJson(estado),
      ),
      'fechaIngreso': serializer.toJson<DateTime?>(fechaIngreso),
      'fechaCreacion': serializer.toJson<DateTime?>(fechaCreacion),
    };
  }

  Student copyWith({
    int? id,
    String? codigo,
    String? nombres,
    String? apellidos,
    Value<String?> email = const Value.absent(),
    Value<String?> telefono = const Value.absent(),
    Value<String?> carrera = const Value.absent(),
    Value<String?> grupo = const Value.absent(),
    StudentStatus? estado,
    Value<DateTime?> fechaIngreso = const Value.absent(),
    Value<DateTime?> fechaCreacion = const Value.absent(),
  }) => Student(
    id: id ?? this.id,
    codigo: codigo ?? this.codigo,
    nombres: nombres ?? this.nombres,
    apellidos: apellidos ?? this.apellidos,
    email: email.present ? email.value : this.email,
    telefono: telefono.present ? telefono.value : this.telefono,
    carrera: carrera.present ? carrera.value : this.carrera,
    grupo: grupo.present ? grupo.value : this.grupo,
    estado: estado ?? this.estado,
    fechaIngreso: fechaIngreso.present ? fechaIngreso.value : this.fechaIngreso,
    fechaCreacion: fechaCreacion.present
        ? fechaCreacion.value
        : this.fechaCreacion,
  );
  Student copyWithCompanion(StudentsCompanion data) {
    return Student(
      id: data.id.present ? data.id.value : this.id,
      codigo: data.codigo.present ? data.codigo.value : this.codigo,
      nombres: data.nombres.present ? data.nombres.value : this.nombres,
      apellidos: data.apellidos.present ? data.apellidos.value : this.apellidos,
      email: data.email.present ? data.email.value : this.email,
      telefono: data.telefono.present ? data.telefono.value : this.telefono,
      carrera: data.carrera.present ? data.carrera.value : this.carrera,
      grupo: data.grupo.present ? data.grupo.value : this.grupo,
      estado: data.estado.present ? data.estado.value : this.estado,
      fechaIngreso: data.fechaIngreso.present
          ? data.fechaIngreso.value
          : this.fechaIngreso,
      fechaCreacion: data.fechaCreacion.present
          ? data.fechaCreacion.value
          : this.fechaCreacion,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Student(')
          ..write('id: $id, ')
          ..write('codigo: $codigo, ')
          ..write('nombres: $nombres, ')
          ..write('apellidos: $apellidos, ')
          ..write('email: $email, ')
          ..write('telefono: $telefono, ')
          ..write('carrera: $carrera, ')
          ..write('grupo: $grupo, ')
          ..write('estado: $estado, ')
          ..write('fechaIngreso: $fechaIngreso, ')
          ..write('fechaCreacion: $fechaCreacion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    codigo,
    nombres,
    apellidos,
    email,
    telefono,
    carrera,
    grupo,
    estado,
    fechaIngreso,
    fechaCreacion,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Student &&
          other.id == this.id &&
          other.codigo == this.codigo &&
          other.nombres == this.nombres &&
          other.apellidos == this.apellidos &&
          other.email == this.email &&
          other.telefono == this.telefono &&
          other.carrera == this.carrera &&
          other.grupo == this.grupo &&
          other.estado == this.estado &&
          other.fechaIngreso == this.fechaIngreso &&
          other.fechaCreacion == this.fechaCreacion);
}

class StudentsCompanion extends UpdateCompanion<Student> {
  final Value<int> id;
  final Value<String> codigo;
  final Value<String> nombres;
  final Value<String> apellidos;
  final Value<String?> email;
  final Value<String?> telefono;
  final Value<String?> carrera;
  final Value<String?> grupo;
  final Value<StudentStatus> estado;
  final Value<DateTime?> fechaIngreso;
  final Value<DateTime?> fechaCreacion;
  const StudentsCompanion({
    this.id = const Value.absent(),
    this.codigo = const Value.absent(),
    this.nombres = const Value.absent(),
    this.apellidos = const Value.absent(),
    this.email = const Value.absent(),
    this.telefono = const Value.absent(),
    this.carrera = const Value.absent(),
    this.grupo = const Value.absent(),
    this.estado = const Value.absent(),
    this.fechaIngreso = const Value.absent(),
    this.fechaCreacion = const Value.absent(),
  });
  StudentsCompanion.insert({
    this.id = const Value.absent(),
    required String codigo,
    required String nombres,
    required String apellidos,
    this.email = const Value.absent(),
    this.telefono = const Value.absent(),
    this.carrera = const Value.absent(),
    this.grupo = const Value.absent(),
    this.estado = const Value.absent(),
    this.fechaIngreso = const Value.absent(),
    this.fechaCreacion = const Value.absent(),
  }) : codigo = Value(codigo),
       nombres = Value(nombres),
       apellidos = Value(apellidos);
  static Insertable<Student> custom({
    Expression<int>? id,
    Expression<String>? codigo,
    Expression<String>? nombres,
    Expression<String>? apellidos,
    Expression<String>? email,
    Expression<String>? telefono,
    Expression<String>? carrera,
    Expression<String>? grupo,
    Expression<int>? estado,
    Expression<DateTime>? fechaIngreso,
    Expression<DateTime>? fechaCreacion,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (codigo != null) 'codigo': codigo,
      if (nombres != null) 'nombres': nombres,
      if (apellidos != null) 'apellidos': apellidos,
      if (email != null) 'email': email,
      if (telefono != null) 'telefono': telefono,
      if (carrera != null) 'carrera': carrera,
      if (grupo != null) 'grupo': grupo,
      if (estado != null) 'estado': estado,
      if (fechaIngreso != null) 'fecha_ingreso': fechaIngreso,
      if (fechaCreacion != null) 'fecha_creacion': fechaCreacion,
    });
  }

  StudentsCompanion copyWith({
    Value<int>? id,
    Value<String>? codigo,
    Value<String>? nombres,
    Value<String>? apellidos,
    Value<String?>? email,
    Value<String?>? telefono,
    Value<String?>? carrera,
    Value<String?>? grupo,
    Value<StudentStatus>? estado,
    Value<DateTime?>? fechaIngreso,
    Value<DateTime?>? fechaCreacion,
  }) {
    return StudentsCompanion(
      id: id ?? this.id,
      codigo: codigo ?? this.codigo,
      nombres: nombres ?? this.nombres,
      apellidos: apellidos ?? this.apellidos,
      email: email ?? this.email,
      telefono: telefono ?? this.telefono,
      carrera: carrera ?? this.carrera,
      grupo: grupo ?? this.grupo,
      estado: estado ?? this.estado,
      fechaIngreso: fechaIngreso ?? this.fechaIngreso,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (codigo.present) {
      map['codigo'] = Variable<String>(codigo.value);
    }
    if (nombres.present) {
      map['nombres'] = Variable<String>(nombres.value);
    }
    if (apellidos.present) {
      map['apellidos'] = Variable<String>(apellidos.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (telefono.present) {
      map['telefono'] = Variable<String>(telefono.value);
    }
    if (carrera.present) {
      map['carrera'] = Variable<String>(carrera.value);
    }
    if (grupo.present) {
      map['grupo'] = Variable<String>(grupo.value);
    }
    if (estado.present) {
      map['estado'] = Variable<int>(
        $StudentsTable.$converterestado.toSql(estado.value),
      );
    }
    if (fechaIngreso.present) {
      map['fecha_ingreso'] = Variable<DateTime>(fechaIngreso.value);
    }
    if (fechaCreacion.present) {
      map['fecha_creacion'] = Variable<DateTime>(fechaCreacion.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StudentsCompanion(')
          ..write('id: $id, ')
          ..write('codigo: $codigo, ')
          ..write('nombres: $nombres, ')
          ..write('apellidos: $apellidos, ')
          ..write('email: $email, ')
          ..write('telefono: $telefono, ')
          ..write('carrera: $carrera, ')
          ..write('grupo: $grupo, ')
          ..write('estado: $estado, ')
          ..write('fechaIngreso: $fechaIngreso, ')
          ..write('fechaCreacion: $fechaCreacion')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CareersTable careers = $CareersTable(this);
  late final $ClassGroupsTable classGroups = $ClassGroupsTable(this);
  late final $ModulesTable modules = $ModulesTable(this);
  late final $UnitsTable units = $UnitsTable(this);
  late final $ActivitiesTable activities = $ActivitiesTable(this);
  late final $BitacorasTable bitacoras = $BitacorasTable(this);
  late final $CalendarioBitacorasTable calendarioBitacoras =
      $CalendarioBitacorasTable(this);
  late final $StudentsTable students = $StudentsTable(this);
  late final CareerDao careerDao = CareerDao(this as AppDatabase);
  late final ClassGroupDao classGroupDao = ClassGroupDao(this as AppDatabase);
  late final ModuleDao moduleDao = ModuleDao(this as AppDatabase);
  late final UnitDao unitDao = UnitDao(this as AppDatabase);
  late final ActivityDao activityDao = ActivityDao(this as AppDatabase);
  late final BitacoraDao bitacoraDao = BitacoraDao(this as AppDatabase);
  late final StudentDao studentDao = StudentDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    careers,
    classGroups,
    modules,
    units,
    activities,
    bitacoras,
    calendarioBitacoras,
    students,
  ];
}

typedef $$CareersTableCreateCompanionBuilder =
    CareersCompanion Function({
      Value<int> id,
      required String nombre,
      required TipoCarrera tipoCarrera,
      Value<DateTime?> fechaCreacion,
    });
typedef $$CareersTableUpdateCompanionBuilder =
    CareersCompanion Function({
      Value<int> id,
      Value<String> nombre,
      Value<TipoCarrera> tipoCarrera,
      Value<DateTime?> fechaCreacion,
    });

final class $$CareersTableReferences
    extends BaseReferences<_$AppDatabase, $CareersTable, Career> {
  $$CareersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ClassGroupsTable, List<ClassGroup>>
  _classGroupsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.classGroups,
    aliasName: $_aliasNameGenerator(db.careers.nombre, db.classGroups.carrera),
  );

  $$ClassGroupsTableProcessedTableManager get classGroupsRefs {
    final manager = $$ClassGroupsTableTableManager($_db, $_db.classGroups)
        .filter(
          (f) => f.carrera.nombre.sqlEquals($_itemColumn<String>('nombre')!),
        );

    final cache = $_typedResult.readTableOrNull(_classGroupsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CareersTableFilterComposer
    extends Composer<_$AppDatabase, $CareersTable> {
  $$CareersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TipoCarrera, TipoCarrera, int>
  get tipoCarrera => $composableBuilder(
    column: $table.tipoCarrera,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get fechaCreacion => $composableBuilder(
    column: $table.fechaCreacion,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> classGroupsRefs(
    Expression<bool> Function($$ClassGroupsTableFilterComposer f) f,
  ) {
    final $$ClassGroupsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.nombre,
      referencedTable: $db.classGroups,
      getReferencedColumn: (t) => t.carrera,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClassGroupsTableFilterComposer(
            $db: $db,
            $table: $db.classGroups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CareersTableOrderingComposer
    extends Composer<_$AppDatabase, $CareersTable> {
  $$CareersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tipoCarrera => $composableBuilder(
    column: $table.tipoCarrera,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fechaCreacion => $composableBuilder(
    column: $table.fechaCreacion,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CareersTableAnnotationComposer
    extends Composer<_$AppDatabase, $CareersTable> {
  $$CareersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TipoCarrera, int> get tipoCarrera =>
      $composableBuilder(
        column: $table.tipoCarrera,
        builder: (column) => column,
      );

  GeneratedColumn<DateTime> get fechaCreacion => $composableBuilder(
    column: $table.fechaCreacion,
    builder: (column) => column,
  );

  Expression<T> classGroupsRefs<T extends Object>(
    Expression<T> Function($$ClassGroupsTableAnnotationComposer a) f,
  ) {
    final $$ClassGroupsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.nombre,
      referencedTable: $db.classGroups,
      getReferencedColumn: (t) => t.carrera,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClassGroupsTableAnnotationComposer(
            $db: $db,
            $table: $db.classGroups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CareersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CareersTable,
          Career,
          $$CareersTableFilterComposer,
          $$CareersTableOrderingComposer,
          $$CareersTableAnnotationComposer,
          $$CareersTableCreateCompanionBuilder,
          $$CareersTableUpdateCompanionBuilder,
          (Career, $$CareersTableReferences),
          Career,
          PrefetchHooks Function({bool classGroupsRefs})
        > {
  $$CareersTableTableManager(_$AppDatabase db, $CareersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CareersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CareersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CareersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<TipoCarrera> tipoCarrera = const Value.absent(),
                Value<DateTime?> fechaCreacion = const Value.absent(),
              }) => CareersCompanion(
                id: id,
                nombre: nombre,
                tipoCarrera: tipoCarrera,
                fechaCreacion: fechaCreacion,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nombre,
                required TipoCarrera tipoCarrera,
                Value<DateTime?> fechaCreacion = const Value.absent(),
              }) => CareersCompanion.insert(
                id: id,
                nombre: nombre,
                tipoCarrera: tipoCarrera,
                fechaCreacion: fechaCreacion,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CareersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({classGroupsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (classGroupsRefs) db.classGroups],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (classGroupsRefs)
                    await $_getPrefetchedData<
                      Career,
                      $CareersTable,
                      ClassGroup
                    >(
                      currentTable: table,
                      referencedTable: $$CareersTableReferences
                          ._classGroupsRefsTable(db),
                      managerFromTypedResult: (p0) => $$CareersTableReferences(
                        db,
                        table,
                        p0,
                      ).classGroupsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.carrera == item.nombre,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$CareersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CareersTable,
      Career,
      $$CareersTableFilterComposer,
      $$CareersTableOrderingComposer,
      $$CareersTableAnnotationComposer,
      $$CareersTableCreateCompanionBuilder,
      $$CareersTableUpdateCompanionBuilder,
      (Career, $$CareersTableReferences),
      Career,
      PrefetchHooks Function({bool classGroupsRefs})
    >;
typedef $$ClassGroupsTableCreateCompanionBuilder =
    ClassGroupsCompanion Function({
      Value<int> id,
      required String codigo,
      required String carrera,
      Value<String?> turno,
      Value<String?> ciclo,
      Value<EstadoGrupo> estado,
      Value<DateTime?> fechaInicio,
      Value<DateTime?> fechaFin,
      Value<DateTime?> fechaCreacion,
    });
typedef $$ClassGroupsTableUpdateCompanionBuilder =
    ClassGroupsCompanion Function({
      Value<int> id,
      Value<String> codigo,
      Value<String> carrera,
      Value<String?> turno,
      Value<String?> ciclo,
      Value<EstadoGrupo> estado,
      Value<DateTime?> fechaInicio,
      Value<DateTime?> fechaFin,
      Value<DateTime?> fechaCreacion,
    });

final class $$ClassGroupsTableReferences
    extends BaseReferences<_$AppDatabase, $ClassGroupsTable, ClassGroup> {
  $$ClassGroupsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CareersTable _carreraTable(_$AppDatabase db) =>
      db.careers.createAlias(
        $_aliasNameGenerator(db.classGroups.carrera, db.careers.nombre),
      );

  $$CareersTableProcessedTableManager get carrera {
    final $_column = $_itemColumn<String>('carrera')!;

    final manager = $$CareersTableTableManager(
      $_db,
      $_db.careers,
    ).filter((f) => f.nombre.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_carreraTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ClassGroupsTableFilterComposer
    extends Composer<_$AppDatabase, $ClassGroupsTable> {
  $$ClassGroupsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get codigo => $composableBuilder(
    column: $table.codigo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get turno => $composableBuilder(
    column: $table.turno,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ciclo => $composableBuilder(
    column: $table.ciclo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<EstadoGrupo, EstadoGrupo, int> get estado =>
      $composableBuilder(
        column: $table.estado,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<DateTime> get fechaInicio => $composableBuilder(
    column: $table.fechaInicio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fechaFin => $composableBuilder(
    column: $table.fechaFin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fechaCreacion => $composableBuilder(
    column: $table.fechaCreacion,
    builder: (column) => ColumnFilters(column),
  );

  $$CareersTableFilterComposer get carrera {
    final $$CareersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.carrera,
      referencedTable: $db.careers,
      getReferencedColumn: (t) => t.nombre,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CareersTableFilterComposer(
            $db: $db,
            $table: $db.careers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ClassGroupsTableOrderingComposer
    extends Composer<_$AppDatabase, $ClassGroupsTable> {
  $$ClassGroupsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get codigo => $composableBuilder(
    column: $table.codigo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get turno => $composableBuilder(
    column: $table.turno,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ciclo => $composableBuilder(
    column: $table.ciclo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get estado => $composableBuilder(
    column: $table.estado,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fechaInicio => $composableBuilder(
    column: $table.fechaInicio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fechaFin => $composableBuilder(
    column: $table.fechaFin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fechaCreacion => $composableBuilder(
    column: $table.fechaCreacion,
    builder: (column) => ColumnOrderings(column),
  );

  $$CareersTableOrderingComposer get carrera {
    final $$CareersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.carrera,
      referencedTable: $db.careers,
      getReferencedColumn: (t) => t.nombre,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CareersTableOrderingComposer(
            $db: $db,
            $table: $db.careers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ClassGroupsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ClassGroupsTable> {
  $$ClassGroupsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get codigo =>
      $composableBuilder(column: $table.codigo, builder: (column) => column);

  GeneratedColumn<String> get turno =>
      $composableBuilder(column: $table.turno, builder: (column) => column);

  GeneratedColumn<String> get ciclo =>
      $composableBuilder(column: $table.ciclo, builder: (column) => column);

  GeneratedColumnWithTypeConverter<EstadoGrupo, int> get estado =>
      $composableBuilder(column: $table.estado, builder: (column) => column);

  GeneratedColumn<DateTime> get fechaInicio => $composableBuilder(
    column: $table.fechaInicio,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get fechaFin =>
      $composableBuilder(column: $table.fechaFin, builder: (column) => column);

  GeneratedColumn<DateTime> get fechaCreacion => $composableBuilder(
    column: $table.fechaCreacion,
    builder: (column) => column,
  );

  $$CareersTableAnnotationComposer get carrera {
    final $$CareersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.carrera,
      referencedTable: $db.careers,
      getReferencedColumn: (t) => t.nombre,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CareersTableAnnotationComposer(
            $db: $db,
            $table: $db.careers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ClassGroupsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ClassGroupsTable,
          ClassGroup,
          $$ClassGroupsTableFilterComposer,
          $$ClassGroupsTableOrderingComposer,
          $$ClassGroupsTableAnnotationComposer,
          $$ClassGroupsTableCreateCompanionBuilder,
          $$ClassGroupsTableUpdateCompanionBuilder,
          (ClassGroup, $$ClassGroupsTableReferences),
          ClassGroup,
          PrefetchHooks Function({bool carrera})
        > {
  $$ClassGroupsTableTableManager(_$AppDatabase db, $ClassGroupsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ClassGroupsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ClassGroupsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ClassGroupsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> codigo = const Value.absent(),
                Value<String> carrera = const Value.absent(),
                Value<String?> turno = const Value.absent(),
                Value<String?> ciclo = const Value.absent(),
                Value<EstadoGrupo> estado = const Value.absent(),
                Value<DateTime?> fechaInicio = const Value.absent(),
                Value<DateTime?> fechaFin = const Value.absent(),
                Value<DateTime?> fechaCreacion = const Value.absent(),
              }) => ClassGroupsCompanion(
                id: id,
                codigo: codigo,
                carrera: carrera,
                turno: turno,
                ciclo: ciclo,
                estado: estado,
                fechaInicio: fechaInicio,
                fechaFin: fechaFin,
                fechaCreacion: fechaCreacion,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String codigo,
                required String carrera,
                Value<String?> turno = const Value.absent(),
                Value<String?> ciclo = const Value.absent(),
                Value<EstadoGrupo> estado = const Value.absent(),
                Value<DateTime?> fechaInicio = const Value.absent(),
                Value<DateTime?> fechaFin = const Value.absent(),
                Value<DateTime?> fechaCreacion = const Value.absent(),
              }) => ClassGroupsCompanion.insert(
                id: id,
                codigo: codigo,
                carrera: carrera,
                turno: turno,
                ciclo: ciclo,
                estado: estado,
                fechaInicio: fechaInicio,
                fechaFin: fechaFin,
                fechaCreacion: fechaCreacion,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ClassGroupsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({carrera = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (carrera) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.carrera,
                                referencedTable: $$ClassGroupsTableReferences
                                    ._carreraTable(db),
                                referencedColumn: $$ClassGroupsTableReferences
                                    ._carreraTable(db)
                                    .nombre,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ClassGroupsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ClassGroupsTable,
      ClassGroup,
      $$ClassGroupsTableFilterComposer,
      $$ClassGroupsTableOrderingComposer,
      $$ClassGroupsTableAnnotationComposer,
      $$ClassGroupsTableCreateCompanionBuilder,
      $$ClassGroupsTableUpdateCompanionBuilder,
      (ClassGroup, $$ClassGroupsTableReferences),
      ClassGroup,
      PrefetchHooks Function({bool carrera})
    >;
typedef $$ModulesTableCreateCompanionBuilder =
    ModulesCompanion Function({
      required String codModule,
      required String nombre,
      required int totalHoraAcademic,
      required int totalHoraReloj,
      Value<String?> carrera,
      Value<DateTime?> fechaCreacion,
      Value<int> rowid,
    });
typedef $$ModulesTableUpdateCompanionBuilder =
    ModulesCompanion Function({
      Value<String> codModule,
      Value<String> nombre,
      Value<int> totalHoraAcademic,
      Value<int> totalHoraReloj,
      Value<String?> carrera,
      Value<DateTime?> fechaCreacion,
      Value<int> rowid,
    });

final class $$ModulesTableReferences
    extends BaseReferences<_$AppDatabase, $ModulesTable, Module> {
  $$ModulesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$UnitsTable, List<Unit>> _unitsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.units,
    aliasName: $_aliasNameGenerator(db.modules.codModule, db.units.idModule),
  );

  $$UnitsTableProcessedTableManager get unitsRefs {
    final manager = $$UnitsTableTableManager($_db, $_db.units).filter(
      (f) =>
          f.idModule.codModule.sqlEquals($_itemColumn<String>('cod_module')!),
    );

    final cache = $_typedResult.readTableOrNull(_unitsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$BitacorasTable, List<Bitacora>>
  _bitacorasRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.bitacoras,
    aliasName: $_aliasNameGenerator(
      db.modules.codModule,
      db.bitacoras.idModule,
    ),
  );

  $$BitacorasTableProcessedTableManager get bitacorasRefs {
    final manager = $$BitacorasTableTableManager($_db, $_db.bitacoras).filter(
      (f) =>
          f.idModule.codModule.sqlEquals($_itemColumn<String>('cod_module')!),
    );

    final cache = $_typedResult.readTableOrNull(_bitacorasRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ModulesTableFilterComposer
    extends Composer<_$AppDatabase, $ModulesTable> {
  $$ModulesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get codModule => $composableBuilder(
    column: $table.codModule,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalHoraAcademic => $composableBuilder(
    column: $table.totalHoraAcademic,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalHoraReloj => $composableBuilder(
    column: $table.totalHoraReloj,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get carrera => $composableBuilder(
    column: $table.carrera,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fechaCreacion => $composableBuilder(
    column: $table.fechaCreacion,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> unitsRefs(
    Expression<bool> Function($$UnitsTableFilterComposer f) f,
  ) {
    final $$UnitsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.codModule,
      referencedTable: $db.units,
      getReferencedColumn: (t) => t.idModule,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UnitsTableFilterComposer(
            $db: $db,
            $table: $db.units,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> bitacorasRefs(
    Expression<bool> Function($$BitacorasTableFilterComposer f) f,
  ) {
    final $$BitacorasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.codModule,
      referencedTable: $db.bitacoras,
      getReferencedColumn: (t) => t.idModule,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BitacorasTableFilterComposer(
            $db: $db,
            $table: $db.bitacoras,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ModulesTableOrderingComposer
    extends Composer<_$AppDatabase, $ModulesTable> {
  $$ModulesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get codModule => $composableBuilder(
    column: $table.codModule,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalHoraAcademic => $composableBuilder(
    column: $table.totalHoraAcademic,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalHoraReloj => $composableBuilder(
    column: $table.totalHoraReloj,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get carrera => $composableBuilder(
    column: $table.carrera,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fechaCreacion => $composableBuilder(
    column: $table.fechaCreacion,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ModulesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ModulesTable> {
  $$ModulesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get codModule =>
      $composableBuilder(column: $table.codModule, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<int> get totalHoraAcademic => $composableBuilder(
    column: $table.totalHoraAcademic,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalHoraReloj => $composableBuilder(
    column: $table.totalHoraReloj,
    builder: (column) => column,
  );

  GeneratedColumn<String> get carrera =>
      $composableBuilder(column: $table.carrera, builder: (column) => column);

  GeneratedColumn<DateTime> get fechaCreacion => $composableBuilder(
    column: $table.fechaCreacion,
    builder: (column) => column,
  );

  Expression<T> unitsRefs<T extends Object>(
    Expression<T> Function($$UnitsTableAnnotationComposer a) f,
  ) {
    final $$UnitsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.codModule,
      referencedTable: $db.units,
      getReferencedColumn: (t) => t.idModule,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UnitsTableAnnotationComposer(
            $db: $db,
            $table: $db.units,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> bitacorasRefs<T extends Object>(
    Expression<T> Function($$BitacorasTableAnnotationComposer a) f,
  ) {
    final $$BitacorasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.codModule,
      referencedTable: $db.bitacoras,
      getReferencedColumn: (t) => t.idModule,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BitacorasTableAnnotationComposer(
            $db: $db,
            $table: $db.bitacoras,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ModulesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ModulesTable,
          Module,
          $$ModulesTableFilterComposer,
          $$ModulesTableOrderingComposer,
          $$ModulesTableAnnotationComposer,
          $$ModulesTableCreateCompanionBuilder,
          $$ModulesTableUpdateCompanionBuilder,
          (Module, $$ModulesTableReferences),
          Module,
          PrefetchHooks Function({bool unitsRefs, bool bitacorasRefs})
        > {
  $$ModulesTableTableManager(_$AppDatabase db, $ModulesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ModulesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ModulesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ModulesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> codModule = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<int> totalHoraAcademic = const Value.absent(),
                Value<int> totalHoraReloj = const Value.absent(),
                Value<String?> carrera = const Value.absent(),
                Value<DateTime?> fechaCreacion = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ModulesCompanion(
                codModule: codModule,
                nombre: nombre,
                totalHoraAcademic: totalHoraAcademic,
                totalHoraReloj: totalHoraReloj,
                carrera: carrera,
                fechaCreacion: fechaCreacion,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String codModule,
                required String nombre,
                required int totalHoraAcademic,
                required int totalHoraReloj,
                Value<String?> carrera = const Value.absent(),
                Value<DateTime?> fechaCreacion = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ModulesCompanion.insert(
                codModule: codModule,
                nombre: nombre,
                totalHoraAcademic: totalHoraAcademic,
                totalHoraReloj: totalHoraReloj,
                carrera: carrera,
                fechaCreacion: fechaCreacion,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ModulesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({unitsRefs = false, bitacorasRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (unitsRefs) db.units,
                if (bitacorasRefs) db.bitacoras,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (unitsRefs)
                    await $_getPrefetchedData<Module, $ModulesTable, Unit>(
                      currentTable: table,
                      referencedTable: $$ModulesTableReferences._unitsRefsTable(
                        db,
                      ),
                      managerFromTypedResult: (p0) =>
                          $$ModulesTableReferences(db, table, p0).unitsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.idModule == item.codModule,
                          ),
                      typedResults: items,
                    ),
                  if (bitacorasRefs)
                    await $_getPrefetchedData<Module, $ModulesTable, Bitacora>(
                      currentTable: table,
                      referencedTable: $$ModulesTableReferences
                          ._bitacorasRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$ModulesTableReferences(db, table, p0).bitacorasRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.idModule == item.codModule,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ModulesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ModulesTable,
      Module,
      $$ModulesTableFilterComposer,
      $$ModulesTableOrderingComposer,
      $$ModulesTableAnnotationComposer,
      $$ModulesTableCreateCompanionBuilder,
      $$ModulesTableUpdateCompanionBuilder,
      (Module, $$ModulesTableReferences),
      Module,
      PrefetchHooks Function({bool unitsRefs, bool bitacorasRefs})
    >;
typedef $$UnitsTableCreateCompanionBuilder =
    UnitsCompanion Function({
      required String codUnit,
      required String nombre,
      required int totalHoraAcademic,
      required int totalHoraReloj,
      required double ponderacion,
      required String idModule,
      Value<int> rowid,
    });
typedef $$UnitsTableUpdateCompanionBuilder =
    UnitsCompanion Function({
      Value<String> codUnit,
      Value<String> nombre,
      Value<int> totalHoraAcademic,
      Value<int> totalHoraReloj,
      Value<double> ponderacion,
      Value<String> idModule,
      Value<int> rowid,
    });

final class $$UnitsTableReferences
    extends BaseReferences<_$AppDatabase, $UnitsTable, Unit> {
  $$UnitsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ModulesTable _idModuleTable(_$AppDatabase db) =>
      db.modules.createAlias(
        $_aliasNameGenerator(db.units.idModule, db.modules.codModule),
      );

  $$ModulesTableProcessedTableManager get idModule {
    final $_column = $_itemColumn<String>('id_module')!;

    final manager = $$ModulesTableTableManager(
      $_db,
      $_db.modules,
    ).filter((f) => f.codModule.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_idModuleTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ActivitiesTable, List<Activity>>
  _activitiesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.activities,
    aliasName: $_aliasNameGenerator(db.units.codUnit, db.activities.idUnit),
  );

  $$ActivitiesTableProcessedTableManager get activitiesRefs {
    final manager = $$ActivitiesTableTableManager($_db, $_db.activities).filter(
      (f) => f.idUnit.codUnit.sqlEquals($_itemColumn<String>('cod_unit')!),
    );

    final cache = $_typedResult.readTableOrNull(_activitiesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$UnitsTableFilterComposer extends Composer<_$AppDatabase, $UnitsTable> {
  $$UnitsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get codUnit => $composableBuilder(
    column: $table.codUnit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalHoraAcademic => $composableBuilder(
    column: $table.totalHoraAcademic,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalHoraReloj => $composableBuilder(
    column: $table.totalHoraReloj,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get ponderacion => $composableBuilder(
    column: $table.ponderacion,
    builder: (column) => ColumnFilters(column),
  );

  $$ModulesTableFilterComposer get idModule {
    final $$ModulesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idModule,
      referencedTable: $db.modules,
      getReferencedColumn: (t) => t.codModule,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ModulesTableFilterComposer(
            $db: $db,
            $table: $db.modules,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> activitiesRefs(
    Expression<bool> Function($$ActivitiesTableFilterComposer f) f,
  ) {
    final $$ActivitiesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.codUnit,
      referencedTable: $db.activities,
      getReferencedColumn: (t) => t.idUnit,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActivitiesTableFilterComposer(
            $db: $db,
            $table: $db.activities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$UnitsTableOrderingComposer
    extends Composer<_$AppDatabase, $UnitsTable> {
  $$UnitsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get codUnit => $composableBuilder(
    column: $table.codUnit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalHoraAcademic => $composableBuilder(
    column: $table.totalHoraAcademic,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalHoraReloj => $composableBuilder(
    column: $table.totalHoraReloj,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get ponderacion => $composableBuilder(
    column: $table.ponderacion,
    builder: (column) => ColumnOrderings(column),
  );

  $$ModulesTableOrderingComposer get idModule {
    final $$ModulesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idModule,
      referencedTable: $db.modules,
      getReferencedColumn: (t) => t.codModule,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ModulesTableOrderingComposer(
            $db: $db,
            $table: $db.modules,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$UnitsTableAnnotationComposer
    extends Composer<_$AppDatabase, $UnitsTable> {
  $$UnitsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get codUnit =>
      $composableBuilder(column: $table.codUnit, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<int> get totalHoraAcademic => $composableBuilder(
    column: $table.totalHoraAcademic,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalHoraReloj => $composableBuilder(
    column: $table.totalHoraReloj,
    builder: (column) => column,
  );

  GeneratedColumn<double> get ponderacion => $composableBuilder(
    column: $table.ponderacion,
    builder: (column) => column,
  );

  $$ModulesTableAnnotationComposer get idModule {
    final $$ModulesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idModule,
      referencedTable: $db.modules,
      getReferencedColumn: (t) => t.codModule,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ModulesTableAnnotationComposer(
            $db: $db,
            $table: $db.modules,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> activitiesRefs<T extends Object>(
    Expression<T> Function($$ActivitiesTableAnnotationComposer a) f,
  ) {
    final $$ActivitiesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.codUnit,
      referencedTable: $db.activities,
      getReferencedColumn: (t) => t.idUnit,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActivitiesTableAnnotationComposer(
            $db: $db,
            $table: $db.activities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$UnitsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UnitsTable,
          Unit,
          $$UnitsTableFilterComposer,
          $$UnitsTableOrderingComposer,
          $$UnitsTableAnnotationComposer,
          $$UnitsTableCreateCompanionBuilder,
          $$UnitsTableUpdateCompanionBuilder,
          (Unit, $$UnitsTableReferences),
          Unit,
          PrefetchHooks Function({bool idModule, bool activitiesRefs})
        > {
  $$UnitsTableTableManager(_$AppDatabase db, $UnitsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UnitsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UnitsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UnitsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> codUnit = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<int> totalHoraAcademic = const Value.absent(),
                Value<int> totalHoraReloj = const Value.absent(),
                Value<double> ponderacion = const Value.absent(),
                Value<String> idModule = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UnitsCompanion(
                codUnit: codUnit,
                nombre: nombre,
                totalHoraAcademic: totalHoraAcademic,
                totalHoraReloj: totalHoraReloj,
                ponderacion: ponderacion,
                idModule: idModule,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String codUnit,
                required String nombre,
                required int totalHoraAcademic,
                required int totalHoraReloj,
                required double ponderacion,
                required String idModule,
                Value<int> rowid = const Value.absent(),
              }) => UnitsCompanion.insert(
                codUnit: codUnit,
                nombre: nombre,
                totalHoraAcademic: totalHoraAcademic,
                totalHoraReloj: totalHoraReloj,
                ponderacion: ponderacion,
                idModule: idModule,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$UnitsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({idModule = false, activitiesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (activitiesRefs) db.activities],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (idModule) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.idModule,
                                referencedTable: $$UnitsTableReferences
                                    ._idModuleTable(db),
                                referencedColumn: $$UnitsTableReferences
                                    ._idModuleTable(db)
                                    .codModule,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (activitiesRefs)
                    await $_getPrefetchedData<Unit, $UnitsTable, Activity>(
                      currentTable: table,
                      referencedTable: $$UnitsTableReferences
                          ._activitiesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$UnitsTableReferences(db, table, p0).activitiesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.idUnit == item.codUnit,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$UnitsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UnitsTable,
      Unit,
      $$UnitsTableFilterComposer,
      $$UnitsTableOrderingComposer,
      $$UnitsTableAnnotationComposer,
      $$UnitsTableCreateCompanionBuilder,
      $$UnitsTableUpdateCompanionBuilder,
      (Unit, $$UnitsTableReferences),
      Unit,
      PrefetchHooks Function({bool idModule, bool activitiesRefs})
    >;
typedef $$ActivitiesTableCreateCompanionBuilder =
    ActivitiesCompanion Function({
      required String codActivity,
      required String descripcion,
      required int totalHoraAcademic,
      required int totalHoraReloj,
      required String idUnit,
      Value<int> rowid,
    });
typedef $$ActivitiesTableUpdateCompanionBuilder =
    ActivitiesCompanion Function({
      Value<String> codActivity,
      Value<String> descripcion,
      Value<int> totalHoraAcademic,
      Value<int> totalHoraReloj,
      Value<String> idUnit,
      Value<int> rowid,
    });

final class $$ActivitiesTableReferences
    extends BaseReferences<_$AppDatabase, $ActivitiesTable, Activity> {
  $$ActivitiesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UnitsTable _idUnitTable(_$AppDatabase db) => db.units.createAlias(
    $_aliasNameGenerator(db.activities.idUnit, db.units.codUnit),
  );

  $$UnitsTableProcessedTableManager get idUnit {
    final $_column = $_itemColumn<String>('id_unit')!;

    final manager = $$UnitsTableTableManager(
      $_db,
      $_db.units,
    ).filter((f) => f.codUnit.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_idUnitTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ActivitiesTableFilterComposer
    extends Composer<_$AppDatabase, $ActivitiesTable> {
  $$ActivitiesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get codActivity => $composableBuilder(
    column: $table.codActivity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalHoraAcademic => $composableBuilder(
    column: $table.totalHoraAcademic,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalHoraReloj => $composableBuilder(
    column: $table.totalHoraReloj,
    builder: (column) => ColumnFilters(column),
  );

  $$UnitsTableFilterComposer get idUnit {
    final $$UnitsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idUnit,
      referencedTable: $db.units,
      getReferencedColumn: (t) => t.codUnit,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UnitsTableFilterComposer(
            $db: $db,
            $table: $db.units,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ActivitiesTableOrderingComposer
    extends Composer<_$AppDatabase, $ActivitiesTable> {
  $$ActivitiesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get codActivity => $composableBuilder(
    column: $table.codActivity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalHoraAcademic => $composableBuilder(
    column: $table.totalHoraAcademic,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalHoraReloj => $composableBuilder(
    column: $table.totalHoraReloj,
    builder: (column) => ColumnOrderings(column),
  );

  $$UnitsTableOrderingComposer get idUnit {
    final $$UnitsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idUnit,
      referencedTable: $db.units,
      getReferencedColumn: (t) => t.codUnit,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UnitsTableOrderingComposer(
            $db: $db,
            $table: $db.units,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ActivitiesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ActivitiesTable> {
  $$ActivitiesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get codActivity => $composableBuilder(
    column: $table.codActivity,
    builder: (column) => column,
  );

  GeneratedColumn<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalHoraAcademic => $composableBuilder(
    column: $table.totalHoraAcademic,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalHoraReloj => $composableBuilder(
    column: $table.totalHoraReloj,
    builder: (column) => column,
  );

  $$UnitsTableAnnotationComposer get idUnit {
    final $$UnitsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idUnit,
      referencedTable: $db.units,
      getReferencedColumn: (t) => t.codUnit,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UnitsTableAnnotationComposer(
            $db: $db,
            $table: $db.units,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ActivitiesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ActivitiesTable,
          Activity,
          $$ActivitiesTableFilterComposer,
          $$ActivitiesTableOrderingComposer,
          $$ActivitiesTableAnnotationComposer,
          $$ActivitiesTableCreateCompanionBuilder,
          $$ActivitiesTableUpdateCompanionBuilder,
          (Activity, $$ActivitiesTableReferences),
          Activity,
          PrefetchHooks Function({bool idUnit})
        > {
  $$ActivitiesTableTableManager(_$AppDatabase db, $ActivitiesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ActivitiesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ActivitiesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ActivitiesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> codActivity = const Value.absent(),
                Value<String> descripcion = const Value.absent(),
                Value<int> totalHoraAcademic = const Value.absent(),
                Value<int> totalHoraReloj = const Value.absent(),
                Value<String> idUnit = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ActivitiesCompanion(
                codActivity: codActivity,
                descripcion: descripcion,
                totalHoraAcademic: totalHoraAcademic,
                totalHoraReloj: totalHoraReloj,
                idUnit: idUnit,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String codActivity,
                required String descripcion,
                required int totalHoraAcademic,
                required int totalHoraReloj,
                required String idUnit,
                Value<int> rowid = const Value.absent(),
              }) => ActivitiesCompanion.insert(
                codActivity: codActivity,
                descripcion: descripcion,
                totalHoraAcademic: totalHoraAcademic,
                totalHoraReloj: totalHoraReloj,
                idUnit: idUnit,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ActivitiesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({idUnit = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (idUnit) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.idUnit,
                                referencedTable: $$ActivitiesTableReferences
                                    ._idUnitTable(db),
                                referencedColumn: $$ActivitiesTableReferences
                                    ._idUnitTable(db)
                                    .codUnit,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ActivitiesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ActivitiesTable,
      Activity,
      $$ActivitiesTableFilterComposer,
      $$ActivitiesTableOrderingComposer,
      $$ActivitiesTableAnnotationComposer,
      $$ActivitiesTableCreateCompanionBuilder,
      $$ActivitiesTableUpdateCompanionBuilder,
      (Activity, $$ActivitiesTableReferences),
      Activity,
      PrefetchHooks Function({bool idUnit})
    >;
typedef $$BitacorasTableCreateCompanionBuilder =
    BitacorasCompanion Function({
      Value<int> id,
      required int frecuenciaClase,
      required DateTime fechaInicio,
      Value<DateTime?> fechaFinal,
      Value<bool> usarHorasReloj,
      required List<String> fechasFeriadas,
      required List<String> diasClase,
      Value<String?> codigoGrupo,
      required String carrera,
      required TipoCarrera tipoCarrera,
      required EstadoBitacora estado,
      Value<String?> turno,
      required String idModule,
    });
typedef $$BitacorasTableUpdateCompanionBuilder =
    BitacorasCompanion Function({
      Value<int> id,
      Value<int> frecuenciaClase,
      Value<DateTime> fechaInicio,
      Value<DateTime?> fechaFinal,
      Value<bool> usarHorasReloj,
      Value<List<String>> fechasFeriadas,
      Value<List<String>> diasClase,
      Value<String?> codigoGrupo,
      Value<String> carrera,
      Value<TipoCarrera> tipoCarrera,
      Value<EstadoBitacora> estado,
      Value<String?> turno,
      Value<String> idModule,
    });

final class $$BitacorasTableReferences
    extends BaseReferences<_$AppDatabase, $BitacorasTable, Bitacora> {
  $$BitacorasTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ModulesTable _idModuleTable(_$AppDatabase db) =>
      db.modules.createAlias(
        $_aliasNameGenerator(db.bitacoras.idModule, db.modules.codModule),
      );

  $$ModulesTableProcessedTableManager get idModule {
    final $_column = $_itemColumn<String>('id_module')!;

    final manager = $$ModulesTableTableManager(
      $_db,
      $_db.modules,
    ).filter((f) => f.codModule.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_idModuleTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $CalendarioBitacorasTable,
    List<CalendarioBitacora>
  >
  _calendarioBitacorasRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.calendarioBitacoras,
        aliasName: $_aliasNameGenerator(
          db.bitacoras.id,
          db.calendarioBitacoras.idBitacora,
        ),
      );

  $$CalendarioBitacorasTableProcessedTableManager get calendarioBitacorasRefs {
    final manager = $$CalendarioBitacorasTableTableManager(
      $_db,
      $_db.calendarioBitacoras,
    ).filter((f) => f.idBitacora.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _calendarioBitacorasRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$BitacorasTableFilterComposer
    extends Composer<_$AppDatabase, $BitacorasTable> {
  $$BitacorasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get frecuenciaClase => $composableBuilder(
    column: $table.frecuenciaClase,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fechaInicio => $composableBuilder(
    column: $table.fechaInicio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fechaFinal => $composableBuilder(
    column: $table.fechaFinal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get usarHorasReloj => $composableBuilder(
    column: $table.usarHorasReloj,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
  get fechasFeriadas => $composableBuilder(
    column: $table.fechasFeriadas,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
  get diasClase => $composableBuilder(
    column: $table.diasClase,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get codigoGrupo => $composableBuilder(
    column: $table.codigoGrupo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get carrera => $composableBuilder(
    column: $table.carrera,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TipoCarrera, TipoCarrera, int>
  get tipoCarrera => $composableBuilder(
    column: $table.tipoCarrera,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<EstadoBitacora, EstadoBitacora, int>
  get estado => $composableBuilder(
    column: $table.estado,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get turno => $composableBuilder(
    column: $table.turno,
    builder: (column) => ColumnFilters(column),
  );

  $$ModulesTableFilterComposer get idModule {
    final $$ModulesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idModule,
      referencedTable: $db.modules,
      getReferencedColumn: (t) => t.codModule,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ModulesTableFilterComposer(
            $db: $db,
            $table: $db.modules,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> calendarioBitacorasRefs(
    Expression<bool> Function($$CalendarioBitacorasTableFilterComposer f) f,
  ) {
    final $$CalendarioBitacorasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.calendarioBitacoras,
      getReferencedColumn: (t) => t.idBitacora,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CalendarioBitacorasTableFilterComposer(
            $db: $db,
            $table: $db.calendarioBitacoras,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BitacorasTableOrderingComposer
    extends Composer<_$AppDatabase, $BitacorasTable> {
  $$BitacorasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get frecuenciaClase => $composableBuilder(
    column: $table.frecuenciaClase,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fechaInicio => $composableBuilder(
    column: $table.fechaInicio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fechaFinal => $composableBuilder(
    column: $table.fechaFinal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get usarHorasReloj => $composableBuilder(
    column: $table.usarHorasReloj,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fechasFeriadas => $composableBuilder(
    column: $table.fechasFeriadas,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get diasClase => $composableBuilder(
    column: $table.diasClase,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get codigoGrupo => $composableBuilder(
    column: $table.codigoGrupo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get carrera => $composableBuilder(
    column: $table.carrera,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tipoCarrera => $composableBuilder(
    column: $table.tipoCarrera,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get estado => $composableBuilder(
    column: $table.estado,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get turno => $composableBuilder(
    column: $table.turno,
    builder: (column) => ColumnOrderings(column),
  );

  $$ModulesTableOrderingComposer get idModule {
    final $$ModulesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idModule,
      referencedTable: $db.modules,
      getReferencedColumn: (t) => t.codModule,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ModulesTableOrderingComposer(
            $db: $db,
            $table: $db.modules,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BitacorasTableAnnotationComposer
    extends Composer<_$AppDatabase, $BitacorasTable> {
  $$BitacorasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get frecuenciaClase => $composableBuilder(
    column: $table.frecuenciaClase,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get fechaInicio => $composableBuilder(
    column: $table.fechaInicio,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get fechaFinal => $composableBuilder(
    column: $table.fechaFinal,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get usarHorasReloj => $composableBuilder(
    column: $table.usarHorasReloj,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<List<String>, String> get fechasFeriadas =>
      $composableBuilder(
        column: $table.fechasFeriadas,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<List<String>, String> get diasClase =>
      $composableBuilder(column: $table.diasClase, builder: (column) => column);

  GeneratedColumn<String> get codigoGrupo => $composableBuilder(
    column: $table.codigoGrupo,
    builder: (column) => column,
  );

  GeneratedColumn<String> get carrera =>
      $composableBuilder(column: $table.carrera, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TipoCarrera, int> get tipoCarrera =>
      $composableBuilder(
        column: $table.tipoCarrera,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<EstadoBitacora, int> get estado =>
      $composableBuilder(column: $table.estado, builder: (column) => column);

  GeneratedColumn<String> get turno =>
      $composableBuilder(column: $table.turno, builder: (column) => column);

  $$ModulesTableAnnotationComposer get idModule {
    final $$ModulesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idModule,
      referencedTable: $db.modules,
      getReferencedColumn: (t) => t.codModule,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ModulesTableAnnotationComposer(
            $db: $db,
            $table: $db.modules,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> calendarioBitacorasRefs<T extends Object>(
    Expression<T> Function($$CalendarioBitacorasTableAnnotationComposer a) f,
  ) {
    final $$CalendarioBitacorasTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.calendarioBitacoras,
          getReferencedColumn: (t) => t.idBitacora,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CalendarioBitacorasTableAnnotationComposer(
                $db: $db,
                $table: $db.calendarioBitacoras,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$BitacorasTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BitacorasTable,
          Bitacora,
          $$BitacorasTableFilterComposer,
          $$BitacorasTableOrderingComposer,
          $$BitacorasTableAnnotationComposer,
          $$BitacorasTableCreateCompanionBuilder,
          $$BitacorasTableUpdateCompanionBuilder,
          (Bitacora, $$BitacorasTableReferences),
          Bitacora,
          PrefetchHooks Function({bool idModule, bool calendarioBitacorasRefs})
        > {
  $$BitacorasTableTableManager(_$AppDatabase db, $BitacorasTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BitacorasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BitacorasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BitacorasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> frecuenciaClase = const Value.absent(),
                Value<DateTime> fechaInicio = const Value.absent(),
                Value<DateTime?> fechaFinal = const Value.absent(),
                Value<bool> usarHorasReloj = const Value.absent(),
                Value<List<String>> fechasFeriadas = const Value.absent(),
                Value<List<String>> diasClase = const Value.absent(),
                Value<String?> codigoGrupo = const Value.absent(),
                Value<String> carrera = const Value.absent(),
                Value<TipoCarrera> tipoCarrera = const Value.absent(),
                Value<EstadoBitacora> estado = const Value.absent(),
                Value<String?> turno = const Value.absent(),
                Value<String> idModule = const Value.absent(),
              }) => BitacorasCompanion(
                id: id,
                frecuenciaClase: frecuenciaClase,
                fechaInicio: fechaInicio,
                fechaFinal: fechaFinal,
                usarHorasReloj: usarHorasReloj,
                fechasFeriadas: fechasFeriadas,
                diasClase: diasClase,
                codigoGrupo: codigoGrupo,
                carrera: carrera,
                tipoCarrera: tipoCarrera,
                estado: estado,
                turno: turno,
                idModule: idModule,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int frecuenciaClase,
                required DateTime fechaInicio,
                Value<DateTime?> fechaFinal = const Value.absent(),
                Value<bool> usarHorasReloj = const Value.absent(),
                required List<String> fechasFeriadas,
                required List<String> diasClase,
                Value<String?> codigoGrupo = const Value.absent(),
                required String carrera,
                required TipoCarrera tipoCarrera,
                required EstadoBitacora estado,
                Value<String?> turno = const Value.absent(),
                required String idModule,
              }) => BitacorasCompanion.insert(
                id: id,
                frecuenciaClase: frecuenciaClase,
                fechaInicio: fechaInicio,
                fechaFinal: fechaFinal,
                usarHorasReloj: usarHorasReloj,
                fechasFeriadas: fechasFeriadas,
                diasClase: diasClase,
                codigoGrupo: codigoGrupo,
                carrera: carrera,
                tipoCarrera: tipoCarrera,
                estado: estado,
                turno: turno,
                idModule: idModule,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$BitacorasTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({idModule = false, calendarioBitacorasRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (calendarioBitacorasRefs) db.calendarioBitacoras,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (idModule) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.idModule,
                                    referencedTable: $$BitacorasTableReferences
                                        ._idModuleTable(db),
                                    referencedColumn: $$BitacorasTableReferences
                                        ._idModuleTable(db)
                                        .codModule,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (calendarioBitacorasRefs)
                        await $_getPrefetchedData<
                          Bitacora,
                          $BitacorasTable,
                          CalendarioBitacora
                        >(
                          currentTable: table,
                          referencedTable: $$BitacorasTableReferences
                              ._calendarioBitacorasRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$BitacorasTableReferences(
                                db,
                                table,
                                p0,
                              ).calendarioBitacorasRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.idBitacora == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$BitacorasTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BitacorasTable,
      Bitacora,
      $$BitacorasTableFilterComposer,
      $$BitacorasTableOrderingComposer,
      $$BitacorasTableAnnotationComposer,
      $$BitacorasTableCreateCompanionBuilder,
      $$BitacorasTableUpdateCompanionBuilder,
      (Bitacora, $$BitacorasTableReferences),
      Bitacora,
      PrefetchHooks Function({bool idModule, bool calendarioBitacorasRefs})
    >;
typedef $$CalendarioBitacorasTableCreateCompanionBuilder =
    CalendarioBitacorasCompanion Function({
      Value<int> id,
      required int idBitacora,
      Value<String?> codUnidad,
      Value<String?> codActividad,
      Value<DateTime?> fechaProgramada,
      Value<bool> estadoImpartido,
      Value<int?> horaImpartir,
      Value<bool> esEvaluativa,
      Value<double?> puntaje,
      Value<String?> rutaDocumento,
    });
typedef $$CalendarioBitacorasTableUpdateCompanionBuilder =
    CalendarioBitacorasCompanion Function({
      Value<int> id,
      Value<int> idBitacora,
      Value<String?> codUnidad,
      Value<String?> codActividad,
      Value<DateTime?> fechaProgramada,
      Value<bool> estadoImpartido,
      Value<int?> horaImpartir,
      Value<bool> esEvaluativa,
      Value<double?> puntaje,
      Value<String?> rutaDocumento,
    });

final class $$CalendarioBitacorasTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $CalendarioBitacorasTable,
          CalendarioBitacora
        > {
  $$CalendarioBitacorasTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $BitacorasTable _idBitacoraTable(_$AppDatabase db) =>
      db.bitacoras.createAlias(
        $_aliasNameGenerator(
          db.calendarioBitacoras.idBitacora,
          db.bitacoras.id,
        ),
      );

  $$BitacorasTableProcessedTableManager get idBitacora {
    final $_column = $_itemColumn<int>('id_bitacora')!;

    final manager = $$BitacorasTableTableManager(
      $_db,
      $_db.bitacoras,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_idBitacoraTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CalendarioBitacorasTableFilterComposer
    extends Composer<_$AppDatabase, $CalendarioBitacorasTable> {
  $$CalendarioBitacorasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get codUnidad => $composableBuilder(
    column: $table.codUnidad,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get codActividad => $composableBuilder(
    column: $table.codActividad,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fechaProgramada => $composableBuilder(
    column: $table.fechaProgramada,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get estadoImpartido => $composableBuilder(
    column: $table.estadoImpartido,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get horaImpartir => $composableBuilder(
    column: $table.horaImpartir,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get esEvaluativa => $composableBuilder(
    column: $table.esEvaluativa,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get puntaje => $composableBuilder(
    column: $table.puntaje,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rutaDocumento => $composableBuilder(
    column: $table.rutaDocumento,
    builder: (column) => ColumnFilters(column),
  );

  $$BitacorasTableFilterComposer get idBitacora {
    final $$BitacorasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idBitacora,
      referencedTable: $db.bitacoras,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BitacorasTableFilterComposer(
            $db: $db,
            $table: $db.bitacoras,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CalendarioBitacorasTableOrderingComposer
    extends Composer<_$AppDatabase, $CalendarioBitacorasTable> {
  $$CalendarioBitacorasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get codUnidad => $composableBuilder(
    column: $table.codUnidad,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get codActividad => $composableBuilder(
    column: $table.codActividad,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fechaProgramada => $composableBuilder(
    column: $table.fechaProgramada,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get estadoImpartido => $composableBuilder(
    column: $table.estadoImpartido,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get horaImpartir => $composableBuilder(
    column: $table.horaImpartir,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get esEvaluativa => $composableBuilder(
    column: $table.esEvaluativa,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get puntaje => $composableBuilder(
    column: $table.puntaje,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rutaDocumento => $composableBuilder(
    column: $table.rutaDocumento,
    builder: (column) => ColumnOrderings(column),
  );

  $$BitacorasTableOrderingComposer get idBitacora {
    final $$BitacorasTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idBitacora,
      referencedTable: $db.bitacoras,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BitacorasTableOrderingComposer(
            $db: $db,
            $table: $db.bitacoras,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CalendarioBitacorasTableAnnotationComposer
    extends Composer<_$AppDatabase, $CalendarioBitacorasTable> {
  $$CalendarioBitacorasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get codUnidad =>
      $composableBuilder(column: $table.codUnidad, builder: (column) => column);

  GeneratedColumn<String> get codActividad => $composableBuilder(
    column: $table.codActividad,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get fechaProgramada => $composableBuilder(
    column: $table.fechaProgramada,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get estadoImpartido => $composableBuilder(
    column: $table.estadoImpartido,
    builder: (column) => column,
  );

  GeneratedColumn<int> get horaImpartir => $composableBuilder(
    column: $table.horaImpartir,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get esEvaluativa => $composableBuilder(
    column: $table.esEvaluativa,
    builder: (column) => column,
  );

  GeneratedColumn<double> get puntaje =>
      $composableBuilder(column: $table.puntaje, builder: (column) => column);

  GeneratedColumn<String> get rutaDocumento => $composableBuilder(
    column: $table.rutaDocumento,
    builder: (column) => column,
  );

  $$BitacorasTableAnnotationComposer get idBitacora {
    final $$BitacorasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idBitacora,
      referencedTable: $db.bitacoras,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BitacorasTableAnnotationComposer(
            $db: $db,
            $table: $db.bitacoras,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CalendarioBitacorasTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CalendarioBitacorasTable,
          CalendarioBitacora,
          $$CalendarioBitacorasTableFilterComposer,
          $$CalendarioBitacorasTableOrderingComposer,
          $$CalendarioBitacorasTableAnnotationComposer,
          $$CalendarioBitacorasTableCreateCompanionBuilder,
          $$CalendarioBitacorasTableUpdateCompanionBuilder,
          (CalendarioBitacora, $$CalendarioBitacorasTableReferences),
          CalendarioBitacora,
          PrefetchHooks Function({bool idBitacora})
        > {
  $$CalendarioBitacorasTableTableManager(
    _$AppDatabase db,
    $CalendarioBitacorasTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CalendarioBitacorasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CalendarioBitacorasTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$CalendarioBitacorasTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> idBitacora = const Value.absent(),
                Value<String?> codUnidad = const Value.absent(),
                Value<String?> codActividad = const Value.absent(),
                Value<DateTime?> fechaProgramada = const Value.absent(),
                Value<bool> estadoImpartido = const Value.absent(),
                Value<int?> horaImpartir = const Value.absent(),
                Value<bool> esEvaluativa = const Value.absent(),
                Value<double?> puntaje = const Value.absent(),
                Value<String?> rutaDocumento = const Value.absent(),
              }) => CalendarioBitacorasCompanion(
                id: id,
                idBitacora: idBitacora,
                codUnidad: codUnidad,
                codActividad: codActividad,
                fechaProgramada: fechaProgramada,
                estadoImpartido: estadoImpartido,
                horaImpartir: horaImpartir,
                esEvaluativa: esEvaluativa,
                puntaje: puntaje,
                rutaDocumento: rutaDocumento,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int idBitacora,
                Value<String?> codUnidad = const Value.absent(),
                Value<String?> codActividad = const Value.absent(),
                Value<DateTime?> fechaProgramada = const Value.absent(),
                Value<bool> estadoImpartido = const Value.absent(),
                Value<int?> horaImpartir = const Value.absent(),
                Value<bool> esEvaluativa = const Value.absent(),
                Value<double?> puntaje = const Value.absent(),
                Value<String?> rutaDocumento = const Value.absent(),
              }) => CalendarioBitacorasCompanion.insert(
                id: id,
                idBitacora: idBitacora,
                codUnidad: codUnidad,
                codActividad: codActividad,
                fechaProgramada: fechaProgramada,
                estadoImpartido: estadoImpartido,
                horaImpartir: horaImpartir,
                esEvaluativa: esEvaluativa,
                puntaje: puntaje,
                rutaDocumento: rutaDocumento,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CalendarioBitacorasTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({idBitacora = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (idBitacora) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.idBitacora,
                                referencedTable:
                                    $$CalendarioBitacorasTableReferences
                                        ._idBitacoraTable(db),
                                referencedColumn:
                                    $$CalendarioBitacorasTableReferences
                                        ._idBitacoraTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$CalendarioBitacorasTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CalendarioBitacorasTable,
      CalendarioBitacora,
      $$CalendarioBitacorasTableFilterComposer,
      $$CalendarioBitacorasTableOrderingComposer,
      $$CalendarioBitacorasTableAnnotationComposer,
      $$CalendarioBitacorasTableCreateCompanionBuilder,
      $$CalendarioBitacorasTableUpdateCompanionBuilder,
      (CalendarioBitacora, $$CalendarioBitacorasTableReferences),
      CalendarioBitacora,
      PrefetchHooks Function({bool idBitacora})
    >;
typedef $$StudentsTableCreateCompanionBuilder =
    StudentsCompanion Function({
      Value<int> id,
      required String codigo,
      required String nombres,
      required String apellidos,
      Value<String?> email,
      Value<String?> telefono,
      Value<String?> carrera,
      Value<String?> grupo,
      Value<StudentStatus> estado,
      Value<DateTime?> fechaIngreso,
      Value<DateTime?> fechaCreacion,
    });
typedef $$StudentsTableUpdateCompanionBuilder =
    StudentsCompanion Function({
      Value<int> id,
      Value<String> codigo,
      Value<String> nombres,
      Value<String> apellidos,
      Value<String?> email,
      Value<String?> telefono,
      Value<String?> carrera,
      Value<String?> grupo,
      Value<StudentStatus> estado,
      Value<DateTime?> fechaIngreso,
      Value<DateTime?> fechaCreacion,
    });

class $$StudentsTableFilterComposer
    extends Composer<_$AppDatabase, $StudentsTable> {
  $$StudentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get codigo => $composableBuilder(
    column: $table.codigo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombres => $composableBuilder(
    column: $table.nombres,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get apellidos => $composableBuilder(
    column: $table.apellidos,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get telefono => $composableBuilder(
    column: $table.telefono,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get carrera => $composableBuilder(
    column: $table.carrera,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get grupo => $composableBuilder(
    column: $table.grupo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<StudentStatus, StudentStatus, int>
  get estado => $composableBuilder(
    column: $table.estado,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get fechaIngreso => $composableBuilder(
    column: $table.fechaIngreso,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fechaCreacion => $composableBuilder(
    column: $table.fechaCreacion,
    builder: (column) => ColumnFilters(column),
  );
}

class $$StudentsTableOrderingComposer
    extends Composer<_$AppDatabase, $StudentsTable> {
  $$StudentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get codigo => $composableBuilder(
    column: $table.codigo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombres => $composableBuilder(
    column: $table.nombres,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get apellidos => $composableBuilder(
    column: $table.apellidos,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get telefono => $composableBuilder(
    column: $table.telefono,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get carrera => $composableBuilder(
    column: $table.carrera,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get grupo => $composableBuilder(
    column: $table.grupo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get estado => $composableBuilder(
    column: $table.estado,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fechaIngreso => $composableBuilder(
    column: $table.fechaIngreso,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fechaCreacion => $composableBuilder(
    column: $table.fechaCreacion,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StudentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StudentsTable> {
  $$StudentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get codigo =>
      $composableBuilder(column: $table.codigo, builder: (column) => column);

  GeneratedColumn<String> get nombres =>
      $composableBuilder(column: $table.nombres, builder: (column) => column);

  GeneratedColumn<String> get apellidos =>
      $composableBuilder(column: $table.apellidos, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get telefono =>
      $composableBuilder(column: $table.telefono, builder: (column) => column);

  GeneratedColumn<String> get carrera =>
      $composableBuilder(column: $table.carrera, builder: (column) => column);

  GeneratedColumn<String> get grupo =>
      $composableBuilder(column: $table.grupo, builder: (column) => column);

  GeneratedColumnWithTypeConverter<StudentStatus, int> get estado =>
      $composableBuilder(column: $table.estado, builder: (column) => column);

  GeneratedColumn<DateTime> get fechaIngreso => $composableBuilder(
    column: $table.fechaIngreso,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get fechaCreacion => $composableBuilder(
    column: $table.fechaCreacion,
    builder: (column) => column,
  );
}

class $$StudentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StudentsTable,
          Student,
          $$StudentsTableFilterComposer,
          $$StudentsTableOrderingComposer,
          $$StudentsTableAnnotationComposer,
          $$StudentsTableCreateCompanionBuilder,
          $$StudentsTableUpdateCompanionBuilder,
          (Student, BaseReferences<_$AppDatabase, $StudentsTable, Student>),
          Student,
          PrefetchHooks Function()
        > {
  $$StudentsTableTableManager(_$AppDatabase db, $StudentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StudentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StudentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StudentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> codigo = const Value.absent(),
                Value<String> nombres = const Value.absent(),
                Value<String> apellidos = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> telefono = const Value.absent(),
                Value<String?> carrera = const Value.absent(),
                Value<String?> grupo = const Value.absent(),
                Value<StudentStatus> estado = const Value.absent(),
                Value<DateTime?> fechaIngreso = const Value.absent(),
                Value<DateTime?> fechaCreacion = const Value.absent(),
              }) => StudentsCompanion(
                id: id,
                codigo: codigo,
                nombres: nombres,
                apellidos: apellidos,
                email: email,
                telefono: telefono,
                carrera: carrera,
                grupo: grupo,
                estado: estado,
                fechaIngreso: fechaIngreso,
                fechaCreacion: fechaCreacion,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String codigo,
                required String nombres,
                required String apellidos,
                Value<String?> email = const Value.absent(),
                Value<String?> telefono = const Value.absent(),
                Value<String?> carrera = const Value.absent(),
                Value<String?> grupo = const Value.absent(),
                Value<StudentStatus> estado = const Value.absent(),
                Value<DateTime?> fechaIngreso = const Value.absent(),
                Value<DateTime?> fechaCreacion = const Value.absent(),
              }) => StudentsCompanion.insert(
                id: id,
                codigo: codigo,
                nombres: nombres,
                apellidos: apellidos,
                email: email,
                telefono: telefono,
                carrera: carrera,
                grupo: grupo,
                estado: estado,
                fechaIngreso: fechaIngreso,
                fechaCreacion: fechaCreacion,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$StudentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StudentsTable,
      Student,
      $$StudentsTableFilterComposer,
      $$StudentsTableOrderingComposer,
      $$StudentsTableAnnotationComposer,
      $$StudentsTableCreateCompanionBuilder,
      $$StudentsTableUpdateCompanionBuilder,
      (Student, BaseReferences<_$AppDatabase, $StudentsTable, Student>),
      Student,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CareersTableTableManager get careers =>
      $$CareersTableTableManager(_db, _db.careers);
  $$ClassGroupsTableTableManager get classGroups =>
      $$ClassGroupsTableTableManager(_db, _db.classGroups);
  $$ModulesTableTableManager get modules =>
      $$ModulesTableTableManager(_db, _db.modules);
  $$UnitsTableTableManager get units =>
      $$UnitsTableTableManager(_db, _db.units);
  $$ActivitiesTableTableManager get activities =>
      $$ActivitiesTableTableManager(_db, _db.activities);
  $$BitacorasTableTableManager get bitacoras =>
      $$BitacorasTableTableManager(_db, _db.bitacoras);
  $$CalendarioBitacorasTableTableManager get calendarioBitacoras =>
      $$CalendarioBitacorasTableTableManager(_db, _db.calendarioBitacoras);
  $$StudentsTableTableManager get students =>
      $$StudentsTableTableManager(_db, _db.students);
}
