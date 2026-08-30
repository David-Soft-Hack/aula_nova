import 'dart:io';
import 'dart:typed_data';
import 'package:excel/excel.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import '../models/docente_data.dart';
import '../utils/excel_cell_helper.dart';

/// Servicio principal para la generación automática del **Cuaderno Docente**.
///
/// Toma una plantilla `Plan Bitacora.xlsx` desde los assets de la app,
/// escribe los datos de [DocenteData] en las celdas correspondientes de
/// cada hoja y guarda el resultado como un nuevo archivo `.xlsx`, dejando
/// la plantilla original intacta.
///
/// ## Arquitectura
/// El servicio es **stateless**: cada llamada a [generarBitacora] carga la
/// plantilla desde cero. Esto garantiza que nunca se contaminan datos entre
/// generaciones sucesivas.
///
/// ## Extensibilidad
/// Para agregar soporte de nuevas hojas del cuaderno docente:
/// 1. Implementar el método privado correspondiente (ver stubs al final del archivo).
/// 2. Invocarlo desde [generarBitacora] después de [_llenarHojaPlanCalendario].
class CuadernoDocenteService {
  static const String _assetPath = 'assets/Plan Bitacora.xlsx';
  static const String _defaultOutputFileName = 'Bitacora_GENERADA.xlsx';
  static final DateFormat _dateFmt = DateFormat('dd/MM/yyyy', 'es');

  // Filas de la plantilla que contienen el bloque de firma (0-based)
  // Fila 35 = idx 34 → "Nombre y Firma del Docente"
  // Fila 36 = idx 35 → línea de firma
  static const int _templateFooterStartIdx = 34;
  static const int _templateFooterEndIdx   = 35;

  // Fila de inicio de datos en la plantilla (0-based = Excel fila 15)
  static const int _dataStartRowIdx = 14;

  // El template pre-asigna 19 filas de datos (filas 15–33 = idx 14–32).

  // ─── API pública ──────────────────────────────────────────────────────────

  /// Genera el cuaderno docente completo y retorna el [File] guardado.
  ///
  /// Proceso:
  ///   1. Carga la plantilla desde assets.
  ///   2. Llena cada hoja con los datos de [data].
  ///   3. Guarda el resultado en el directorio de documentos de la app.
  ///
  /// [outputFileName] permite personalizar el nombre del archivo .xlsx resultante.
  /// Si se omite, se usa el nombre por defecto `Bitacora_GENERADA.xlsx`.
  Future<File> generarBitacora(DocenteData data, {String? outputFileName}) async {
    // 1. Cargar la plantilla desde assets (bytes)
    final byteData = await rootBundle.load(_assetPath);
    final templateBytes = byteData.buffer.asUint8List();
    return _procesarPlantilla(templateBytes, data, outputFileName: outputFileName);
  }

  /// Genera el cuaderno docente a partir de bytes de plantilla ya cargados.
  /// Útil cuando el usuario selecciona la plantilla manualmente.
  Future<File> generarDesdeBytes(Uint8List templateBytes, DocenteData data, {String? outputFileName}) {
    return _procesarPlantilla(templateBytes, data, outputFileName: outputFileName);
  }

  // ─── Escritura pública de celdas ─────────────────────────────────────────

  /// Escribe [valor] en la celda [coordenada] de la hoja [hoja] del [excel].
  ///
  /// Manejo de seguridad:
  /// - Si la hoja no existe, no hace nada.
  /// - Si la coordenada es inválida, no hace nada.
  /// - En celdas combinadas, escribir siempre sobre la celda superior-izquierda
  ///   del rango (ej. si G14:I14 están combinadas, escribir en G14).
  void llenarCelda(
    Excel excel,
    String hoja,
    String coordenada,
    dynamic valor,
  ) {
    final sheet = excel.tables[hoja];
    if (sheet == null) return;
    try {
      final idx = ExcelCellHelper.parseCoordenada(coordenada);
      ExcelCellHelper.safeCellWrite(sheet, idx.rowIndex, idx.columnIndex, valor);
    } on ArgumentError {
      // coordenada inválida — ignorar silenciosamente
    } catch (_) {
      // error inesperado — ignorar silenciosamente
    }
  }

  /// Llena una tabla dinámica en la hoja [hoja] a partir de [filaInicial].
  ///
  /// [datos] es la lista de elementos a insertar.
  /// [mapper] convierte cada elemento en un `Map<int, dynamic>` donde la
  /// clave es el índice 0-based de la columna.
  void llenarTabla<T>({
    required Excel excel,
    required String hoja,
    required int filaInicial,
    required List<T> datos,
    required Map<int, dynamic> Function(T item) mapper,
  }) {
    final sheet = excel.tables[hoja];
    if (sheet == null) return;
    for (int i = 0; i < datos.length; i++) {
      final row = filaInicial + i;
      final values = mapper(datos[i]);
      values.forEach((col, value) {
        ExcelCellHelper.safeCellWrite(sheet, row, col, value);
      });
    }
  }

  // ─── Procesamiento interno ────────────────────────────────────────────────

