import 'package:flutter/foundation.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;
import '../database/app_database.dart';

/// Un servicio especializado y optimizado encargado de generar la plantilla de
/// Excel premium del módulo de forma programática y 100% offline.
class ExcelTemplateGenerator {
  /// Genera y compila el libro de trabajo de Excel con todas las hojas, estilos
  /// y validaciones de datos requeridos a partir de la lista de carreras provista.
  static Future<List<int>> generate(List<Career> careers) async {
    debugPrint('[EXCEL GENERATOR] Iniciando compilación de hojas de cálculo...');

    // 1. Crear el libro de trabajo con Syncfusion
    final xlsio.Workbook workbook = xlsio.Workbook();

    // Estilos Globales Reutilizables
    final xlsio.Style titleStyle = workbook.styles.add('TitleStyle');
    titleStyle.backColor = '#1F4E79';
    titleStyle.fontColor = '#FFFFFF';
    titleStyle.fontName = 'Arial';
    titleStyle.fontSize = 14;
    titleStyle.bold = true;
    titleStyle.hAlign = xlsio.HAlignType.center;
    titleStyle.vAlign = xlsio.VAlignType.center;
    titleStyle.borders.all.lineStyle = xlsio.LineStyle.thin;
    titleStyle.borders.all.color = '#BFBFBF';

    final xlsio.Style headerStyle = workbook.styles.add('HeaderStyle');
    headerStyle.backColor = '#1F4E79';
    headerStyle.fontColor = '#FFFFFF';
    headerStyle.fontName = 'Arial';
    headerStyle.fontSize = 11;
    headerStyle.bold = true;
    headerStyle.hAlign = xlsio.HAlignType.center;
    headerStyle.vAlign = xlsio.VAlignType.center;
    headerStyle.borders.all.lineStyle = xlsio.LineStyle.thin;
    headerStyle.borders.all.color = '#BFBFBF';

    final xlsio.Style accentLabelStyle = workbook.styles.add('AccentLabelStyle');
    accentLabelStyle.backColor = '#D9E1F2';
    accentLabelStyle.fontColor = '#000000';
    accentLabelStyle.fontName = 'Arial';
    accentLabelStyle.fontSize = 10;
    accentLabelStyle.bold = true;
    accentLabelStyle.borders.all.lineStyle = xlsio.LineStyle.thin;
    accentLabelStyle.borders.all.color = '#BFBFBF';

    final xlsio.Style regularValueStyle = workbook.styles.add('RegularValueStyle');
    regularValueStyle.fontName = 'Arial';
    regularValueStyle.fontSize = 10;
    regularValueStyle.borders.all.lineStyle = xlsio.LineStyle.thin;
    regularValueStyle.borders.all.color = '#BFBFBF';

    final xlsio.Style regularItalicStyle = workbook.styles.add('RegularItalicStyle');
    regularItalicStyle.fontName = 'Arial';
    regularItalicStyle.fontSize = 9;
    regularItalicStyle.italic = true;
    regularItalicStyle.fontColor = '#7F7F7F';
    regularItalicStyle.borders.all.lineStyle = xlsio.LineStyle.thin;
    regularItalicStyle.borders.all.color = '#BFBFBF';

    // -------------------------------------------------------------
    // HOJA 1: INFORMACION GENERAL
    // -------------------------------------------------------------
    final xlsio.Worksheet ws1 = workbook.worksheets[0];
    ws1.name = 'INFORMACION GENERAL';
    ws1.showGridlines = true;

    // Ajustar anchos de columnas
    ws1.getRangeByIndex(1, 1).columnWidth = 30.0;
    ws1.getRangeByIndex(1, 2).columnWidth = 45.0;
    ws1.getRangeByIndex(1, 3).columnWidth = 30.0;

    // Altura del título
    ws1.setRowHeightInPixels(1, 40);

    // Título Merged A1:C1
    final titleRange = ws1.getRangeByName('A1:C1');
    titleRange.merge();
    titleRange.setText('INFORMACIÓN GENERAL DEL MÓDULO');
    titleRange.cellStyle = titleStyle;

    // Encabezados
    ws1.setRowHeightInPixels(3, 25);
    final hA3 = ws1.getRangeByName('A3');
    hA3.setText('CAMPO');
    hA3.cellStyle = headerStyle;

    final hB3 = ws1.getRangeByName('B3');
    hB3.setText('VALOR (RELLENE AQUÍ)');
    hB3.cellStyle = headerStyle;

    final hC3 = ws1.getRangeByName('C3');
    hC3.setText('INSTRUCCIONES / EJEMPLO');
    hC3.cellStyle = headerStyle;

    // Filas de Datos
    final fields = [
      ['MÓDULO FORMATIVO', 'Ej: Infraestructura de red'],
      ['CÓDIGO', 'MF 180_2'],
      ['CARRERA / PROGRAMA', 'Técnico General en computación'],
      ['HORAS RELOJ TOTALES', '72'],
      ['HORAS ACADÉMICAS TOTALES', '96'],
    ];

    for (int i = 0; i < fields.length; i++) {
      final row = i + 4;
      ws1.setRowHeightInPixels(row, 22);

      final labelCell = ws1.getRangeByIndex(row, 1);
      labelCell.setText(fields[i][0]);
      labelCell.cellStyle = accentLabelStyle;

      final valueCell = ws1.getRangeByIndex(row, 2);
      // Si es numérico (horas totales)
      if (i >= 3) {
        valueCell.number = double.tryParse(fields[i][1]) ?? 0;
      } else {
        valueCell.setText(fields[i][1]);
      }
      valueCell.cellStyle = regularValueStyle;

      final instCell = ws1.getRangeByIndex(row, 3);
      instCell.setText(fields[i].length > 2 ? fields[i][2] : '');
      instCell.cellStyle = regularItalicStyle;
    }

    // -------------------------------------------------------------
    // HOJA 2: UNIDADES DIDÁCTICAS
    // -------------------------------------------------------------
    final xlsio.Worksheet ws2 = workbook.worksheets.addWithName('UNIDADES DIDÁCTICAS');
    ws2.showGridlines = true;

    ws2.getRangeByIndex(1, 1).columnWidth = 22.0;
    ws2.getRangeByIndex(1, 2).columnWidth = 50.0;
    ws2.getRangeByIndex(1, 3).columnWidth = 16.0;
    ws2.getRangeByIndex(1, 4).columnWidth = 20.0;
    ws2.getRangeByIndex(1, 5).columnWidth = 18.0;

    ws2.setRowHeightInPixels(1, 40);
    final titleRange2 = ws2.getRangeByName('A1:E1');
    titleRange2.merge();
    titleRange2.setText('REGISTRO DE UNIDADES DIDÁCTICAS (UD)');
    titleRange2.cellStyle = titleStyle;

    final headersWS2 = [
      'NÚMERO DE UNIDAD',
      'DENOMINACIÓN DE LA UNIDAD',
      'HORAS RELOJ',
      'HORAS ACADÉMICAS',
      'PONDERACIÓN (%)',
    ];
    ws2.setRowHeightInPixels(3, 25);
    for (int c = 0; c < headersWS2.length; c++) {
      final cell = ws2.getRangeByIndex(3, c + 1);
      cell.setText(headersWS2[c]);
      cell.cellStyle = headerStyle;
    }

    final dummyUnits = [
      [1, 'Unidad I: Fundamentos y Diseño Entidad-Relación', 18, 24, 25.0],
      [2, 'Unidad II: Modelo Relacional y Normalización', 18, 24, 25.0],
      [3, 'Unidad III: Lenguaje SQL y Consultas Complejas', 21, 28, 30.0],
      [4, 'Unidad IV: Procedimientos Almacenados y Triggers', 15, 20, 20.0],
    ];

    for (int i = 0; i < dummyUnits.length; i++) {
      final row = i + 4;
      ws2.setRowHeightInPixels(row, 22);
      for (int c = 0; c < dummyUnits[i].length; c++) {
        final cell = ws2.getRangeByIndex(row, c + 1);
        final val = dummyUnits[i][c];
        if (val is num) {
          cell.number = val.toDouble();
          if (c == 0) {
            cell.cellStyle.hAlign = xlsio.HAlignType.center;
          } else {
            cell.cellStyle.hAlign = xlsio.HAlignType.right;
          }
        } else {
          cell.setText(val.toString());
        }
        cell.cellStyle = regularValueStyle;
      }
    }

    // -------------------------------------------------------------
    // HOJA 3: ACTIVIDADES DE APRENDIZAJE
    // -------------------------------------------------------------
    final xlsio.Worksheet ws3 = workbook.worksheets.addWithName('ACTIVIDADES DE APRENDIZAJE');
    ws3.showGridlines = true;

    ws3.getRangeByIndex(1, 1).columnWidth = 22.0;
    ws3.getRangeByIndex(1, 2).columnWidth = 65.0;
    ws3.getRangeByIndex(1, 3).columnWidth = 35.0;
    ws3.getRangeByIndex(1, 4).columnWidth = 16.0;
    ws3.getRangeByIndex(1, 5).columnWidth = 20.0;

    ws3.setRowHeightInPixels(1, 40);
    final titleRange3 = ws3.getRangeByName('A1:E1');
    titleRange3.merge();
    titleRange3.setText('REGISTRO DE ACTIVIDADES DE APRENDIZAJE');
    titleRange3.cellStyle = titleStyle;

    final headersWS3 = [
      'NÚMERO DE ACTIVIDAD',
      'DESCRIPCIÓN DE LA ACTIVIDAD',
      'NÚMERO DE UNIDAD PERTENECIENTE',
      'HORAS RELOJ',
      'HORAS ACADÉMICAS',
    ];
    ws3.setRowHeightInPixels(3, 25);
    for (int c = 0; c < headersWS3.length; c++) {
      final cell = ws3.getRangeByIndex(3, c + 1);
      cell.setText(headersWS3[c]);
      cell.cellStyle = headerStyle;
    }

    final dummyActivities = [
      ['A1', 'Elaborar un diagrama entidad-relación para un caso de estudio hospitalario.', 1, 4, 6],
      ['A2', 'Realizar la conversión del diagrama entidad-relación a tablas relacionales.', 1, 4, 6],
      ['A3', 'Crear la estructura física de la base de datos aplicando restricciones (DDL).', 2, 6, 8],
      ['A4', 'Diseñar y ejecutar consultas avanzadas usando INNER JOIN, subconsultas y agrupaciones.', 3, 8, 10],
      ['A5', 'Construir procedimientos almacenados para la inserción y auditoría de datos.', 4, 6, 8],
    ];

    for (int i = 0; i < dummyActivities.length; i++) {
      final row = i + 4;
      ws3.setRowHeightInPixels(row, 22);
      for (int c = 0; c < dummyActivities[i].length; c++) {
        final cell = ws3.getRangeByIndex(row, c + 1);
        final val = dummyActivities[i][c];
        if (val is num) {
          cell.number = val.toDouble();
          cell.cellStyle.hAlign = xlsio.HAlignType.center;
        } else {
          cell.setText(val.toString());
        }
        cell.cellStyle = regularValueStyle;
      }
    }

    // -------------------------------------------------------------
    // HOJA 4: CARRERAS_DB (Dynamic Reference Sheet)
    // -------------------------------------------------------------
    final xlsio.Worksheet ws4 = workbook.worksheets.addWithName('CARRERAS_DB');
    ws4.showGridlines = true;
    ws4.getRangeByIndex(1, 1).columnWidth = 35.0;

    final cA1 = ws4.getRangeByName('A1');
    cA1.setText('Programas Registrados');
    cA1.cellStyle.fontName = 'Arial';
    cA1.cellStyle.fontSize = 11;
    cA1.cellStyle.bold = true;

    if (careers.isEmpty) {
      ws4.getRangeByName('A2').setText('Debe registrar carreras en la App');
    } else {
      for (int i = 0; i < careers.length; i++) {
        final row = i + 2;
        ws4.getRangeByIndex(row, 1).setText(careers[i].nombre);
      }
    }

    // Ocultar la hoja CARRERAS_DB para que sea una experiencia premium
    ws4.visibility = xlsio.WorksheetVisibility.hidden;

    // -------------------------------------------------------------
    // DATA VALIDATION (Lista desplegable en B6 de la Hoja 1)
    // -------------------------------------------------------------
    final xlsio.DataValidation validation = ws1.getRangeByName('B6').dataValidation;
    validation.allowType = xlsio.ExcelDataValidationType.user;
    validation.listOfValues = careers.isEmpty
        ? ['Debe registrar carreras en la App']
        : careers.map((c) => c.nombre).toList();
    validation.promptBoxText = 'Seleccione una carrera de la lista desplegable';
    validation.showPromptBox = true;
    validation.errorBoxText = 'Debe seleccionar una carrera válida registrada en la aplicación';
    validation.showErrorBox = true;

    debugPrint('[EXCEL GENERATOR] Datos y validaciones inyectadas de forma exitosa.');

    // Guardar el libro completo a bytes
    final List<int> updatedBytes = workbook.saveAsStream();
    workbook.dispose();

    debugPrint('[EXCEL GENERATOR] Excel generado con éxito (${updatedBytes.length} bytes).');
    return updatedBytes;
  }
}
