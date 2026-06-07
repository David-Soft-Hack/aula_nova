import '../../database/app_database.dart';
import '../../database/tables.dart';
import '../repositories/i_career_repository.dart';

abstract class ICareerController {
  ICareerRepository get careerRepository;

  Future<List<Career>> getAllCareers();
  Future<List<String>> getAllCareerNames();
  Stream<List<Career>> watchAllCareers();
  Future<Career?> getCareerByName(String nombre);
  Future<bool> existsCareer(String nombre);
  Future<void> addCareer(String nombre, TipoCarrera tipo);
  Future<void> updateCareer(Career career);
  Future<void> deleteCareer(Career career);
}
