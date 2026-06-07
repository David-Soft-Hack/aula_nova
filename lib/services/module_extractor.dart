import '../models/app_models.dart';
import '../interfaces/services/i_module_extractor.dart';

/// Contract for document extractors (DIP - Dependency Inversion Principle).
/// This allows the system to easily support other document formats (e.g. PDF, JSON) in the future.
abstract class ModuleExtractor implements IModuleExtractor {
  @override
  ParsedModuleData extract(String filePath, String defaultFileName);
}
