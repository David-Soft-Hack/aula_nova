import 'package:excel/excel.dart';

/// Utilidades puras para la lectura y escritura segura de celdas Excel.
///
/// Todas las funciones son independientes del estado de la app y pueden
/// reutilizarse en cualquier servicio que opere sobre objetos [Sheet].
class ExcelCellHelper {
  ExcelCellHelper._(); // no instanciar

  // ─── Parseo de coordenadas ───────────────────────────────────────────────

  /// Convierte una coordenada alfanumérica estilo Excel (ej. "C5", "J14") en
  /// un [CellIndex] con base 0.
  ///
  /// Soporta columnas de 1 o 2 letras (A–ZZ) y filas >= 1.
  /// Lanza [ArgumentError] si el formato no es reconocido.
  static CellIndex parseCoordenada(String coord) {
    final upper = coord.trim().toUpperCase();
    final match = RegExp(r'^([A-Z]+)(\d+)$').firstMatch(upper);
    if (match == null) {
      throw ArgumentError('Coordenada Excel inválida: "$coord". '
          'Esperado formato tipo "A1", "C5", "AA12".');
    }

    final colLetters = match.group(1)!;
    final rowNumber  = int.parse(match.group(2)!);

    int colIndex = 0;
    for (int i = 0; i < colLetters.length; i++) {
      colIndex = colIndex * 26 + (colLetters.codeUnitAt(i) - 64);
    }

    return CellIndex.indexByColumnRow(
      columnIndex: colIndex - 1,   // 0-based
      rowIndex: rowNumber - 1,     // 0-based
    );
  }

  // ─── Escritura segura ────────────────────────────────────────────────────

  /// Escribe [value] en la celda ([row], [col]) de [sheet] usando el tipo
  /// Dart adecuado para el paquete `excel`.
  ///
  /// - Si [value] es `null` la celda queda vacía.
  /// - No crea ni altera estilos, bordes ni combinaciones de celdas.
  static void safeCellWrite(Sheet sheet, int row, int col, dynamic value) {
    // Asegurar que la hoja tiene suficientes filas
    while (sheet.maxRows <= row) {
      sheet.appendRow([]);
    }

    final cell = sheet.cell(
      CellIndex.indexByColumnRow(columnIndex: col, rowIndex: row),
    );

    if (value == null) {
      cell.value = null;
    } else if (value is String) {
      cell.value = TextCellValue(value);
    } else if (value is int) {
      cell.value = IntCellValue(value);
    } else if (value is double) {
      cell.value = DoubleCellValue(value);
    } else if (value is bool) {
      cell.value = BoolCellValue(value);
    } else {
      // Fallback: convertir a texto
      cell.value = TextCellValue(value.toString());
    }
  }

  /// Versión con coordenada alfanumérica (ej. "C5").
  /// Internamente delega a [safeCellWrite].
  static void writeCelda(Sheet sheet, String coordenada, dynamic value) {
    final idx = parseCoordenada(coordenada);
    safeCellWrite(sheet, idx.rowIndex, idx.columnIndex, value);
  }

  // ─── Lectura segura ──────────────────────────────────────────────────────

  /// Lee el valor de la celda ([row], [col]) como [String].
  /// Retorna `null` si la celda no existe o está vacía.
  static String? readCellStr(Sheet sheet, int row, int col) {
    try {
      if (row >= sheet.maxRows) return null;
      final rows = sheet.rows;
      if (row >= rows.length) return null;
      final rowData = rows[row];
      if (col >= rowData.length) return null;
      final value = rowData[col]?.value;
      if (value == null) return null;
      final str = value.toString().trim();
      return str.isEmpty ? null : str;
    } catch (_) {
      return null;
    }
  }

  /// Versión con coordenada alfanumérica (ej. "C5").
  static String? readCelda(Sheet sheet, String coordenada) {
    final idx = parseCoordenada(coordenada);
    return readCellStr(sheet, idx.rowIndex, idx.columnIndex);
  }
}
