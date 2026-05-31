import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../config/theme/app_theme.dart';
import '../../../models/database_provider.dart';
import '../../../database/app_database.dart';
import '../../../controllers/career_controller.dart';

/// Diálogo altamente optimizado, seguro y con diseño premium M3 para editar un Módulo Formativo.
class EditModuleDialog extends StatefulWidget {
  final Module module;

  const EditModuleDialog({super.key, required this.module});

  @override
  State<EditModuleDialog> createState() => _EditModuleDialogState();
}

class _EditModuleDialogState extends State<EditModuleDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nombreCtrl;
  late final TextEditingController _haCtrl;
  late final TextEditingController _hrCtrl;

  final _nombreFocusNode = FocusNode();
  final _haFocusNode = FocusNode();
  final _hrFocusNode = FocusNode();

  String? _selectedCareer;
  List<String> _carreras = [];
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nombreCtrl = TextEditingController(text: widget.module.nombre);
    _haCtrl = TextEditingController(
      text: widget.module.totalHoraAcademic.toString(),
    );
    _hrCtrl = TextEditingController(
      text: widget.module.totalHoraReloj.toString(),
    );
    _selectedCareer = widget.module.carrera;
    _loadCareers();
  }

  void _loadCareers() async {
    try {
      final controller = CareerController();
      final careers = await controller.getAllCareers();
      if (mounted) {
        setState(() {
          _carreras = careers.map((e) => e.nombre).toList();
          // Prevenir crash de Dropdown si el valor actual no está en la lista cargada
          if (_selectedCareer != null && !_carreras.contains(_selectedCareer)) {
            _carreras.add(_selectedCareer!);
          }
          if (_selectedCareer == null && _carreras.isNotEmpty) {
            _selectedCareer = _carreras.first;
          }
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _haCtrl.dispose();
    _hrCtrl.dispose();
    _nombreFocusNode.dispose();
    _haFocusNode.dispose();
    _hrFocusNode.dispose();
    super.dispose();
  }

  /// Construye decoraciones de input premium y consistentes.
  InputDecoration _buildInputDecoration({
    required String hintText,
    required IconData prefixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      prefixIcon: Icon(prefixIcon, size: 20),
      prefixIconColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.focused)) {
          return AppTheme.academic600;
        }
        if (states.contains(WidgetState.error)) {
          return Colors.red.shade600;
        }
        return Colors.grey.shade400;
      }),
      filled: true,
      fillColor: Colors.grey.shade50,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      errorStyle: const TextStyle(
        fontFamily: 'Inter',
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppTheme.academic600, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.red.shade400),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.red.shade600, width: 1.5),
      ),
    );
  }

  void _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final updatedModule = Module(
        codModule: widget.module.codModule,
        nombre: _nombreCtrl.text.trim(),
        totalHoraAcademic: int.parse(_haCtrl.text.trim()),
        totalHoraReloj: int.parse(_hrCtrl.text.trim()),
        carrera: _selectedCareer,
        fechaCreacion: widget.module.fechaCreacion,
      );

      await DatabaseProvider.moduleDao.updateModule(updatedModule);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(
                  LucideIcons.checkCircle2,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '¡Módulo "${updatedModule.nombre}" actualizado con éxito!',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.green.shade600,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(
                  LucideIcons.alertTriangle,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Error al actualizar: $e',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.red.shade600,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );
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
      child: AnimatedSize(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        child: _isLoading
            ? const SizedBox(
                height: 220,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation(
                          AppTheme.academic600,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Cargando programas técnicos...',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: AbsorbPointer(
                      absorbing: _isSaving,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ── Cabecera ──────────────────────────────────────
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppTheme.academic50,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Icon(
                                  LucideIcons.edit3,
                                  color: AppTheme.academic600,
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Editar Módulo',
                                      style: TextStyle(
                                        fontFamily: 'Outfit',
                                        fontSize: 20,
                                        fontWeight: FontWeight.w900,
                                        color: AppTheme.slate900,
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 3,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppTheme.academic50,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        widget.module.codModule.toUpperCase(),
                                        style: const TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 10,
                                          fontWeight: FontWeight.w900,
                                          color: AppTheme.academic600,
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
                                  foregroundColor: Colors.grey.shade700,
                                  padding: const EdgeInsets.all(8),
                                ),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          const Divider(
                            height: 1,
                            thickness: 1,
                            color: Color(0xFFF1F5F9),
                          ),
                          const SizedBox(height: 20),

                          // ── Nombre del Módulo ─────────────────────────────
                          const Text('Nombre del Módulo', style: labelStyle),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _nombreCtrl,
                            focusNode: _nombreFocusNode,
                            textInputAction: TextInputAction.next,
                            textCapitalization: TextCapitalization.sentences,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 15,
                            ),
                            decoration: _buildInputDecoration(
                              hintText: 'Ej. Diseño Web Responsivo',
                              prefixIcon: LucideIcons.bookOpen,
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'El nombre del módulo es requerido';
                              }
                              if (value.trim().length < 3) {
                                return 'Debe tener al menos 3 caracteres';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // ── Carrera o Programa ────────────────────────────
                          if (_carreras.isNotEmpty) ...[
                            const Text('Programa Académico', style: labelStyle),
                            const SizedBox(height: 6),
                            DropdownButtonFormField<String>(
                              isExpanded: true,
                              initialValue: _selectedCareer,
                              icon: const Icon(
                                LucideIcons.chevronDown,
                                size: 18,
                              ),
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 15,
                                color: AppTheme.slate900,
                              ),
                              items: _carreras
                                  .map(
                                    (c) => DropdownMenuItem(
                                      value: c,
                                      child: Text(
                                        c,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (val) =>
                                  setState(() => _selectedCareer = val),
                              decoration: _buildInputDecoration(
                                hintText: 'Seleccione un programa',
                                prefixIcon: LucideIcons.graduationCap,
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],

                          // ── Horas ─────────────────────────────────────────
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'H. Académicas',
                                      style: labelStyle,
                                    ),
                                    const SizedBox(height: 6),
                                    TextFormField(
                                      controller: _haCtrl,
                                      focusNode: _haFocusNode,
                                      textInputAction: TextInputAction.next,
                                      keyboardType: TextInputType.number,
                                      textAlign: TextAlign.center,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(4),
                                      ],
                                      style: const TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.slate900,
                                      ),
                                      decoration: _buildInputDecoration(
                                        hintText: '96',
                                        prefixIcon: LucideIcons.clock,
                                      ),
                                      validator: (value) {
                                        if (value == null ||
                                            value.trim().isEmpty) {
                                          return 'Requerido';
                                        }
                                        final n = int.tryParse(value.trim());
                                        if (n == null || n <= 0) {
                                          return 'Inválido';
                                        }
                                        return null;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'H. académicas',
                                      style: labelStyle,
                                    ),
                                    const SizedBox(height: 6),
                                    TextFormField(
                                      controller: _hrCtrl,
                                      focusNode: _hrFocusNode,
                                      textInputAction: TextInputAction.done,
                                      keyboardType: TextInputType.number,
                                      textAlign: TextAlign.center,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(4),
                                      ],
                                      style: const TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.slate900,
                                      ),
                                      decoration: _buildInputDecoration(
                                        hintText: '72',
                                        prefixIcon: LucideIcons.clock,
                                      ),
                                      validator: (value) {
                                        if (value == null ||
                                            value.trim().isEmpty) {
                                          return 'Requerido';
                                        }
                                        final n = int.tryParse(value.trim());
                                        if (n == null || n <= 0) {
                                          return 'Inválido';
                                        }
                                        return null;
                                      },
                                      onFieldSubmitted: (_) => _saveChanges(),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 28),

                          // ── Botones de Acción ─────────────────────────────
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: _isSaving
                                      ? null
                                      : () => Navigator.pop(context),
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    side: BorderSide(
                                      color: Colors.grey.shade300,
                                    ),
                                    foregroundColor: Colors.grey.shade700,
                                    textStyle: const TextStyle(
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  child: const Text('Cancelar'),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: _isSaving ? null : _saveChanges,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.academic600,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    elevation: 0,
                                    textStyle: const TextStyle(
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  child: _isSaving
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.5,
                                            valueColor: AlwaysStoppedAnimation(
                                              Colors.white,
                                            ),
                                          ),
                                        )
                                      : const Text('Guardar Cambios'),
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
      ),
    );
  }
}
