import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../config/theme/app_theme.dart';
import '../../../database/app_database.dart';
import '../../../providers/database_providers.dart';
import '../../shared/app_input_decoration.dart';
import '../../shared/app_snackbar.dart';

class EditActivityDialog extends ConsumerStatefulWidget {
  final Activity activity;

  const EditActivityDialog({super.key, required this.activity});

  @override
  ConsumerState<EditActivityDialog> createState() => _EditActivityDialogState();
}

class _EditActivityDialogState extends ConsumerState<EditActivityDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _descCtrl;
  late final TextEditingController _haCtrl;
  late final TextEditingController _hrCtrl;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _descCtrl = TextEditingController(text: widget.activity.descripcion);
    _haCtrl = TextEditingController(text: widget.activity.totalHoraAcademic.toString());
    _hrCtrl = TextEditingController(text: widget.activity.totalHoraReloj.toString());
  }

  @override
  void dispose() {
    _descCtrl.dispose();
    _haCtrl.dispose();
    _hrCtrl.dispose();
    super.dispose();
  }

  InputDecoration _buildInputDecoration({required String hintText, required IconData prefixIcon}) {
    return AppInputDecoration.build(
      hintText: hintText,
      prefixIcon: prefixIcon,
      borderRadius: 14,
      prefixIconColor: Colors.grey.shade400,
      focusedBorderColor: Colors.teal.shade600,
      showErrors: true,
      errorStyle: const TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w500),
    );
  }

  void _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    try {
      final updatedActivity = Activity(
        codActivity: widget.activity.codActivity,
        descripcion: _descCtrl.text.trim(),
        totalHoraAcademic: int.parse(_haCtrl.text.trim()),
        totalHoraReloj: int.parse(_hrCtrl.text.trim()),
        idUnit: widget.activity.idUnit,
      );

      await ref.read(activityDaoProvider).updateActivity(updatedActivity);

      if (mounted) {
        AppSnackbar.showSuccess(context, 'Actividad actualizada con éxito');
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
                          color: Colors.teal.shade50,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(LucideIcons.activity, color: Colors.teal.shade600, size: 22),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Editar Actividad',
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
                                color: Colors.teal.shade50,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                widget.activity.codActivity,
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.teal.shade700,
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

                  const Text('Descripción de la Actividad', style: labelStyle),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _descCtrl,
                    textCapitalization: TextCapitalization.sentences,
                    maxLines: 3,
                    minLines: 2,
                    style: const TextStyle(fontFamily: 'Inter', fontSize: 14),
                    decoration: _buildInputDecoration(hintText: 'Ej. Práctica de laboratorio...', prefixIcon: LucideIcons.alignLeft),
                    validator: (v) => v == null || v.trim().isEmpty ? 'Requerido' : null,
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
                            backgroundColor: Colors.teal.shade600,
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
