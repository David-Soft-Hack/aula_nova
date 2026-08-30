import 'package:intl/intl.dart';
import 'bitacora_export_data.dart';

// ─── Clases de datos atómicas ─────────────────────────────────────────────

/// Representa una actividad de la dosificación (una fila del Plan calendario).
class ActividadDocente {
  /// Nombre o código de la Unidad Didáctica.
  final String unidad;

  /// Descripción de la actividad de aprendizaje.
  final String actividad;

  /// Horas asignadas a esta actividad (puede ser HR o HA).
  final num horas;

  /// Fecha programada de impartición.
  final DateTime? fecha;

  /// Indica si la clase ya fue impartida.
  final bool seImpartio;

  /// Descripción de incidencias ocurridas (columna G).
  final String incidencias;

  /// Estrategia de recuperación (columna J).
  final String estrategia;

  const ActividadDocente({
    required this.unidad,
    required this.actividad,
    required this.horas,
    this.fecha,
    this.seImpartio = false,
    this.incidencias = '',
    this.estrategia  = '',
  });
}

/// Representa un estudiante del grupo.
class EstudianteDocente {
  final String codigo;
  final String nombres;
  final String apellidos;
  final String? email;
  final String? telefono;

  const EstudianteDocente({
    required this.codigo,
    required this.nombres,
    required this.apellidos,
    this.email,
    this.telefono,
  });

  String get nombreCompleto => '$nombres $apellidos';
}

/// Representa un registro de evaluación de un estudiante en una sesión.
class EvaluacionDocente {
  final String codigoEstudiante;
  final String codigoActividad;
  final double? puntaje;
  final DateTime? fecha;

  const EvaluacionDocente({
    required this.codigoEstudiante,
    required this.codigoActividad,
    this.puntaje,
    this.fecha,
  });
}

/// Representa un registro de asistencia de un estudiante en una sesión.
class AsistenciaDocente {
  final String codigoEstudiante;
  final DateTime fecha;

  /// Estado: 'presente', 'ausente', 'tardanza', 'justificado'
  final String estado;
  final String? observacion;

  const AsistenciaDocente({
    required this.codigoEstudiante,
    required this.fecha,
    required this.estado,
    this.observacion,
  });
}

// ─── Clase principal ──────────────────────────────────────────────────────

/// Modelo que agrega todos los datos necesarios para generar el
/// **Cuaderno Docente** (Plan Bitácora) completo.
///
/// Sirve como único punto de entrada para [CuadernoDocenteService],
/// desacoplando la lógica de llenado Excel de la fuente de datos concreta.
class DocenteData {
  // ── Datos generales del módulo ──
  /// Nombre del centro educativo. → Celda C5
  final String centro;

  /// Carrera a la que pertenece el módulo. → Celda C6
  final String carrera;

  /// Nombre del módulo formativo. → Celda C7
  final String modulo;

  /// Código del grupo de clase. → Celda J6
  final String grupo;

  /// Carga horaria total con etiqueta (ej. "80 HR" o "100 HA"). → Celda C8
  final String horas;

  /// Fecha de inicio del módulo. → Celda G8
  final DateTime? fechaInicio;

  /// Fecha de finalización del módulo. → Celda K8
  final DateTime? fechaFin;

  // ── Listas dinámicas ──

  /// Dosificación de actividades para la tabla del Plan calendario.
  final List<ActividadDocente> actividades;

  /// Lista de estudiantes del grupo.
  final List<EstudianteDocente> estudiantes;

  /// Registros de evaluaciones.
  final List<EvaluacionDocente> evaluaciones;

  /// Registros de asistencia.
  final List<AsistenciaDocente> asistencias;

  const DocenteData({
    required this.centro,
    required this.carrera,
    required this.modulo,
    required this.grupo,
    required this.horas,
    this.fechaInicio,
    this.fechaFin,
    this.actividades  = const [],
    this.estudiantes  = const [],
    this.evaluaciones = const [],
    this.asistencias  = const [],
  });

