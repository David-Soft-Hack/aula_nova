import 'dart:io';
import 'package:excel/excel.dart';
import '../models/app_models.dart';
import 'module_extractor.dart';

/// Single Responsibility Principle (SRP) applied:
/// ExcelExtractorService coordinates the extraction, delegating responsibilities to sub-parsers.
class ExcelExtractorService implements ModuleExtractor {
  
  @override
  ParsedModuleData extract(String filePath, String defaultFileName) {
    final bytes = File(filePath).readAsBytesSync();
    final excelFile = Excel.decodeBytes(bytes);

    // Validate official template
    ExcelTemplateValidator.validate(excelFile);

    // Parse subcomponents using SRP
    final generalInfo = GeneralInfoParser.parse(excelFile);
    final units = UnitsParser.parse(excelFile);
    final activities = ActivitiesParser.parse(excelFile, units);

    String finalModuleName = generalInfo.nombre;
    if (finalModuleName.isEmpty) {
      finalModuleName = defaultFileName.replaceAll('.xlsx', '').replaceAll('_', ' ').trim();
      if (finalModuleName.isEmpty) finalModuleName = 'Nuevo Módulo Formativo';
    }

    return ParsedModuleData(
      nombre: finalModuleName,
      codigo: generalInfo.codigo,
      carrera: generalInfo.carrera,
      totalHR: generalInfo.totalHR,
      totalHA: generalInfo.totalHA,
      units: units,
      activities: activities,
    );
  }
}

/// SRP: Validates the Excel template format
class ExcelTemplateValidator {
  static void validate(Excel excelFile) {
    if (!excelFile.tables.containsKey('INFORMACION GENERAL') ||
        !excelFile.tables.containsKey('UNIDADES DIDÁCTICAS') ||
        !excelFile.tables.containsKey('ACTIVIDADES DE APRENDIZAJE')) {
      throw const FormatException(
        'El archivo seleccionado no es la plantilla oficial. Por favor, asegúrate de utilizar el formato descargable de la aplicación.'
      );
    }
  }
}

/// SRP: Responsible only for parsing General Information
class GeneralInfoParser {
  static GeneralInfoData parse(Excel excelFile) {
    String moduleName = '';
    String code = '';
    String career = 'Ingeniería de Sistemas';
    int totalHR = 0;
    int totalHA = 0;

    final sheet = excelFile.tables['INFORMACION GENERAL'];
    if (sheet != null) {
      for (var row in sheet.rows) {
        if (row.length >= 2) {
          final label = row[0]?.value?.toString().toUpperCase() ?? '';
          final value = row[1]?.value?.toString() ?? '';
          if (label.contains('MÓDULO FORMATIVO')) {
            moduleName = value;
          } else if (label.contains('CÓDIGO')) {
            code = value;
          } else if (label.contains('CARRERA')) {
            career = value;
          } else if (label.contains('RELOJ')) {
            totalHR = double.tryParse(value)?.toInt() ?? int.tryParse(value) ?? 0;
          } else if (label.contains('ACADÉMICAS')) {
            totalHA = double.tryParse(value)?.toInt() ?? int.tryParse(value) ?? 0;
          }
        }
      }
    }

    return GeneralInfoData(
      nombre: moduleName,
      codigo: code,
      carrera: career,
      totalHR: totalHR,
      totalHA: totalHA,
    );
  }
}

/// SRP: Responsible only for parsing Units
class UnitsParser {
  static List<Map<String, dynamic>> parse(Excel excelFile) {
    final List<Map<String, dynamic>> parsedUnits = [];
    final sheet = excelFile.tables['UNIDADES DIDÁCTICAS'];
    if (sheet != null) {
      for (int i = 3; i < sheet.rows.length; i++) {
        final row = sheet.rows[i];
        if (row.length >= 5) {
          final uName = row[1]?.value?.toString() ?? '';
          if (uName.trim().isEmpty) continue;

          final hr = double.tryParse(row[2]?.value?.toString() ?? '')?.toInt() ?? int.tryParse(row[2]?.value?.toString() ?? '') ?? 0;
          final ha = double.tryParse(row[3]?.value?.toString() ?? '')?.toInt() ?? int.tryParse(row[3]?.value?.toString() ?? '') ?? 0;
          final ponderacion = double.tryParse(row[4]?.value?.toString() ?? '') ?? 0.0;

          parsedUnits.add({
            'nombre': uName,
            'hr': hr,
            'ha': ha,
            'ponderacion': ponderacion,
          });
        }
      }
    }
    return parsedUnits;
  }
}

/// SRP: Responsible only for parsing Activities
class ActivitiesParser {
  static List<Map<String, dynamic>> parse(Excel excelFile, List<Map<String, dynamic>> parsedUnits) {
    final List<Map<String, dynamic>> parsedActivities = [];
    final sheet = excelFile.tables['ACTIVIDADES DE APRENDIZAJE'];
    if (sheet != null) {
      for (int i = 3; i < sheet.rows.length; i++) {
        final row = sheet.rows[i];
        if (row.length >= 5) {
          final desc = row[1]?.value?.toString() ?? '';
          if (desc.trim().isEmpty) continue;

          String actNum = row[0]?.value?.toString() ?? '';
          if (actNum.endsWith('.0')) {
            actNum = actNum.substring(0, actNum.length - 2);
          }

          final unitNumStr = row[2]?.value?.toString() ?? '1';
          final unitNum = double.tryParse(unitNumStr)?.toInt() ?? int.tryParse(unitNumStr) ?? 1;
          final unitIndex = (unitNum - 1).clamp(0, parsedUnits.isNotEmpty ? parsedUnits.length - 1 : 0);

          final hr = double.tryParse(row[3]?.value?.toString() ?? '')?.toInt() ?? int.tryParse(row[3]?.value?.toString() ?? '') ?? 0;
          final ha = double.tryParse(row[4]?.value?.toString() ?? '')?.toInt() ?? int.tryParse(row[4]?.value?.toString() ?? '') ?? 0;

          parsedActivities.add({
            'codigo': actNum.trim(),
            'unitIndex': unitIndex,
            'descripcion': desc,
            'hr': hr,
            'ha': ha,
          });
        }
      }
    }
    return parsedActivities;
  }
}
