import 'dart:io';
import 'package:excel/excel.dart';
import '../models/app_models.dart';
import 'module_extractor.dart';

/// Single Responsibility Principle (SRP) applied:
/// ExcelExtractorService coordinates the extraction, delegating responsibilities to sub-parsers.
class ExcelExtractorService implements ModuleExtractor {
  
  @override
  ParsedModuleData extract(String filePath, String defaultFileName) {
    final file = File(filePath);
    if (!file.existsSync()) {
      throw FormatException('El archivo Excel no existe o no se puede acceder: $filePath');
    }

    final bytes = File(filePath).readAsBytesSync();
    final excelFile = Excel.decodeBytes(bytes);

    ExcelTemplateValidator.validate(excelFile);

    final generalInfo = GeneralInfoParser.parse(excelFile);
    final units = UnitsParser.parse(excelFile);
    final activities = ActivitiesParser.parse(excelFile, units);

    String finalModuleName = generalInfo.nombre.trim();
    if (finalModuleName.isEmpty) {
      finalModuleName = defaultFileName.replaceAll('.xlsx', '').replaceAll('_', ' ').trim();
    }

    if (finalModuleName.isEmpty) finalModuleName = 'Nuevo Módulo Formativo';

    return ParsedModuleData(
      nombre: finalModuleName,
      codigo: generalInfo.codigo.trim(),
      carrera: generalInfo.carrera.trim(),
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
          final label = (row[0]?.value?.toString() ?? '').trim().toUpperCase();
          final value = (row[1]?.value?.toString() ?? '').trim();
          if (label.contains('MÓDULO FORMATIVO')) {
            moduleName = value;
          } else if (label.contains('CÓDIGO')) {
            code = value;
          } else if (label.contains('CARRERA')) {
            career = value;
          } else if (label.contains('RELOJ')) {
            final parsed = double.tryParse(value);
            if (parsed != null) {
              totalHR = parsed.toInt();
            } else {
              final intParsed = int.tryParse(value);
              if (intParsed != null) {
                totalHR = intParsed;
              } else if (value.isNotEmpty) {
                throw FormatException('Valor inválido en HORAS RELOJ: "$value"');
              }
            }
          } else if (label.contains('ACADÉMICAS')) {
            final parsed = double.tryParse(value);
            if (parsed != null) {
              totalHA = parsed.toInt();
            } else {
              final intParsed = int.tryParse(value);
              if (intParsed != null) {
                totalHA = intParsed;
              } else if (value.isNotEmpty) {
                throw FormatException('Valor inválido en HORAS ACADÉMICAS: "$value"');
              }
            }
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

int _parseNumeric(String value, String fieldLabel) {
  if (value.isEmpty) return 0;
  final parsed = double.tryParse(value);
  if (parsed != null) return parsed.toInt();
  final intParsed = int.tryParse(value);
  if (intParsed != null) return intParsed;
  throw FormatException('Valor numérico inválido en $fieldLabel: "$value"');
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
          final uName = (row[1]?.value?.toString() ?? '').trim();
          if (uName.isEmpty) continue;

          final hrRaw = (row[2]?.value?.toString() ?? '').trim();
          final haRaw = (row[3]?.value?.toString() ?? '').trim();
          final ponderacionRaw = (row[4]?.value?.toString() ?? '').trim();

          final hr = _parseNumeric(hrRaw, 'HORAS RELOJ en fila ${i + 1}');
          final ha = _parseNumeric(haRaw, 'HORAS ACADÉMICAS en fila ${i + 1}');
          final ponderacion = double.tryParse(ponderacionRaw) ?? 0.0;

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

  static int _parseNumeric(String value, String fieldLabel) {
    if (value.isEmpty) return 0;
    final parsed = double.tryParse(value);
    if (parsed != null) return parsed.toInt();
    final intParsed = int.tryParse(value);
    if (intParsed != null) return intParsed;
    throw FormatException('Valor numérico inválido en $fieldLabel: "$value"');
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
          final desc = (row[1]?.value?.toString() ?? '').trim();
          if (desc.isEmpty) continue;

          String actNum = (row[0]?.value?.toString() ?? '').trim();
          if (actNum.endsWith('.0')) {
            actNum = actNum.substring(0, actNum.length - 2);
          }

          final unitNumStr = (row[2]?.value?.toString() ?? '1').trim();
          final unitNum = double.tryParse(unitNumStr)?.toInt() ?? int.tryParse(unitNumStr) ?? 1;
          final unitIndex = (unitNum - 1).clamp(0, parsedUnits.isNotEmpty ? parsedUnits.length - 1 : 0);

          final hr = _parseNumeric((row[3]?.value?.toString() ?? '').trim(), 'HORAS RELOJ en ACTIVIDAD fila ${i + 1}');
          final ha = _parseNumeric((row[4]?.value?.toString() ?? '').trim(), 'HORAS ACADÉMICAS en ACTIVIDAD fila ${i + 1}');

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
