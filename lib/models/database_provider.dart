import '../database/app_database.dart';
import '../database/daos.dart';

class DatabaseProvider {
  static final AppDatabase _db = AppDatabase();

  static AppDatabase get db => _db;

  // Convenient access to DAOs
  static ModuleDao get moduleDao => _db.moduleDao;
  static UnitDao get unitDao => _db.unitDao;
  static ActivityDao get activityDao => _db.activityDao;
  static BitacoraDao get bitacoraDao => _db.bitacoraDao;
  static CareerDao get careerDao => _db.careerDao;
  static StudentDao get studentDao => _db.studentDao;
}
