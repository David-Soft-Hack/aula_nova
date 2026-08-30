import 'dart:io';
import 'dart:ui' as ui;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import '../models/bitacora_export_data.dart';
import '../models/docente_data.dart';
import '../services/cuaderno_docente_service.dart';
import '../database/tables.dart';

/// Servicio de exportación de bitácoras a Excel y PDF.
///
/// Genera archivos nativos usando Syncfusion para PDF y el paquete excel para rellenar la plantilla.
class BitacoraExportService {
  static final DateFormat _dateFmt = DateFormat('dd/MM/yyyy', 'es');
  static final DateFormat _datetimeFmt = DateFormat('dd/MM/yyyy HH:mm', 'es');

  // ─── Excel ────────────────────────────────────────────────────────────────

  /// Genera un archivo `.xlsx` rellenando la plantilla `Plan Bitacora.xlsx` de los assets.
  /// Retorna la ruta del archivo guardado.
  Future<File> exportToExcel(BitacoraExportData data) async {
    final docenteData = DocenteData.fromBitacoraExportData(data);
    final service = CuadernoDocenteService();
    // Pasar el nombre único de la bitácora para evitar sobrescribir archivos anteriores
    return service.generarBitacora(docenteData, outputFileName: '${data.safeFileName}.xlsx');
  }


  // ─── PDF ──────────────────────────────────────────────────────────────────

