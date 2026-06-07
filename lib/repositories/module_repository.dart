import 'package:drift/drift.dart';
import '../database/app_database.dart';
import '../database/daos.dart';
import '../interfaces/repositories/i_module_repository.dart';

class ModuleRepository implements IModuleRepository {
  final ModuleDao _moduleDao;
  final UnitDao _unitDao;
  final ActivityDao _activityDao;

  ModuleRepository(this._moduleDao, this._unitDao, this._activityDao);

  @override
  Future<List<Module>> getAllModules() => _moduleDao.getAllModules();

  @override
  Stream<List<Module>> watchAllModules() => _moduleDao.watchAllModules();

  @override
  Future<Module?> getModuleByCod(String cod) => _moduleDao.getModuleByCod(cod);

  @override
  Future<void> insertModule(Insertable<Module> module) => _moduleDao.insertModule(module);

  @override
  Future<void> updateModule(Insertable<Module> module) => _moduleDao.updateModule(module);

  @override
  Future<void> deleteModule(Insertable<Module> module) => _moduleDao.deleteModule(module);

  @override
  Future<int> countModulesByCareer(String careerName) => _moduleDao.countModulesByCareer(careerName);

  @override
  Stream<List<Module>> watchModulesByCareer(String careerName) => _moduleDao.watchModulesByCareer(careerName);

  @override
  Future<List<Unit>> getUnitsByModule(String idModule) => _unitDao.getUnitsByModule(idModule);

  @override
  Future<Unit?> getUnitByCod(String codUnit) => _unitDao.getUnitByCod(codUnit);

  @override
  Stream<Unit?> watchUnitByCod(String codUnit) => _unitDao.watchUnitByCod(codUnit);

  @override
  Future<void> insertUnit(Insertable<Unit> unit) => _unitDao.insertUnit(unit);

  @override
  Future<void> updateUnit(Insertable<Unit> unit) => _unitDao.updateUnit(unit);

  @override
  Future<void> deleteUnit(Insertable<Unit> unit) => _unitDao.deleteUnit(unit);

  @override
  Future<void> deleteUnitsByModule(String idModule) => _unitDao.deleteUnitsByModule(idModule);

  @override
  Future<List<Activity>> getActivitiesByUnit(String idUnit) => _activityDao.getActivitiesByUnit(idUnit);

  @override
  Future<Activity?> getActivityByCod(String codActivity) => _activityDao.getActivityByCod(codActivity);

  @override
  Stream<Activity?> watchActivityByCod(String codActivity) => _activityDao.watchActivityByCod(codActivity);

  @override
  Future<void> insertActivity(Insertable<Activity> activity) => _activityDao.insertActivity(activity);

  @override
  Future<void> updateActivity(Insertable<Activity> activity) => _activityDao.updateActivity(activity);

  @override
  Future<void> deleteActivity(Insertable<Activity> activity) => _activityDao.deleteActivity(activity);

  @override
  Future<void> deleteActivityByCode(String codActivity) => _activityDao.deleteActivityByCode(codActivity);

  @override
  Future<void> deleteActivitiesByUnit(String idUnit) => _activityDao.deleteActivitiesByUnit(idUnit);
}
