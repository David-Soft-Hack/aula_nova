import 'package:drift/drift.dart';
import '../database/app_database.dart';
import '../database/tables.dart';
import '../database/daos.dart';

class CareerController {
  final CareerDao careerDao;

  CareerController({required this.careerDao});

  Future<List<Career>> getAllCareers() => careerDao.getAllCareers();
  Future<List<String>> getAllCareerNames() async {
    final careers = await careerDao.getAllCareers();
    return careers.map((c) => c.nombre).toList();
  }

  Stream<List<Career>> watchAllCareers() => careerDao.watchAllCareers();

  Future<Career?> getCareerByName(String nombre) async {
    final careers = await careerDao.getAllCareers();
    final normalized = nombre.trim().toLowerCase();
    try {
      return careers.firstWhere((c) => c.nombre.trim().toLowerCase() == normalized);
    } catch (_) {
      return null;
    }
  }

  Future<bool> existsCareer(String nombre) async {
    return await getCareerByName(nombre) != null;
  }

  Future<void> addCareer(String nombre, TipoCarrera tipo) async {
    final career = CareersCompanion(
      nombre: Value(nombre),
      tipoCarrera: Value(tipo),
      fechaCreacion: Value(DateTime.now()),
    );
    await careerDao.insertCareer(career);
  }

  Future<void> updateCareer(Career career) async {
    await careerDao.updateCareer(career);
  }

  Future<void> deleteCareer(Career career) async {
    await careerDao.deleteCareer(career);
  }
}
