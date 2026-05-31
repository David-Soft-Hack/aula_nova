import 'package:drift/drift.dart';
import '../database/app_database.dart';
import '../database/tables.dart';
import '../database/daos.dart';
import '../models/database_provider.dart';

class CareerController {
  final CareerDao _dao = DatabaseProvider.careerDao;

  Future<List<Career>> getAllCareers() async {
    return await _dao.getAllCareers();
  }

  Stream<List<Career>> watchAllCareers() {
    return _dao.watchAllCareers();
  }

  Future<bool> existsCareer(String nombre) async {
    final careers = await getAllCareers();
    final normalizedInput = nombre.trim().toLowerCase();
    return careers.any((c) => c.nombre.trim().toLowerCase() == normalizedInput);
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