  Future<File> _procesarPlantilla(Uint8List templateBytes, DocenteData data, {String? outputFileName}) async {
    final excel = Excel.decodeBytes(templateBytes);

    if (excel.tables.isEmpty) {
      throw Exception('La plantilla Excel está vacía o corrupta.');
    }

    // ── Llenar cada sección del cuaderno docente ──
    _llenarHojaPlanCalendario(excel, data);

    // Stubs para futuras hojas (ver métodos al final del archivo)
    // _llenarHojaPortada(excel, data);
    // _llenarHojaCalificaciones(excel, data);
    // _llenarHojaAsistencia(excel, data);
    // _llenarHojaSeguimiento(excel, data);
    // _llenarHojaPlaneacion(excel, data);
    // _llenarHojaConsolidado(excel, data);

    // ── Codificar y guardar ──
    final fileBytes = excel.encode();
    if (fileBytes == null) {
      throw Exception('Error al codificar el archivo Excel resultante.');
    }
    final fileName = outputFileName ?? _defaultOutputFileName;
    return _guardarArchivo(fileName, fileBytes);
  }

  // ─── Hoja: Plan calendario ────────────────────────────────────────────────

  /// Llena la hoja principal de dosificación y planificación de clases.
  ///
  /// ### Estrategia de footer dinámico
  ///
  /// El template tiene el bloque de firma (Nombre y Firma del Docente) fijo
  /// en las filas 35–36 (índice 34–35). Esto funciona cuando hay ≤ 19
  /// actividades (filas 15–33). Si hay más de 19, los datos sobreescribirían
  /// el footer.
  ///
  /// Solución:
  ///   1. Leer el contenido del footer desde las filas fijas de la plantilla
  ///      ANTES de hacer cualquier modificación.
  ///   2. Limpiar todo el rango de datos + footer de la plantilla.
  ///   3. Escribir los datos de actividades desde la fila 15 (idx 14).
  ///   4. Escribir el footer a continuación de la última actividad, con una
  ///      fila de separación en blanco.
  void _llenarHojaPlanCalendario(Excel excel, DocenteData data) {
    // ── Detección flexible del nombre de la hoja ──
    final hojaKey = _detectarHoja(excel, 'calendario') ??
                    _detectarHoja(excel, 'plan') ??
                    excel.tables.keys.first;

    final sheet = excel.tables[hojaKey]!;

    // ── Sección I: Datos generales ──────────────────────────────────────────
    _write(sheet, 4, 2,  data.centro);              // C5  → Centro educativo
    _write(sheet, 5, 2,  data.carrera);             // C6  → Carrera
    _write(sheet, 6, 2,  data.modulo);              // C7  → Módulo formativo
    _write(sheet, 5, 9,  data.grupo);               // J6  → Código de grupo
    _write(sheet, 7, 2,  data.horas);               // C8  → Carga horaria
    _write(sheet, 7, 6,  data.fechaInicioStr);      // G8  → Fecha de inicio
    _write(sheet, 7, 10, data.fechaFinStr);         // K8  → Fecha de finalización

    final needsFooterMove = data.actividades.length > 19;
    List<List<_FooterCell>>? footerRows;

    // ── Sección II: Lectura y preparación del footer si se requiere desplazar ──
    if (needsFooterMove) {
      footerRows = _leerFooter(sheet);

      // Descombinar celdas del footer original para evitar conflictos
      sheet.unMerge('A35:D35');
      sheet.unMerge('A36:D36');

      // Limpiar los valores de las celdas del footer original
      for (int r = _templateFooterStartIdx; r <= _templateFooterEndIdx; r++) {
        for (int c = 0; c <= 11; c++) {
          sheet.cell(CellIndex.indexByColumnRow(columnIndex: c, rowIndex: r)).value = null;
        }
      }
    } else {
      // Si no movemos el footer, limpiamos los valores de las celdas de datos no usadas
      // dentro de las 19 filas originales (indices 14 a 32).
      final startClearRow = _dataStartRowIdx + data.actividades.length;
      for (int r = startClearRow; r <= 32; r++) {
        for (int c = 0; c <= 11; c++) {
          sheet.cell(CellIndex.indexByColumnRow(columnIndex: c, rowIndex: r)).value = null;
        }
      }
    }

    // ── Sección III: Escritura de actividades ─────────────────────────────────
    for (int i = 0; i < data.actividades.length; i++) {
      final act    = data.actividades[i];
      final rowIdx = _dataStartRowIdx + i;

      // Si es una fila nueva más allá del rango pre-diseñado (idx > 32),
      // copiamos el estilo de la fila 32 para mantener bordes y fuentes.
      if (rowIdx > 32) {
        for (int c = 0; c <= 11; c++) {
          final sourceCell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: c, rowIndex: 32));
          final targetCell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: c, rowIndex: rowIdx));
          targetCell.cellStyle = sourceCell.cellStyle;
        }
      }

      _write(sheet, rowIdx, 0, act.unidad);      // A → Unidad
      _write(sheet, rowIdx, 1, act.actividad);   // B → Actividad
      _write(sheet, rowIdx, 2, act.horas);       // C → Horas
      _write(sheet, rowIdx, 3,                   // D → Fecha
          act.fecha != null ? _dateFmt.format(act.fecha!) : '');

      // E → Si impartido / F → No impartido
      if (act.seImpartio) {
        _write(sheet, rowIdx, 4, 'X');  // Si
        _write(sheet, rowIdx, 5, '');   // No
      } else {
        _write(sheet, rowIdx, 4, '');   // Si
        _write(sheet, rowIdx, 5, 'X');  // No
      }

      // G → Incidencias (celda combinada G:I → escribir en col 6)
      _write(sheet, rowIdx, 6, act.incidencias.isEmpty ? '' : act.incidencias);

      // J → Estrategia (celda combinada J:L → escribir en col 9)
      _write(sheet, rowIdx, 9, act.estrategia.isEmpty ? '' : act.estrategia);

      // Combinar celdas de incidencias y estrategia en filas nuevas
      if (rowIdx > 32) {
        sheet.merge(
          CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: rowIdx),
          CellIndex.indexByColumnRow(columnIndex: 8, rowIndex: rowIdx),
        );
        sheet.merge(
          CellIndex.indexByColumnRow(columnIndex: 9, rowIndex: rowIdx),
          CellIndex.indexByColumnRow(columnIndex: 11, rowIndex: rowIdx),
        );
      }
    }

    // ── Sección IV: Escritura del footer desplazado (si aplica) ───────────────
    if (needsFooterMove && footerRows != null) {
      final lastDataRowIdx = _dataStartRowIdx + data.actividades.length - 1;
      final footerTargetStart = lastDataRowIdx + 2; // dejamos una fila en blanco
      _escribirFooter(sheet, footerRows, footerTargetStart);
    }
  }

  // ─── Helpers de footer ────────────────────────────────────────────────────

  List<List<_FooterCell>> _leerFooter(Sheet sheet) {
    final result = <List<_FooterCell>>[];
    for (int r = _templateFooterStartIdx; r <= _templateFooterEndIdx; r++) {
      final rowData = <_FooterCell>[];
      for (int c = 0; c <= 11; c++) {
        final cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: c, rowIndex: r));
        rowData.add(_FooterCell(cell.value, cell.cellStyle));
      }
      result.add(rowData);
    }
    return result;
  }

  void _escribirFooter(Sheet sheet, List<List<_FooterCell>> footerRows, int startRowIdx) {
    for (int i = 0; i < footerRows.length; i++) {
      final row = footerRows[i];
      final targetRow = startRowIdx + i;
      for (int c = 0; c < row.length; c++) {
        final footerCell = row[c];
        final targetCell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: c, rowIndex: targetRow));
        targetCell.value = footerCell.value;
        if (footerCell.style != null) {
          targetCell.cellStyle = footerCell.style;
        }
      }
      // Combinar celdas A:D para la firma
      sheet.merge(
        CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: targetRow),
        CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: targetRow),
      );
    }
  }

  // ─── Stubs — Futuras hojas del cuaderno docente ──────────────────────────

  /// TODO: Llenar la hoja de Portada del cuaderno docente.
  // ignore: unused_element
  void _llenarHojaPortada(Excel excel, DocenteData data) {}

  /// TODO: Llenar la hoja de Registro de Calificaciones.
  // ignore: unused_element
  void _llenarHojaCalificaciones(Excel excel, DocenteData data) {}

  /// TODO: Llenar la hoja de Control de Asistencia.
  // ignore: unused_element
  void _llenarHojaAsistencia(Excel excel, DocenteData data) {}

  /// TODO: Llenar la hoja de Seguimiento Académico.
  // ignore: unused_element
  void _llenarHojaSeguimiento(Excel excel, DocenteData data) {}

  /// TODO: Llenar la hoja de Planeación Didáctica.
  // ignore: unused_element
  void _llenarHojaPlaneacion(Excel excel, DocenteData data) {}

  /// TODO: Llenar la hoja de Consolidado Final.
  // ignore: unused_element
  void _llenarHojaConsolidado(Excel excel, DocenteData data) {}

  // ─── Helpers privados ─────────────────────────────────────────────────────

  void _write(Sheet sheet, int row, int col, dynamic value) {
    ExcelCellHelper.safeCellWrite(sheet, row, col, value);
  }

  String? _detectarHoja(Excel excel, String keyword) {
    final lower = keyword.toLowerCase();
    try {
      return excel.tables.keys.firstWhere(
        (name) => name.toLowerCase().contains(lower),
      );
    } catch (_) {
      return null;
    }
  }

  Future<File> _guardarArchivo(String fileName, List<int> bytes) async {
    final dir = await getApplicationDocumentsDirectory();
    final exportsDir = Directory('${dir.path}/exports');
    if (!await exportsDir.exists()) {
      await exportsDir.create(recursive: true);
    }
    final file = File('${exportsDir.path}/$fileName');
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }
}

/// Helper para almacenar temporalmente el valor y estilo de una celda del footer.
class _FooterCell {
  final dynamic value;
  final CellStyle? style;
  _FooterCell(this.value, this.style);
}
