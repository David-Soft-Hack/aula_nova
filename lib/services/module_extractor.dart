import 'excel_extractor_service.dart' show ParsedModuleData;

/// Contract for document extractors (DIP - Dependency Inversion Principle).
/// This allows the system to easily support other document formats (e.g. PDF, JSON) in the future.
abstract class ModuleExtractor {
  ParsedModuleData extract(String filePath, String defaultFileName);
}
