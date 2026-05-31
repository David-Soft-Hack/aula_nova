import '../database/app_database.dart';

// Exporting the Drift generated class as the model
export '../database/app_database.dart' show Module, ModulesCompanion;

// You can add custom logic or helper methods for the Module model here
extension ModuleExtension on Module {
  String get displayName => '$codModule - $nombre';
}
