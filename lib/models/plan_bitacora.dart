/// Modelo que representa los datos extraídos del archivo Plan_Bitacora.xlsx.
/// Encapsula información general del módulo, horario semanal y dosificación de actividades.
class PlanBitacora {
  final String nombreCentro;
  final String carrera;
  final String modulo;
  final String codigoGrupo;
  final String cargaHoraria;
  final DateTime? fechaInicio;
  final DateTime? fechaFinalizacion;

  /// Mapa de día de semana → hora. Ej: {'Lunes': '07:00-09:00'}
  final Map<String, String> horario;

  /// Lista de items de la dosificación. Cada item es un mapa con claves:
  /// 'unidad', 'actividad', 'horas', 'fechaProgramada', 'seImpartio',
  /// 'descripcionIncidencias', 'estrategiaRecuperacion'.
  final List<Map<String, dynamic>> dosificacion;

  const PlanBitacora({
    required this.nombreCentro,
    required this.carrera,
    required this.modulo,
    required this.codigoGrupo,
    required this.cargaHoraria,
    this.fechaInicio,
    this.fechaFinalizacion,
    required this.horario,
    required this.dosificacion,
  });

  factory PlanBitacora.fromExcel(Map<String, dynamic> data) {
    return PlanBitacora(
      nombreCentro: (data['nombreCentro'] as String?) ?? '',
      carrera: (data['carrera'] as String?) ?? '',
      modulo: (data['modulo'] as String?) ?? '',
      codigoGrupo: (data['codigoGrupo'] as String?) ?? '',
      cargaHoraria: (data['cargaHoraria'] as String?) ?? '',
      fechaInicio: data['fechaInicio'] as DateTime?,
      fechaFinalizacion: data['fechaFinalizacion'] as DateTime?,
      horario: Map<String, String>.from(
        (data['horario'] as Map<String, dynamic>? ?? {}).map(
          (k, v) => MapEntry(k, v.toString()),
        ),
      ),
      dosificacion: List<Map<String, dynamic>>.from(
        (data['dosificacion'] as List<dynamic>? ?? []).map(
          (item) => Map<String, dynamic>.from(item as Map),
        ),
      ),
    );
  }

  /// Número de actividades marcadas como impartidas
  int get actividadesImpartidas =>
      dosificacion.where((d) => d['seImpartio'] == true).length;

  /// Total de actividades en la dosificación
  int get totalActividades => dosificacion.length;

  /// Progreso como porcentaje (0–100)
  double get porcentajeProgreso =>
      totalActividades == 0 ? 0 : (actividadesImpartidas / totalActividades) * 100;
}
