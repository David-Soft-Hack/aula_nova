import '../database/app_database.dart';

/// DTO que encapsula todos los datos necesarios para exportar una bitácora
/// a Excel o PDF. Agrupa la bitácora, el módulo, las sesiones del calendario
/// y mapas de nombres descriptivos para unidades y actividades.
class BitacoraExportData {
  final Bitacora bitacora;
  final Module module;
  final List<CalendarioBitacora> sessions;

  /// Mapa de código de unidad → nombre descriptivo.
  /// Ej: 'MF01-U1' → 'Unidad I: Fundamentos'
  final Map<String, String> unitNames;

  /// Mapa de código de actividad → descripción.
  /// Ej: 'MF01-U1-A1' → 'Elaborar diagrama entidad-relación'
  final Map<String, String> activityNames;

  const BitacoraExportData({
    required this.bitacora,
    required this.module,
    required this.sessions,
    required this.unitNames,
    required this.activityNames,
  });

  /// Sesiones marcadas como impartidas
  List<CalendarioBitacora> get sessionsCompleted =>
      sessions.where((s) => s.estadoImpartido).toList();

  /// Sesiones pendientes
  List<CalendarioBitacora> get sessionsPending =>
      sessions.where((s) => !s.estadoImpartido).toList();

  /// Progreso de 0.0 a 1.0
  double get progress =>
      sessions.isEmpty ? 0.0 : sessionsCompleted.length / sessions.length;

  /// Nombre del módulo truncado para usar en nombre de archivo
  String get safeFileName {
    final moduleName = module.nombre
        .replaceAll(RegExp(r'[^\w\s-]'), '')
        .replaceAll(RegExp(r'\s+'), '_')
        .trim();
    final group = bitacora.codigoGrupo ?? 'SinGrupo';
    return 'Bitacora_${moduleName}_$group';
  }
}
