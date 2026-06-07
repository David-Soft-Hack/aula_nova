import 'package:drift/drift.dart';
import '../../database/app_database.dart';

abstract class ICareerRepository {
  Future<List<Career>> getAllCareers();
  Stream<List<Career>> watchAllCareers();
  Future<void> insertCareer(Insertable<Career> career);
  Future<void> updateCareer(Insertable<Career> career);
  Future<void> deleteCareer(Insertable<Career> career);
}