  /// Genera un archivo `.pdf` con portada y tabla de sesiones.
  /// Retorna la ruta del archivo guardado.
  Future<File> exportToPdf(BitacoraExportData data) async {
    final document = PdfDocument();
    document.pageSettings.margins.all = 36;
    document.pageSettings.size = PdfPageSize.a4;

    // Fuentes
    final subtitleFont = PdfStandardFont(PdfFontFamily.helvetica, 12, style: PdfFontStyle.bold);
    final bodyFont    = PdfStandardFont(PdfFontFamily.helvetica, 10);
    final boldFont    = PdfStandardFont(PdfFontFamily.helvetica, 10, style: PdfFontStyle.bold);
    final smallFont   = PdfStandardFont(PdfFontFamily.helvetica, 8);
    final smallItalic = PdfStandardFont(PdfFontFamily.helvetica, 8, style: PdfFontStyle.italic);

    // Colores
    final headerColor  = PdfColor(29, 78, 216);   // #1D4ED8 academic700
    final accentColor  = PdfColor(37, 99, 235);   // #2563EB academic600
    final lightBg      = PdfColor(239, 246, 255); // #EFF6FF
    final successColor = PdfColor(22, 163, 74);   // #16A34A
    final warningColor = PdfColor(217, 119, 6);   // #D97706
    final grayColor    = PdfColor(100, 116, 139);  // #64748B
    final evenRowBg    = PdfColor(248, 250, 252);  // #F8FAFC
    final whiteColor   = PdfColor(255, 255, 255);
    final evalColor    = PdfColor(234, 88, 12);   // naranja evaluativa

    // ── Página 1: Portada / Info General ──
    final page1 = document.pages.add();
    final g1 = page1.graphics;
    final pageWidth = page1.getClientSize().width;

    // Banda de título
    g1.drawRectangle(
      brush: PdfSolidBrush(headerColor),
      bounds: ui.Rect.fromLTWH(0, 0, pageWidth, 80),
    );
    g1.drawString(
      'BITÁCORA DE MÓDULO FORMATIVO',
      PdfStandardFont(PdfFontFamily.helvetica, 14, style: PdfFontStyle.bold),
      brush: PdfBrushes.white,
      bounds: ui.Rect.fromLTWH(0, 12, pageWidth, 30),
      format: PdfStringFormat(alignment: PdfTextAlignment.center),
    );
    g1.drawString(
      data.module.nombre,
      PdfStandardFont(PdfFontFamily.helvetica, 11),
      brush: PdfBrushes.white,
      bounds: ui.Rect.fromLTWH(0, 44, pageWidth, 28),
      format: PdfStringFormat(alignment: PdfTextAlignment.center),
    );

    // Tarjeta de progreso
    double y = 100;
    g1.drawRectangle(
      brush: PdfSolidBrush(lightBg),
      pen: PdfPen(accentColor, width: 1),
      bounds: ui.Rect.fromLTWH(0, y, pageWidth, 60),
    );
    final progressPct = '${(data.progress * 100).toStringAsFixed(1)}%';
    g1.drawString(
      'PROGRESO: $progressPct  •  ${data.sessionsCompleted.length} de ${data.sessions.length} sesiones impartidas',
      subtitleFont,
      brush: PdfSolidBrush(accentColor),
      bounds: ui.Rect.fromLTWH(12, y + 12, pageWidth - 24, 24),
    );
    // Barra de progreso
    g1.drawRectangle(
      brush: PdfSolidBrush(PdfColor(226, 232, 240)),
      bounds: ui.Rect.fromLTWH(12, y + 40, pageWidth - 24, 8),
    );
    g1.drawRectangle(
      brush: PdfSolidBrush(accentColor),
      bounds: ui.Rect.fromLTWH(12, y + 40, (pageWidth - 24) * data.progress, 8),
    );

    // Información general
    y = 180;
    final infoFields = [
      ['Módulo Formativo', data.module.nombre],
      ['Código', data.module.codModule],
      ['Carrera / Programa', data.bitacora.carrera],
      ['Código de Grupo', data.bitacora.codigoGrupo ?? '—'],
      ['Fecha de Inicio', _dateFmt.format(data.bitacora.fechaInicio)],
      ['Fecha de Finalización', data.bitacora.fechaFinal != null ? _dateFmt.format(data.bitacora.fechaFinal!) : '—'],
      ['Tipo de Horas', data.bitacora.usarHorasReloj ? 'Horas Reloj (HR)' : 'Horas Académicas (HA)'],
      ['Frecuencia de Clase', '${data.bitacora.frecuenciaClase} horas/sesión'],
      ['Estado', data.bitacora.estado == EstadoBitacora.finalizado ? 'Finalizada' : 'Activa'],
      ['Días de Clase', data.bitacora.diasClase.join(', ')],
    ];

    g1.drawString('INFORMACIÓN GENERAL', subtitleFont,
        brush: PdfSolidBrush(headerColor), bounds: ui.Rect.fromLTWH(0, y, pageWidth, 20));
    y += 24;
    g1.drawLine(PdfPen(accentColor, width: 1), ui.Offset(0, y), ui.Offset(pageWidth, y));
    y += 8;

    for (final field in infoFields) {
      g1.drawRectangle(
        brush: PdfSolidBrush(lightBg),
        bounds: ui.Rect.fromLTWH(0, y, 160, 18),
      );
      g1.drawString(field[0], boldFont,
          brush: PdfSolidBrush(PdfColor(30, 64, 175)),
          bounds: ui.Rect.fromLTWH(4, y + 2, 155, 14));
      g1.drawString(field[1], bodyFont,
          brush: PdfBrushes.black,
          bounds: ui.Rect.fromLTWH(168, y + 2, pageWidth - 168, 14));
      y += 22;
    }

    // Fecha de generación en la portada
    y += 12;
    g1.drawString(
      'Generado el ${_datetimeFmt.format(DateTime.now())}',
      smallItalic,
      brush: PdfSolidBrush(grayColor),
      bounds: ui.Rect.fromLTWH(0, y, pageWidth, 14),
    );

    // ── Páginas de Sesiones ──
    final sessions = data.sessions;
    final colWidths = [30.0, 72.0, 60.0, 140.0, 44.0, 68.0, 55.0, 44.0];
    final colHeaders = ['N°', 'Fecha', 'Unidad', 'Actividad', 'Horas', 'Estado', 'Eval.', 'Puntaje'];

    PdfPage? page;
    PdfGraphics? g;
    double pageY = 0;
    double pageHeight = 0;

    void startNewPage({bool isFirst = false}) {
      page = document.pages.add();
      g = page!.graphics;
      pageHeight = page!.getClientSize().height;
      pageY = 0;

      if (!isFirst) {
        // Encabezado de continuación
        g!.drawRectangle(
          brush: PdfSolidBrush(headerColor),
          bounds: ui.Rect.fromLTWH(0, pageY, pageWidth, 28),
        );
        g!.drawString('DOSIFICACIÓN DE SESIONES — ${data.module.nombre}',
            PdfStandardFont(PdfFontFamily.helvetica, 9, style: PdfFontStyle.bold),
            brush: PdfBrushes.white,
            bounds: ui.Rect.fromLTWH(4, pageY + 6, pageWidth - 8, 16));
        pageY += 36;
      }

      // Encabezados de columna
      double colX = 0;
      for (int c = 0; c < colHeaders.length; c++) {
        g!.drawRectangle(
          brush: PdfSolidBrush(headerColor),
          bounds: ui.Rect.fromLTWH(colX, pageY, colWidths[c], 22),
        );
        g!.drawString(colHeaders[c], PdfStandardFont(PdfFontFamily.helvetica, 8, style: PdfFontStyle.bold),
            brush: PdfBrushes.white,
            bounds: ui.Rect.fromLTWH(colX + 2, pageY + 4, colWidths[c] - 4, 14),
            format: PdfStringFormat(alignment: PdfTextAlignment.center));
        colX += colWidths[c];
      }
      pageY += 24;
    }

    // Título de la sección de sesiones
    final page2 = document.pages.add();
    final g2 = page2.graphics;
    double sesY = 0;
    g2.drawRectangle(
      brush: PdfSolidBrush(headerColor),
      bounds: ui.Rect.fromLTWH(0, sesY, pageWidth, 36),
    );
    g2.drawString(
      'DOSIFICACIÓN DE SESIONES',
      PdfStandardFont(PdfFontFamily.helvetica, 14, style: PdfFontStyle.bold),
      brush: PdfBrushes.white,
      bounds: ui.Rect.fromLTWH(0, sesY + 8, pageWidth, 20),
      format: PdfStringFormat(alignment: PdfTextAlignment.center),
    );
    sesY += 44;

    // Encabezados
    double colX = 0;
    for (int c = 0; c < colHeaders.length; c++) {
      g2.drawRectangle(
        brush: PdfSolidBrush(headerColor),
        bounds: ui.Rect.fromLTWH(colX, sesY, colWidths[c], 22),
      );
      g2.drawString(colHeaders[c], PdfStandardFont(PdfFontFamily.helvetica, 8, style: PdfFontStyle.bold),
          brush: PdfBrushes.white,
          bounds: ui.Rect.fromLTWH(colX + 2, sesY + 4, colWidths[c] - 4, 14),
          format: PdfStringFormat(alignment: PdfTextAlignment.center));
      colX += colWidths[c];
    }
    sesY += 24;

    page = page2;
    g = g2;
    pageY = sesY;
    pageHeight = page2.getClientSize().height;

    for (int i = 0; i < sessions.length; i++) {
      final session = sessions[i];
      const rowH = 18.0;

      if (pageY + rowH > pageHeight - 20) {
        // Footer de página
        g!.drawString(
          'Generado: ${_datetimeFmt.format(DateTime.now())}  |  Pág. ${document.pages.count}',
          smallItalic,
          brush: PdfSolidBrush(grayColor),
          bounds: ui.Rect.fromLTWH(0, pageHeight - 14, pageWidth, 12),
        );
        startNewPage();
      }

      final isEven = i.isEven;
      final rowBg = isEven ? evenRowBg : whiteColor;

      final dateStr = session.fechaProgramada != null
          ? _dateFmt.format(session.fechaProgramada!)
          : '—';
      final unitName = session.codUnidad != null
          ? (data.unitNames[session.codUnidad!] ?? session.codUnidad!)
          : '—';
      final actName = session.codActividad != null
          ? (data.activityNames[session.codActividad!] ?? session.codActividad!)
          : '—';
      final hoursLabel = data.bitacora.usarHorasReloj ? 'HR' : 'HA';
      final hoursStr = '${session.horaImpartir ?? 0} $hoursLabel';
      final stateStr = session.estadoImpartido ? 'Impartida' : 'Pendiente';
      final evalStr = session.esEvaluativa ? 'Sí' : 'No';
      final puntajeStr = (session.esEvaluativa && session.puntaje != null)
          ? session.puntaje!.toStringAsFixed(1)
          : '—';

      final rowValues = [
        '${i + 1}',
        dateStr,
        unitName,
        actName,
        hoursStr,
        stateStr,
        evalStr,
        puntajeStr,
      ];

      double cx = 0;
      for (int c = 0; c < rowValues.length; c++) {
        g!.drawRectangle(
          brush: PdfSolidBrush(
            c == 5
                ? (session.estadoImpartido ? PdfColor(220, 252, 231) : PdfColor(254, 243, 199))
                : (session.esEvaluativa ? PdfColor(255, 247, 237) : rowBg),
          ),
          bounds: ui.Rect.fromLTWH(cx, pageY, colWidths[c], rowH),
        );
        g!.drawString(
          rowValues[c],
          c == 5
              ? PdfStandardFont(PdfFontFamily.helvetica, 8, style: PdfFontStyle.bold)
              : smallFont,
          brush: PdfSolidBrush(
            c == 5
                ? (session.estadoImpartido ? successColor : warningColor)
                : (c == 6 && session.esEvaluativa ? evalColor : PdfColor(15, 23, 42)),
          ),
          bounds: ui.Rect.fromLTWH(cx + 2, pageY + 3, colWidths[c] - 4, rowH - 4),
          format: PdfStringFormat(
            alignment: (c == 0 || c == 4 || c == 6 || c == 7)
                ? PdfTextAlignment.center
                : PdfTextAlignment.left,
            lineSpacing: 1,
          ),
        );
        cx += colWidths[c];
      }

      pageY += rowH;
    }

    // Footer de la última página
    g!.drawLine(
      PdfPen(accentColor, width: 0.5),
      ui.Offset(0, pageHeight - 20),
      ui.Offset(pageWidth, pageHeight - 20),
    );
    g!.drawString(
      'Generado: ${_datetimeFmt.format(DateTime.now())}  |  AulaNova — Bitácora: ${data.module.nombre}',
      smallItalic,
      brush: PdfSolidBrush(grayColor),
      bounds: ui.Rect.fromLTWH(0, pageHeight - 16, pageWidth, 12),
    );

    // â”€â”€ Guardar â”€â”€
    final bytes = await document.save();
    document.dispose();

    return _saveFile('${data.safeFileName}.pdf', bytes);
  }

  // â”€â”€â”€ Helper de guardado â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  Future<File> _saveFile(String fileName, List<int> bytes) async {
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
