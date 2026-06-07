import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_filex/open_filex.dart';
import 'package:drift/drift.dart' hide Column, Table;
import 'dart:io';
import '../../../../config/theme/app_theme.dart';
import '../../../../database/app_database.dart';
import '../../shared/bottom_sheet_handle.dart';
import '../../shared/app_snackbar.dart';
import 'session_detail_header.dart';
import 'session_evaluativa_section.dart';
import 'session_document_section.dart';

/// BottomSheet de detalle de sesión para gestionar evaluación, documento e instrumento.
class SessionDetailBottomSheet extends StatefulWidget {
  final CalendarioBitacora session;
  final int sessionNumber;
  final bool usarHorasReloj;
  final Future<void> Function(CalendarioBitacora updated) onSave;

  const SessionDetailBottomSheet({
    super.key,
    required this.session,
    required this.sessionNumber,
    required this.usarHorasReloj,
    required this.onSave,
  });

  @override
  State<SessionDetailBottomSheet> createState() =>
      _SessionDetailBottomSheetState();
}

class _SessionDetailBottomSheetState extends State<SessionDetailBottomSheet>
    with SingleTickerProviderStateMixin {
  late bool _esEvaluativa;
  late TextEditingController _puntajeController;
  late String? _rutaDocumento;
  bool _isSaving = false;
  String? _nombreDocumento;

  late AnimationController _evaluativaAnimController;
  late Animation<double> _evaluativaFadeAnim;

  @override
  void initState() {
    super.initState();
    _esEvaluativa = widget.session.esEvaluativa;
    _rutaDocumento = widget.session.rutaDocumento;
    _puntajeController = TextEditingController(
      text: widget.session.puntaje != null
          ? widget.session.puntaje!.toStringAsFixed(1)
          : '',
    );
    if (_rutaDocumento != null) {
      _nombreDocumento = _rutaDocumento!.split(Platform.pathSeparator).last;
    }

    _evaluativaAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
      value: _esEvaluativa ? 1.0 : 0.0,
    );
    _evaluativaFadeAnim = CurvedAnimation(
      parent: _evaluativaAnimController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _puntajeController.dispose();
    _evaluativaAnimController.dispose();
    super.dispose();
  }

  void _toggleEvaluativa(bool val) {
    setState(() => _esEvaluativa = val);
    if (val) {
      _evaluativaAnimController.forward();
    } else {
      _evaluativaAnimController.reverse();
    }
  }

  Future<void> _pickDocument() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
      allowMultiple: false,
    );
    if (result != null && result.files.single.path != null) {
      setState(() {
        _rutaDocumento = result.files.single.path;
        _nombreDocumento = result.files.single.name;
      });
    }
  }

  Future<void> _openDocument() async {
    if (_rutaDocumento == null) return;
    final file = File(_rutaDocumento!);
    if (!file.existsSync()) {
      if (mounted) AppSnackbar.showError(context, 'El archivo no existe o fue movido.');
      return;
    }
    await OpenFilex.open(_rutaDocumento!);
  }

  void _removeDocument() {
    setState(() {
      _rutaDocumento = null;
      _nombreDocumento = null;
    });
  }

  Future<void> _handleSave() async {
    final navigator = Navigator.of(context);

    double? puntaje;
    if (_esEvaluativa && _puntajeController.text.isNotEmpty) {
      puntaje = double.tryParse(_puntajeController.text);
    }

    final updated = widget.session.copyWith(
      esEvaluativa: _esEvaluativa,
      puntaje: Value(_esEvaluativa ? puntaje : null),
      rutaDocumento: Value(_rutaDocumento),
    );

    setState(() => _isSaving = true);
    try {
      await widget.onSave(updated);
      if (!mounted) return;
      navigator.pop();
      AppSnackbar.showSuccess(context, 'Sesión actualizada con éxito');
    } catch (e) {
      if (!mounted) return;
      AppSnackbar.showError(context, 'Error al guardar: $e');
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          _buildHandle(),

          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Session header
                  SessionDetailHeader(
                    session: widget.session,
                    sessionNumber: widget.sessionNumber,
                    usarHorasReloj: widget.usarHorasReloj,
                  ),
                  const SizedBox(height: 24),

                  // Divider
                  Divider(color: Colors.grey.shade100, height: 1),
                  const SizedBox(height: 24),

                  // Evaluativa toggle
                  SessionEvaluativaSection(
                    esEvaluativa: _esEvaluativa,
                    onChanged: _toggleEvaluativa,
                  ),
                  const SizedBox(height: 20),

                  // Score + document sections (animated)
                  FadeTransition(
                    opacity: _evaluativaFadeAnim,
                    child: SizeTransition(
                      sizeFactor: _evaluativaFadeAnim,
                      axisAlignment: -1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildPuntajeField(),
                          const SizedBox(height: 20),
                          SessionDocumentSection(
                            nombreDocumento: _nombreDocumento,
                            onPickDocument: _pickDocument,
                            onOpenDocument: _openDocument,
                            onRemoveDocument: _removeDocument,
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                  Divider(color: Colors.grey.shade100, height: 1),
                  const SizedBox(height: 20),

                  // Save button
                  _buildSaveButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHandle() => const Padding(
    padding: EdgeInsets.symmetric(vertical: 12),
    child: BottomSheetHandle(),
  );

  Widget _buildPuntajeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(LucideIcons.star, size: 16, color: const Color(0xFFEA580C)),
            const SizedBox(width: 6),
            const Text(
              'Puntaje Asignado',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
            ),
          ],
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _puntajeController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
          ],
          decoration: InputDecoration(
            hintText: 'Ej: 10.0',
            suffixText: 'pts',
            suffixStyle: TextStyle(
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w600,
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: AppTheme.academic600, width: 1.5),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: _isSaving ? null : _handleSave,
        icon: _isSaving
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: Colors.white),
              )
            : const Icon(LucideIcons.save, size: 16),
        label: Text(_isSaving ? 'Guardando...' : 'Guardar Cambios'),
        style: FilledButton.styleFrom(
          backgroundColor: AppTheme.academic600,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 15,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }
}
