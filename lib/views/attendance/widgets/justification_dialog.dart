import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:lucide_icons/lucide_icons.dart';
import '../../../config/theme/app_theme.dart';
import '../../shared/app_snackbar.dart';

class JustificationDialog extends StatefulWidget {
  final String studentName;
  final String? initialDetail;
  final List<String> initialEvidencePaths;

  const JustificationDialog({
    super.key,
    required this.studentName,
    this.initialDetail,
    required this.initialEvidencePaths,
  });

  @override
  State<JustificationDialog> createState() => _JustificationDialogState();
}

class _JustificationDialogState extends State<JustificationDialog> {
  final TextEditingController _detailController = TextEditingController();
  final List<String> _evidencePaths = [];
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _detailController.text = widget.initialDetail ?? '';
    _evidencePaths.addAll(widget.initialEvidencePaths);
  }

  @override
  void dispose() {
    _detailController.dispose();
    super.dispose();
  }

  Future<String> _saveFileToLocalFolder(File sourceFile) async {
    final appDir = await getApplicationDocumentsDirectory();
    final justificationsDir = Directory(p.join(appDir.path, 'justifications'));
    if (!await justificationsDir.exists()) {
      await justificationsDir.create(recursive: true);
    }

    final fileName =
        '${DateTime.now().millisecondsSinceEpoch}_${p.basename(sourceFile.path)}';
    final targetPath = p.join(justificationsDir.path, fileName);
    final savedFile = await sourceFile.copy(targetPath);
    return savedFile.path;
  }

  Future<void> _pickImage(ImageSource source) async {
    if (_evidencePaths.length >= 3) {
      AppSnackbar.showWarning(
        context,
        'Límite máximo de 3 archivos de evidencia.',
      );
      return;
    }

    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: source,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        setState(() => _isSaving = true);
        final localPath = await _saveFileToLocalFolder(File(pickedFile.path));
        setState(() {
          _evidencePaths.add(localPath);
          _isSaving = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      AppSnackbar.showError(
        context,
        'Error al capturar imagen',
        description: e.toString(),
      );
    }
  }

  Future<void> _pickFile() async {
    if (_evidencePaths.length >= 3) {
      AppSnackbar.showWarning(
        context,
        'Límite máximo de 3 archivos de evidencia.',
      );
      return;
    }

    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png'],
      );

      if (result != null && result.files.single.path != null) {
        setState(() => _isSaving = true);
        final localPath = await _saveFileToLocalFolder(
          File(result.files.single.path!),
        );
        setState(() {
          _evidencePaths.add(localPath);
          _isSaving = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      AppSnackbar.showError(
        context,
        'Error al seleccionar archivo',
        description: e.toString(),
      );
    }
  }

  void _removeEvidence(int index) {
    setState(() {
      _evidencePaths.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 8,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Justificar Inasistencia',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Outfit',
                        color: AppTheme.slate900,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(LucideIcons.x),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                widget.studentName,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Detalle de la justificación *',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _detailController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Ej. Cita médica, enfermedad, urgencia familiar...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppTheme.academic600,
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.all(12),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Evidencia adjunta (${_evidencePaths.length}/3)',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              if (_evidencePaths.isNotEmpty)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _evidencePaths.length,
                    separatorBuilder: (_, _) => const Divider(height: 8),
                    itemBuilder: (context, idx) {
                      final path = _evidencePaths[idx];
                      final isImage = [
                        '.jpg',
                        '.jpeg',
                        '.png',
                      ].any((ext) => path.toLowerCase().endsWith(ext));

                      return ListTile(
                        leading: isImage
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: Image.file(
                                  File(path),
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, _, _) => const Icon(
                                    LucideIcons.file,
                                    color: AppTheme.academic500,
                                  ),
                                ),
                              )
                            : const Icon(
                                LucideIcons.fileText,
                                color: AppTheme.academic500,
                              ),
                        title: Text(
                          p.basename(path),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 13),
                        ),
                        trailing: IconButton(
                          icon: const Icon(
                            LucideIcons.trash2,
                            color: Colors.red,
                            size: 20,
                          ),
                          onPressed: () => _removeEvidence(idx),
                        ),
                      );
                    },
                  ),
                )
              else
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.grey.shade200,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'Sin archivos adjuntos',
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(LucideIcons.camera, size: 16),
                      label: const Text(
                        'Cámara',
                        style: TextStyle(fontSize: 12),
                      ),
                      onPressed: _evidencePaths.length >= 3
                          ? null
                          : () => _pickImage(ImageSource.camera),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(LucideIcons.image, size: 16),
                      label: const Text(
                        'Galería',
                        style: TextStyle(fontSize: 12),
                      ),
                      onPressed: _evidencePaths.length >= 3
                          ? null
                          : () => _pickImage(ImageSource.gallery),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(LucideIcons.paperclip, size: 16),
                      label: const Text(
                        'Archivo',
                        style: TextStyle(fontSize: 12),
                      ),
                      onPressed: _evidencePaths.length >= 3
                          ? null
                          : () => _pickFile(),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              if (_isSaving)
                const Center(child: CircularProgressIndicator())
              else
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text(
                          'Cancelar',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (_detailController.text.trim().isEmpty) {
                            AppSnackbar.showWarning(
                              context,
                              'Por favor, ingresa el detalle de la justificación.',
                            );
                            return;
                          }
                          Navigator.of(context).pop({
                            'detalle': _detailController.text.trim(),
                            'evidencias': _evidencePaths,
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.academic600,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text('Guardar'),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
