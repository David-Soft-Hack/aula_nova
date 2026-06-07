import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../config/theme/app_theme.dart';
import '../../../database/app_database.dart';
import '../../../providers/module_providers.dart';
import '../../shared/app_input_decoration.dart';
import '../../shared/app_snackbar.dart';

class EditUnitDialog extends ConsumerStatefulWidget {
  final Unit unit;

  const EditUnitDialog({super.key, required this.unit});

  @override
  ConsumerState<EditUnitDialog> createState() => _EditUnitDialogState();
}

class _EditUnitDialogState extends ConsumerState<EditUnitDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nombreCtrl;
  late final TextEditingController _haCtrl;
  late final TextEditingController _hrCtrl;
  late final TextEditingController _pondCtrl;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nombreCtrl = TextEditingController(text: widget.unit.nombre);
    _haCtrl = TextEditingController(text: widget.unit.totalHoraAcademic.toString());
    _hrCtrl = TextEditingController(text: widget.unit.totalHoraReloj.toString());
    _pondCtrl = TextEditingController(text: widget.unit.ponderacion.toString());
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _haCtrl.dispose();
    _hrCtrl.dispose();
    _pondCtrl.dispose();
    super.dispose();
  }

  InputDecoration _buildInputDecoration({required String hintText, required IconData prefixIcon}) {
    return AppInputDecoration.build(
      hintText: hintText,
      prefixIcon: prefixIcon,
      borderRadius: 14,
      prefixIconColor: Colors.grey.shade400,
      showErrors: true,
      errorStyle: const TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w500),
    );
  }

  void _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    try {
      final updatedUnit = Unit(
        codUnit: widget.unit.codUnit,
        nombre: _nombreCtrl.text.trim(),
        totalHoraAcademic: int.parse(_haCtrl.text.trim()),
        totalHoraReloj: int.parse(_hrCtrl.text.trim()),
        ponderacion: double.parse(_pondCtrl.text.trim()),
        idModule: widget.unit.idModule,
      );

      await ref.read(moduleControllerProvider).updateUnit(updatedUnit);

      if (mounted) {
        AppSnackbar.showSuccess(context, 'Unidad actualizada con éxito');
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        AppSnackbar.showError(context, 'Error al actualizar: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const labelStyle = TextStyle(
      fontFamily: 'Inter',
      fontSize: 12,
      fontWeight: FontWeight.bold,
      color: Colors.grey,
      letterSpacing: 0.2,
    );

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: AbsorbPointer(
              absorbing: _isSaving,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.indigo.shade50,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(LucideIcons.layers, color: Colors.indigo, size: 22),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Editar Unidad',
                              style: TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                color: AppTheme.slate900,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: Colors.indigo.shade50,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                widget.unit.codUnit,
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.indigo,
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(LucideIcons.x, size: 20),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.grey.shade100,
                          padding: const EdgeInsets.all(8),
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Divider(height: 1, thickness: 1, color: Color(0xFFF1F5F9)),
                  const SizedBox(height: 20),

                  const Text('Nombre de la Unidad', style: labelStyle),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _nombreCtrl,
                    textCapitalization: TextCapitalization.sentences,
                    style: const TextStyle(fontFamily: 'Inter', fontSize: 15),
                    decoration: _buildInputDecoration(hintText: 'Ej. Conceptos Básicos', prefixIcon: LucideIcons.fileText),
                    validator: (v) => v == null || v.trim().isEmpty ? 'Requerido' : null,
                  ),
                  const SizedBox(height: 16),

                  const Text('Ponderación (%)', style: labelStyle),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _pondCtrl,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    style: const TextStyle(fontFamily: 'Inter', fontSize: 15),
                    decoration: _buildInputDecoration(hintText: 'Ej. 25.0', prefixIcon: LucideIcons.percent),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Requerido';
                      final val = double.tryParse(v);
                      if (val == null || val < 0 || val > 100) return 'Valor entre 0 y 100';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('H. Académicas', style: labelStyle),
                            const SizedBox(height: 6),
                            TextFormField(
                              controller: _haCtrl,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(3)],
                              style: const TextStyle(fontFamily: 'Inter', fontSize: 18, fontWeight: FontWeight.bold),
                              decoration: _buildInputDecoration(hintText: '0', prefixIcon: LucideIcons.bookOpen),
                              validator: (v) => (v == null || v.trim().isEmpty || int.tryParse(v) == null) ? 'Requerido' : null,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('H. Reloj', style: labelStyle),
                            const SizedBox(height: 6),
                            TextFormField(
                              controller: _hrCtrl,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(3)],
                              style: const TextStyle(fontFamily: 'Inter', fontSize: 18, fontWeight: FontWeight.bold),
                              decoration: _buildInputDecoration(hintText: '0', prefixIcon: LucideIcons.clock),
                              validator: (v) => (v == null || v.trim().isEmpty || int.tryParse(v) == null) ? 'Requerido' : null,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _isSaving ? null : () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            side: BorderSide(color: Colors.grey.shade300),
                          ),
                          child: const Text('Cancelar', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _isSaving ? null : _saveChanges,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigo,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            elevation: 0,
                          ),
                          child: _isSaving
                              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                              : const Text('Guardar', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
