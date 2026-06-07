import 'package:drift/drift.dart';
import '../database/app_database.dart';
import '../database/daos.dart';
import '../interfaces/repositories/i_career_repository.dart';

class CareerRepository implements ICareerRepository {
  final CareerDao _dao;

  CareerRepository(this._dao);

  @override
  Future<List<Career>> getAllCareers() => _dao.getAllCareers();

  @override
  Stream<List<Career>> watchAllCareers() => _dao.watchAllCareers();

  @override
  Future<void> insertCareer(Insertable<Career> career) => _dao.insertCareer(career);

  @override
  Future<void> updateCareer(Insertable<Career> career) => _dao.updateCareer(career);

  @override
  Future<void> deleteCareer(Insertable<Career> career) => _dao.deleteCareer(career);
}
