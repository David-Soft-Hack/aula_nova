import 'dart:io';
import 'dart:typed_data';
import 'package:excel/excel.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../models/plan_bitacora.dart';

/// Servicio para cargar y parsear el archivo Plan_Bitacora.xlsx.
/// 
/// Soporta dos fuentes:
/// - [loadFromAssets]: Carga desde el asset empaquetado en la app (uso principal).
/// - [loadFromFile]: Carga desde un archivo local (para pruebas o selección manual).
class ExcelBitacoraService {
  static const String assetPath = 'assets/Plan Bitacora.xlsx';

  // ─── Carga pública ────────────────────────────────────────────────────────

  /// Carga el plan de bitácora desde los assets de la aplicación.
  Future<PlanBitacora?> loadFromAssets() async {
    try {
      final byteData = await rootBundle.load(assetPath);
      return _parseExcelBytes(byteData.buffer.asUint8List());
    } catch (e) {
      // ignore: avoid_print
      print('[ExcelBitacoraService] Error cargando desde assets: $e');
      return null;
    }
  }

  /// Carga el plan de bitácora desde un archivo del sistema de archivos.
  Future<PlanBitacora?> loadFromFile(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) return null;
      final bytes = await file.readAsBytes();
      return _parseExcelBytes(bytes);
    } catch (e) {
      // ignore: avoid_print
      print('[ExcelBitacoraService] Error cargando desde archivo: $e');
      return null;
    }
  }

  // ─── Parseo ───────────────────────────────────────────────────────────────

  PlanBitacora? _parseExcelBytes(Uint8List bytes) {
    try {
      final excel = Excel.decodeBytes(bytes);
      if (excel.tables.isEmpty) return null;

      // Usar la primera hoja disponible
      final sheet = excel.tables.values.first;

      // === Datos Generales ===
      final nombreCentro = _getCellValue(sheet, 5, 2) ?? '';
      final carrera     = _getCellValue(sheet, 6, 2) ?? '';
      final modulo      = _getCellValue(sheet, 7, 2) ?? '';
      final codigoGrupo = _getCellValue(sheet, 6, 9) ?? '';
      final cargaHoraria = _getCellValue(sheet, 8, 1) ?? '';

      // Fechas de inicio y fin
      final fechaInicio = _parseExcelDate(_getCellValue(sheet, 8, 5));
      final fechaFin    = _parseExcelDate(_getCellValue(sheet, 8, 7));

      // === Horario Semanal ===
      final horario = <String, String>{};
      const dias = ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'];
      for (int i = 0; i < dias.length; i++) {
        final hora = _getCellValue(sheet, 10, 2 + i);
        if (hora != null && hora.trim().isNotEmpty) {
          horario[dias[i]] = hora.trim();
        }
      }

      // === Dosificación de Actividades ===
      final dosificacion = <Map<String, dynamic>>[];
      const startRow = 14; // Fila 0-indexada donde empiezan las actividades

      for (int row = startRow; row < sheet.maxRows; row++) {
        final unidad    = _getCellValue(sheet, row, 0);
        final actividad = _getCellValue(sheet, row, 1);

        if ((unidad == null || unidad.trim().isEmpty) &&
            (actividad == null || actividad.trim().isEmpty)) {
          continue;
        }

        dosificacion.add({
          'unidad': unidad?.trim() ?? '',
          'actividad': actividad?.trim() ?? '',
          'horas': _getCellValue(sheet, row, 2)?.trim() ?? '',
          'fechaProgramada': _parseExcelDate(_getCellValue(sheet, row, 3)),
          'seImpartio': (_getCellValue(sheet, row, 4)?.toUpperCase() == 'X'),
          'descripcionIncidencias': _getCellValue(sheet, row, 6)?.trim() ?? '',
          'estrategiaRecuperacion': _getCellValue(sheet, row, 8)?.trim() ?? '',
        });
      }

      return PlanBitacora.fromExcel({
        'nombreCentro': nombreCentro,
        'carrera': carrera,
        'modulo': modulo,
        'codigoGrupo': codigoGrupo,
        'cargaHoraria': cargaHoraria,
        'fechaInicio': fechaInicio,
        'fechaFinalizacion': fechaFin,
        'horario': horario,
        'dosificacion': dosificacion,
      });
    } catch (e) {
      // ignore: avoid_print
      print('[ExcelBitacoraService] Error parseando Excel: $e');
      return null;
    }
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────

  String? _getCellValue(Sheet sheet, int row, int col) {
    try {
      if (row >= sheet.maxRows) return null;
      final rowData = sheet.rows[row];
      if (col >= rowData.length) return null;
      final cell = rowData[col];
      final value = cell?.value;
      if (value == null) return null;
      return value.toString().trim().isEmpty ? null : value.toString();
    } catch (_) {
      return null;
    }
  }

  DateTime? _parseExcelDate(dynamic value) {
    if (value == null) return null;
    try {
      if (value is DateTime) return value;
      if (value is num) {
        // Número de serie de Excel (sistema 1900):
        // El día 1 = 1 enero 1900, pero Excel tiene el bug del año bisiesto 1900,
        // por lo que restamos 2 en lugar de 1.
        return DateTime(1900, 1, 1).add(Duration(days: value.toInt() - 2));
      }
      return DateTime.tryParse(value.toString());
    } catch (_) {
      return null;
    }
  }
}
