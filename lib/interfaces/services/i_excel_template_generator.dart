import '../../database/app_database.dart';

abstract class IExcelTemplateGenerator {
  Future<List<int>> generate(List<Career> careers);
}
