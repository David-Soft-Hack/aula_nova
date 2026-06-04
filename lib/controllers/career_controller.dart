import 'package:drift/drift.dart';
import '../database/app_database.dart';
import '../database/tables.dart';
import '../database/daos.dart';
import '../models/database_provider.dart';

class CareerController {
  final CareerDao _dao = DatabaseProvider.careerDao;

  Future<List<Career>> getAllCareers() => _dao.getAllCareers();

  Stream<List<Career>> watchAllCareers() => _dao.watchAllCareers();

  Future<Career?> getCareerByName(String nombre) async {
    final careers = await _dao.getAllCareers();
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
    await _dao.insertCareer(career);
  }

  Future<void> updateCareer(Career career) async {
    await _dao.updateCareer(career);
  }

  Future<void> deleteCareer(Career career) async {
    await _dao.deleteCareer(career);
  }
}
