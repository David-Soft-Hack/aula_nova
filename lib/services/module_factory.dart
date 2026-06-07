import '../database/app_database.dart';
import '../database/daos.dart';

class ModuleFactory {
  final ModuleDao moduleDao;

  ModuleFactory({required this.moduleDao});

  Future<List<Unit>> createUnitsFromMaps(
    String codModule,
    List<Map<String, dynamic>> units,
  ) async {
    final result = <Unit>[];
    for (int i = 0; i < units.length; i++) {
      final u = units[i];
      final unitCode = '$codModule-U${i + 1}';
      result.add(Unit(
        codUnit: unitCode,
        nombre: u['nombre'].toString().isEmpty
            ? 'Unidad ${i + 1}'
            : u['nombre'].toString(),
        totalHoraAcademic: u['ha'] as int? ?? 0,
        totalHoraReloj: u['hr'] as int? ?? 0,
        ponderacion: u['ponderacion'] as double? ?? 0.0,
        idModule: codModule,
      ));
    }
    return result;
  }

  Future<List<Activity>> createActivitiesFromMaps(
    String codModule,
    List<Map<String, dynamic>> units,
    List<Map<String, dynamic>> activities,
  ) async {
    final result = <Activity>[];
    for (int i = 0; i < units.length; i++) {
      final actsForUnit = activities.where((a) => a['unitIndex'] == i).toList();
      for (int j = 0; j < actsForUnit.length; j++) {
        final act = actsForUnit[j];
        final unitCode = '$codModule-U${i + 1}';
        final customCode = (act['codigo']?.toString().trim() ?? '').isEmpty
            ? 'A${j + 1}'
            : act['codigo'].toString().trim();
        final actCode = '$unitCode-$customCode';

        result.add(Activity(
          codActivity: actCode,
          descripcion: act['descripcion'].toString().isEmpty
              ? 'Actividad ${j + 1}'
              : act['descripcion'].toString(),
          totalHoraAcademic: act['ha'] as int? ?? 0,
          totalHoraReloj: act['hr'] as int? ?? 0,
          idUnit: unitCode,
        ));
      }
    }
    return result;
  }

  Future<void> validateModuleCodeNotExists(String codModule) async {
    final existing = await moduleDao.getModuleByCod(codModule);
    if (existing != null) {
      throw Exception('El módulo con código "$codModule" ya existe.');
    }
  }

  Module createModule({
    required String codModule,
    required String nombre,
    required String carrera,
    required int totalHoraAcademic,
    required int totalHoraReloj,
  }) {
    return Module(
      codModule: codModule,
      nombre: nombre.isEmpty ? 'Nuevo Módulo' : nombre,
      totalHoraAcademic: totalHoraAcademic,
      totalHoraReloj: totalHoraReloj,
      carrera: carrera,
      fechaCreacion: DateTime.now(),
    );
  }
}
