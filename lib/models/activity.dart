import '../database/app_database.dart';

export '../database/app_database.dart' show Activity, ActivitiesCompanion;

extension ActivityExtension on Activity {
  String get shortDescription => descripcion.length > 30 
      ? '${descripcion.substring(0, 27)}...' 
      : descripcion;
}
