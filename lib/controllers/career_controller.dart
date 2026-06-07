import 'package:drift/drift.dart';
import '../database/app_database.dart';
import '../database/tables.dart';
import '../interfaces/controllers/i_career_controller.dart';
import '../interfaces/repositories/i_career_repository.dart';

class CareerController implements ICareerController {
  final ICareerRepository _repository;

  CareerController({required ICareerRepository careerRepository}) : _repository = careerRepository;

  @override
  ICareerRepository get careerRepository => _repository;

  @override
  Future<List<Career>> getAllCareers() => _repository.getAllCareers();

  @override
  Future<List<String>> getAllCareerNames() async {
    final careers = await _repository.getAllCareers();
    return careers.map((c) => c.nombre).toList();
  }

  @override
  Stream<List<Career>> watchAllCareers() => _repository.watchAllCareers();

  @override
  Future<Career?> getCareerByName(String nombre) async {
    final careers = await _repository.getAllCareers();
    final normalized = nombre.trim().toLowerCase();
    try {
      return careers.firstWhere((c) => c.nombre.trim().toLowerCase() == normalized);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<bool> existsCareer(String nombre) async {
    return await getCareerByName(nombre) != null;
  }

  @override
  Future<void> addCareer(String nombre, TipoCarrera tipo) async {
    final career = CareersCompanion(
      nombre: Value(nombre),
      tipoCarrera: Value(tipo),
      fechaCreacion: Value(DateTime.now()),
    );
    await _repository.insertCareer(career);
  }

  @override
  Future<void> updateCareer(Career career) async {
    await _repository.updateCareer(career);
  }

  @override
  Future<void> deleteCareer(Career career) async {
    await _repository.deleteCareer(career);
  }
}
