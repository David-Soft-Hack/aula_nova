class GeneralInfoData {
  final String nombre;
  final String codigo;
  final String carrera;
  final int totalHR;
  final int totalHA;

  GeneralInfoData({
    required this.nombre,
    required this.codigo,
    required this.carrera,
    required this.totalHR,
    required this.totalHA,
  });
}

class ParsedModuleData {
  final String nombre;
  final String codigo;
  final String carrera;
  final int totalHR;
  final int totalHA;
  final List<Map<String, dynamic>> units;
  final List<Map<String, dynamic>> activities;

  ParsedModuleData({
    required this.nombre,
    required this.codigo,
    required this.carrera,
    required this.totalHR,
    required this.totalHA,
    required this.units,
    required this.activities,
  });
}
