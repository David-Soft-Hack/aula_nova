import '../../models/app_models.dart';

abstract class IModuleExtractor {
  ParsedModuleData extract(String filePath, String defaultFileName);
}