  // ─── Factory desde BitacoraExportData ───────────────────────────────────

  /// Construye un [DocenteData] a partir del DTO [BitacoraExportData] que
  /// maneja la app internamente (datos de la base de datos Drift).
  ///
  /// Permite que [CuadernoDocenteService] sea alimentado directamente desde
  /// el flujo normal de exportación sin duplicar lógica.
  factory DocenteData.fromBitacoraExportData(BitacoraExportData data) {
    final bitacora = data.bitacora;
    final module   = data.module;

    final hoursLabel = bitacora.usarHorasReloj ? 'HR' : 'HA';
    final totalHoras = data.sessions.fold<double>(
      0, (prev, s) => prev + (s.horaImpartir ?? 0),
    );

    final actividades = data.sessions.map((session) {
      // Columna "Unidad Didáctica" → etiqueta corta "UD<N>"
      // Extrae el último número del código de unidad (ej. "MF01-U2" → "UD2")
      final unidad = _extraerNumeroFinal(session.codUnidad, prefijo: 'UD');

      // Columna "Actividades" → etiqueta corta "A<N>" (+ "(eva)" si es evaluativa)
      // Extrae el último número del código de actividad (ej. "MF01-U1-A3" → "A3")
      final baseActividad = _extraerNumeroFinal(session.codActividad, prefijo: 'A');
      final actividad = session.esEvaluativa ? '$baseActividad (eva)' : baseActividad;


      return ActividadDocente(
        unidad:      unidad,
        actividad:   actividad,
        horas:       session.horaImpartir ?? 0,
        fecha:       session.fechaProgramada,
        seImpartio:  session.estadoImpartido,
        incidencias: '',  // No almacenado en DB actualmente; extensible
        estrategia:  '',  // No almacenado en DB actualmente; extensible
      );
    }).toList();

    return DocenteData(
      centro:      'Centro de Formación',                  // Extensible desde perfil docente
      carrera:     bitacora.carrera,
      modulo:      module.nombre,
      grupo:       bitacora.codigoGrupo ?? '—',
      horas:       '$totalHoras $hoursLabel',
      fechaInicio: bitacora.fechaInicio,
      fechaFin:    bitacora.fechaFinal,
      actividades: actividades,
    );
  }

  // ─── Helpers de presentación ─────────────────────────────────────────────

  static final _dateFmt = DateFormat('dd/MM/yyyy', 'es');

  String get fechaInicioStr  =>
      fechaInicio != null ? _dateFmt.format(fechaInicio!) : '—';

  String get fechaFinStr =>
      fechaFin != null ? _dateFmt.format(fechaFin!) : '—';

  int get totalActividades => actividades.length;

  int get actividadesImpartidas =>
      actividades.where((a) => a.seImpartio).length;

  double get porcentajeProgreso =>
      totalActividades == 0
          ? 0
          : (actividadesImpartidas / totalActividades) * 100;
}

// ─── Helpers de extracción de código ─────────────────────────────────────────

/// Extrae el último bloque numérico de [codigo] y lo combina con [prefijo].
///
/// Ejemplos:
/// - `_extraerNumeroFinal('MF01-U2',      prefijo: 'UD')` → `'UD2'`
/// - `_extraerNumeroFinal('MF01-U1-A3',   prefijo: 'A')`  → `'A3'`
/// - `_extraerNumeroFinal(null,            prefijo: 'UD')` → `'—'`
/// - `_extraerNumeroFinal('SinNumero',     prefijo: 'A')`  → `'A?'`
String _extraerNumeroFinal(String? codigo, {required String prefijo}) {
  if (codigo == null || codigo.isEmpty) return '—';
  final matches = RegExp(r'\d+').allMatches(codigo);
  if (matches.isEmpty) return '$prefijo?';
  return '$prefijo${matches.last.group(0)}';
}
