import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import '../../../models/app_models.dart';
import '../../../providers/career_providers.dart';
import '../../../services/module_extractor.dart';
import '../../../services/excel_template_generator.dart';
import 'package:share_plus/share_plus.dart';
import '../../shared/app_snackbar.dart';

class ModuleExcelHandler {
  static Future<void> pickAndImportExcel({
    required BuildContext context,
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
      Directory? baseDir;
      if (Platform.isAndroid) {
        baseDir = await getExternalStorageDirectory();
      } else {
        baseDir = await getApplicationDocumentsDirectory();
      }
      baseDir ??= await getTemporaryDirectory();

      final targetFolder = Directory(p.join(baseDir.path, 'Planeacion Template'));
      String? initialDir;
      if (await targetFolder.exists()) {
        initialDir = targetFolder.path;
      }

      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx'],
        initialDirectory: initialDir,
      );

      if (!context.mounted) return;

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        final String? rawPath = file.path;
        if (rawPath == null || rawPath.isEmpty) return;

        final normalizedPath = p.normalize(rawPath);
        final docsDir = await getApplicationDocumentsDirectory();
        final extDir = Platform.isAndroid ? await getExternalStorageDirectory() : null;
        final tempDir = await getTemporaryDirectory();

        final isWithinAllowed = p.isWithin(docsDir.path, normalizedPath) ||
            (extDir != null && p.isWithin(extDir.path, normalizedPath)) ||
            p.isWithin(tempDir.path, normalizedPath);

        if (!isWithinAllowed) {
          if (!context.mounted) return;
          AppSnackbar.showError(context, 'La ruta del archivo seleccionado no es válida.');
          return;
        }

        final filePath = normalizedPath;
        final fileName = file.name;
        final hasManualData =
            nombreCtrl.text.trim().isNotEmpty ||
            codCtrl.text.trim().isNotEmpty;

        bool confirm = true;
        if (hasManualData) {
          if (!context.mounted) return;
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
          await ProviderScope.containerOf(context).read(careerControllerProvider).addCareer(
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

        AppSnackbar.showSuccess(context, '¡Datos importados con éxito desde Excel: $fileName!');
      }
    } catch (e) {
      if (!context.mounted) return;
      onProcessingChanged(false);

      String errorMessage = 'Error al importar Excel: $e';
      if (e is FormatException) {
        errorMessage = e.message;
      }

      AppSnackbar.showError(context, errorMessage);
    }
  }

  static Future<void> downloadExcelTemplate({
    required BuildContext context,
    required Function(bool processing) onProcessingChanged,
  }) async {
    try {
      onProcessingChanged(true);

      if (!context.mounted) return;
      final careers = await ProviderScope.containerOf(context).read(careerControllerProvider).getAllCareers();
      
      final List<int> updatedBytes = await ExcelTemplateGenerator.generate(
        careers,
      );

      onProcessingChanged(false);
      if (!context.mounted) return;

      // Abre el selector nativo para guardar de forma pública y visible para el usuario
      final savePath = await FilePicker.saveFile(
        dialogTitle: 'Selecciona dónde guardar la plantilla de Excel',
        fileName: 'planeacion_template.xlsx',
        bytes: Uint8List.fromList(updatedBytes),
      );

      if (savePath == null) {
        // El usuario canceló la operación
        return;
      }

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
            child: SafeArea(
              top: false,
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
                  Text(
                    '¡Descargada con éxito!',
                    style: const TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'El archivo de plantilla excel se descargó con éxito:',
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
                      const SizedBox(width: 8),
                      IconButton.filled(
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.blue.shade600,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.all(14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: () async {
                          await SharePlus.instance.share(
                            ShareParams(
                              files: [XFile(savePath)],
                            ),
                          );
                        },
                        icon: const Icon(LucideIcons.share2, size: 18),
                      ),
                      const SizedBox(width: 8),
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
                            Navigator.pop(sheetContext);
                            try {
                              final result = await OpenFilex.open(savePath);
                              if (!context.mounted) return;
                              if (result.type != ResultType.done) {
                                AppSnackbar.showWarning(
                                  context,
                                  'No se encontró una aplicación compatible para abrir Excel. Motivo: ${result.message}',
                                );
                              }
                            } catch (e) {
                              if (!context.mounted) return;
                              AppSnackbar.showError(
                                context,
                                'No se pudo abrir el archivo: $e',
                              );
                            }
                          },
                          icon: const Icon(LucideIcons.externalLink, size: 16),
                          label: const Text('Abrir'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    } catch (e, stackTrace) {
      debugPrint('[EXCEL DOWNLOAD ERROR] Ocurrió un error: $e');
      debugPrint(stackTrace.toString());
      onProcessingChanged(false);
      if (!context.mounted) return;
      AppSnackbar.showError(context, 'Error al descargar formato: $e');
    }
  }
}
