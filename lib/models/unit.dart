import '../database/app_database.dart';

export '../database/app_database.dart' show Unit, UnitsCompanion;

extension UnitExtension on Unit {
  double get percentage => ponderacion * 100;
}
