import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../config/theme/app_theme.dart';
import '../../../database/tables.dart' show TipoCarrera;
import '../../../providers/career_providers.dart';
import '../../shared/app_snackbar.dart';
import 'career_type_selector.dart';

class AddCareerDialog extends ConsumerStatefulWidget {
  const AddCareerDialog({super.key});

  @override
  ConsumerState<AddCareerDialog> createState() => _AddCareerDialogState();
}

class _AddCareerDialogState extends ConsumerState<AddCareerDialog> {
  final _nombreCtrl = TextEditingController();
  TipoCarrera _selectedTipo = TipoCarrera.curso;
  bool _isSaving = false;

  @override
  void dispose() {
    _nombreCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final nombre = _nombreCtrl.text.trim();
    if (nombre.isEmpty) return;

    setState(() {
      _isSaving = true;
    });

    final controller = ref.read(careerControllerProvider);
    final exists = await controller.existsCareer(nombre);
    if (exists) {
      setState(() {
        _isSaving = false;
      });
      if (mounted) AppSnackbar.showError(context, 'El programa o carrera "$nombre" ya existe.');
      return;
    }

    await ref.read(careerControllerProvider).addCareer(nombre, _selectedTipo);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog.fullscreen(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.academic50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.academic100, width: 1),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppTheme.academic600,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        LucideIcons.graduationCap,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppTheme.academic600,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'Nuevo registro',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Agregar Programa o Carrera',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                              color: AppTheme.slate900,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Completa los campos para registrar un nuevo programa formativo en el sistema.',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(LucideIcons.x, color: Colors.grey.shade400, size: 20),
                      splashRadius: 20,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Contenido deslizable del formulario
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Campo de Nombre
                      const Text(
                        'Nombre del programa / carrera',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.slate900,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _nombreCtrl,
                        autofocus: true,
                        style: const TextStyle(fontSize: 15, color: AppTheme.slate900),
                        decoration: InputDecoration(
                          hintText: 'Ej: Ingeniería de Sistemas',
                          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 15),
                          prefixIcon: Icon(LucideIcons.fileText, color: Colors.grey.shade400, size: 18),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                            borderSide: const BorderSide(color: AppTheme.academic600, width: 1.5),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Selector de Tipo
                      const Text(
                        'Tipo de programa',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.slate900,
                        ),
                      ),
                      const SizedBox(height: 10),
                      CareerTypeSelector(
                        initialTipo: _selectedTipo,
                        onTypeSelected: (val) {
                          _selectedTipo = val;
                        },
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),

              // Botones de acción al fondo
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isSaving ? null : () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.slate900,
                        side: BorderSide(color: Colors.grey.shade200),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text(
                        'Cancelar',
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _save,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.academic600,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ).copyWith(
                        backgroundColor: WidgetStateProperty.resolveWith((states) {
                          if (states.contains(WidgetState.disabled)) {
                            return AppTheme.academic200;
                          }
                          return AppTheme.academic600;
                        }),
                      ),
                      child: _isSaving
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Crear',
                              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                            ),
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
