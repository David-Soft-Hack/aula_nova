import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import '../../../controllers/career_controller.dart';
import '../../../models/app_models.dart';
import '../../../services/module_extractor.dart';
import '../../../services/excel_template_generator.dart';

class ModuleExcelHandler {
  static Future<void> pickAndImportExcel({
    required BuildContext context,
    required bool mounted,
    required ModuleExtractor extractor,
    required List<String> carreras,
    required TextEditingController nombreCtrl,
    required TextEditingController codCtrl,
    required TextEditingController haCtrl,
    required TextEditingController hrCtrl,
    required Function(bool processing) onProcessingChanged,
    required Function({
      required String importedExcelName,
      required String nombre,
      required String codigo,
      required String career,
      required List<Map<String, dynamic>> units,
      required List<Map<String, dynamic>> activities,
    }) onImportSuccess,
  }) async {
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx'],
      );

      if (!context.mounted) return;

      if (result != null && result.files.single.path != null) {
        final filePath = result.files.single.path!;
        final fileName = result.files.single.name;

        // Check if there is already manual data
        final hasManualData =
            nombreCtrl.text.trim().isNotEmpty ||
            codCtrl.text.trim().isNotEmpty;

        bool confirm = true;
        if (hasManualData) {
          confirm =
              await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  title: const Text(
                    '¿Reemplazar datos actuales?',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  content: const Text(
                    'Ya has ingresado información en el formulario. Si cargas este archivo de Excel, se borrarán todos los datos actuales y se reemplazarán con la información del archivo de Excel. ¿Deseas continuar?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text(
                        'Cancelar',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade600,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Reemplazar'),
                    ),
                  ],
                ),
              ) ??
              false;
          if (!context.mounted) return;
        }

        if (!confirm) return;

        onProcessingChanged(true);

        // Delegate to ExcelExtractorService using DIP (Dependency Inversion Principle)
        final parsedData = extractor.extract(filePath, fileName);

        if (!context.mounted) return;

        final normalizedCareer = parsedData.carrera.trim();
        final careerExists = carreras.any(
          (c) => c.trim().toLowerCase() == normalizedCareer.toLowerCase(),
        );

        if (normalizedCareer.isNotEmpty && !careerExists) {
          // Si el programa no existe en la base de datos, se agrega automáticamente
          await CareerController().addCareer(
            normalizedCareer,
            TipoCarrera.tecnica,
          );
          carreras.add(normalizedCareer);
        }

        String finalCareer = normalizedCareer;
        if (normalizedCareer.isNotEmpty) {
          finalCareer = carreras.firstWhere(
            (c) => c.trim().toLowerCase() == normalizedCareer.toLowerCase(),
            orElse: () => normalizedCareer,
          );
        }

        onImportSuccess(
          importedExcelName: fileName,
          nombre: parsedData.nombre,
          codigo: parsedData.codigo,
          career: finalCareer,
          units: parsedData.units.isNotEmpty
              ? parsedData.units
              : [
                  {'nombre': '', 'hr': 0, 'ha': 0, 'ponderacion': 0.0},
                ],
          activities: parsedData.activities.isNotEmpty
              ? parsedData.activities
              : [
                  {'unitIndex': 0, 'descripcion': '', 'hr': 0, 'ha': 0},
                ],
        );

        onProcessingChanged(false);

        if (!context.mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '¡Datos importados con éxito desde Excel: $fileName! 📊',
            ),
            backgroundColor: Colors.green.shade600,
          ),
        );
      }
    } catch (e) {
      if (!context.mounted) return;
      onProcessingChanged(false);

      String errorMessage = 'Error al importar Excel: $e';
      if (e is FormatException) {
        errorMessage = e.message;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red.shade600,
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  static Future<void> downloadExcelTemplate({
    required BuildContext context,
    required bool mounted,
    required Function(bool processing) onProcessingChanged,
  }) async {
    try {
      onProcessingChanged(true);

      debugPrint(
        '[EXCEL DOWNLOAD] Iniciando generación de plantilla premium...',
      );

      // Obtener carreras reales registradas en SQLite
      final careers = await DatabaseProvider.careerDao.getAllCareers();
      debugPrint(
        '[EXCEL DOWNLOAD] Carreras recuperadas de SQLite: ${careers.length} registradas.',
      );

      // Generar libro de trabajo programáticamente usando el nuevo servicio modularizado
      final List<int> updatedBytes = await ExcelTemplateGenerator.generate(
        careers,
      );

      // Get a directory to save the file safely without permission issues
      Directory? dir;
      if (Platform.isAndroid) {
        dir = await getExternalStorageDirectory();
      } else {
        dir = await getApplicationDocumentsDirectory();
      }

      dir ??= await getTemporaryDirectory();

      final savePath = '${dir.path}/planeacion_template.xlsx';
      final file = File(savePath);
      await file.writeAsBytes(updatedBytes);
      debugPrint(
        '[EXCEL DOWNLOAD] Archivo guardado físicamente en la ruta: $savePath',
      );

      onProcessingChanged(false);

      if (!context.mounted) return;

      // Show a gorgeous Premium Modal to open/view the downloaded Excel file!
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (sheetContext) {
          return Container(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32),
                topRight: Radius.circular(32),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Icon(
                  LucideIcons.fileSpreadsheet,
                  color: Colors.green.shade600,
                  size: 48,
                ),
                const SizedBox(height: 16),
                const Text(
                  '¡Plantilla Guardada!',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'El archivo de plantilla excel se guardó con éxito:',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade100),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        LucideIcons.folder,
                        color: Colors.amber.shade700,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          savePath,
                          style: TextStyle(
                            fontSize: 11,
                            fontFamily: 'monospace',
                            color: Colors.grey.shade700,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: () => Navigator.pop(sheetContext),
                        child: const Text('Entendido'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade600,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: () async {
                          final messenger = ScaffoldMessenger.of(sheetContext);
                          Navigator.pop(sheetContext);
                          try {
                            final result = await OpenFilex.open(savePath);
                            if (result.type != ResultType.done) {
                              messenger.showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'No se encontró una aplicación compatible para abrir Excel. Motivo: ${result.message}',
                                  ),
                                  backgroundColor: Colors.amber.shade700,
                                ),
                              );
                            }
                          } catch (e) {
                            messenger.showSnackBar(
                              SnackBar(
                                content: Text(
                                  'No se pudo abrir el archivo: $e',
                                ),
                                backgroundColor: Colors.red.shade600,
                              ),
                            );
                          }
                        },
                        icon: const Icon(LucideIcons.externalLink, size: 16),
                        label: const Text('Abrir en Excel'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    } catch (e, stackTrace) {
      debugPrint('[EXCEL DOWNLOAD ERROR] Ocurrió un error: $e');
      debugPrint(stackTrace.toString());
      onProcessingChanged(false);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al descargar formato: $e'),
          backgroundColor: Colors.red.shade600,
        ),
      );
    }
  }
}
