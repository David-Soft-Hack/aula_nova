import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../config/theme/app_theme.dart';
import '../../../controllers/student_controller.dart';
import '../../../database/tables.dart';
import 'class_group_step.dart';
import 'personal_data_step.dart';

class AddStudentDialog extends StatefulWidget {
  final StudentController controller;

  const AddStudentDialog({super.key, required this.controller});

  @override
  State<AddStudentDialog> createState() => _AddStudentDialogState();
}

class _AddStudentDialogState extends State<AddStudentDialog> {
  final _codigoCtrl = TextEditingController();
  final _nombresCtrl = TextEditingController();
  final _apellidosCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _telefonoCtrl = TextEditingController();

  String? _selectedCarrera;
  String? _selectedGrupo;
  StudentStatus _selectedStatus = StudentStatus.activo;
  DateTime? _fechaIngreso;

  int _currentStep = 0;
  bool _isSaving = false;
  bool _isLoadingData = false;

  List<String> _carreras = [];
  List<String> _grupos = [];

  @override
  void initState() {
    super.initState();
    _loadDropdownData();
  }

  Future<void> _loadDropdownData() async {
    setState(() => _isLoadingData = true);
    try {
      final carreras = await widget.controller.getAllCareers();
      final grupos = await widget.controller.getAllGroups();
      if (mounted) {
        setState(() {
          _carreras = carreras;
          _grupos = grupos;
        });
      }
    } catch (e) {
      print('Error loading dropdown data: $e');
    } finally {
      if (mounted) setState(() => _isLoadingData = false);
    }
  }

  Future<void> _applySuggestedCode() async {
    final code = await widget.controller.getNextStudentCode(
      _selectedCarrera,
      _selectedGrupo,
    );
    if (mounted) setState(() => _codigoCtrl.text = code);
  }

  void _onCarreraChanged(String? value) {
    setState(() => _selectedCarrera = value);
    if (value != null && value.isNotEmpty) _applySuggestedCode();
  }

  void _onGrupoChanged(String? value) {
    setState(() => _selectedGrupo = value);
    if (value != null && value.isNotEmpty) _applySuggestedCode();
  }

  @override
  void dispose() {
    _codigoCtrl.dispose();
    _nombresCtrl.dispose();
    _apellidosCtrl.dispose();
    _emailCtrl.dispose();
    _telefonoCtrl.dispose();
    super.dispose();
  }

  bool _validateStep1() {
    final nombres = _nombresCtrl.text.trim();
    final apellidos = _apellidosCtrl.text.trim();
    if (nombres.isEmpty) {
      _showMessage('El nombre es requerido');
      return false;
    }
    if (apellidos.isEmpty) {
      _showMessage('El apellido es requerido');
      return false;
    }
    return true;
  }

  bool _validateStep2() {
    if (_selectedCarrera == null || _selectedCarrera!.isEmpty) {
      _showMessage('Selecciona una carrera');
      return false;
    }
    if (_selectedGrupo == null || _selectedGrupo!.isEmpty) {
      _showMessage('Selecciona un grupo');
      return false;
    }
    return true;
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _save() async {
    final codigo = _codigoCtrl.text.trim();
    setState(() => _isSaving = true);
    try {
      final exists = await widget.controller.existsStudentByCodigo(codigo);
      if (exists) {
        _showMessage('Ya existe un estudiante con ese código.');
        return;
      }
      await widget.controller.addStudent(
        codigo: codigo,
        nombres: _nombresCtrl.text.trim(),
        apellidos: _apellidosCtrl.text.trim(),
        email: _emailCtrl.text.trim().isEmpty ? null : _emailCtrl.text.trim(),
        telefono: _telefonoCtrl.text.trim().isEmpty
            ? null
            : _telefonoCtrl.text.trim(),
        carrera: _selectedCarrera,
        grupo: _selectedGrupo,
        status: _selectedStatus,
        fechaIngreso: _fechaIngreso,
      );
      if (mounted) Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _selectFechaIngreso() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _fechaIngreso ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (selected != null && mounted) setState(() => _fechaIngreso = selected);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return Dialog.fullscreen(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: 12,
            right: 12,
            top: 12,
            bottom: MediaQuery.of(context).viewInsets.bottom + 12,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header (always visible, but compact when keyboard open)
              if (isKeyboardOpen) ...[
                Row(
                  children: [
                    IconButton(
                      onPressed: _isSaving
                          ? null
                          : () => Navigator.pop(context),
                      icon: Icon(
                        LucideIcons.x,
                        color: Colors.grey.shade400,
                        size: 18,
                      ),
                      splashRadius: 18,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
              ] else ...[
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Nuevo Estudiante',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: _isSaving
                          ? null
                          : () => Navigator.pop(context),
                      icon: Icon(
                        LucideIcons.x,
                        color: Colors.grey.shade400,
                        size: 18,
                      ),
                      splashRadius: 18,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],

              // Progress indicator (ALWAYS visible)
              Row(
                children: List.generate(2, (index) {
                  final isActive = index <= _currentStep;
                  return Expanded(
                    child: Column(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: isActive
                                ? AppTheme.academic600
                                : Colors.grey.shade200,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${index + 1}',
                              style: TextStyle(
                                color: isActive
                                    ? Colors.white
                                    : Colors.grey.shade600,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          index == 0 ? 'Datos Personales' : 'Grupo de Clase',
                          style: TextStyle(
                            fontWeight: index <= _currentStep
                                ? FontWeight.w600
                                : FontWeight.w400,
                            fontSize: 11,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        if (index < 1)
                          Padding(
                            padding: const EdgeInsets.only(top: 3),
                            child: Container(
                              height: 1.5,
                              color: isActive
                                  ? AppTheme.academic600
                                  : Colors.grey.shade200,
                            ),
                          ),
                      ],
                    ),
                  );
                }),
              ),
              const SizedBox(height: 10),

              // Content
              _currentStep == 0
                  ? PersonalDataStep(
                      codigoCtrl: _codigoCtrl,
                      nombresCtrl: _nombresCtrl,
                      apellidosCtrl: _apellidosCtrl,
                      emailCtrl: _emailCtrl,
                      telefonoCtrl: _telefonoCtrl,
                    )
                  : ClassGroupStep(
                      isLoadingData: _isLoadingData,
                      carreras: _carreras,
                      grupos: _grupos,
                      selectedCarrera: _selectedCarrera,
                      selectedGrupo: _selectedGrupo,
                      selectedStatus: _selectedStatus,
                      fechaIngreso: _fechaIngreso,
                      onCarreraChanged: _onCarreraChanged,
                      onGrupoChanged: _onGrupoChanged,
                      onStatusChanged: (value) {
                        if (value != null) {
                          setState(() => _selectedStatus = value);
                        }
                      },
                      onSelectFechaIngreso: _selectFechaIngreso,
                    ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isSaving
                          ? null
                          : () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.slate900,
                        side: BorderSide(color: Colors.grey.shade200),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Cancelar',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _handleNextOrSave,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.academic600,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: _isSaving
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              _currentStep == 0 ? 'Siguiente' : 'Guardar',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
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

  void _handleNextOrSave() {
    if (_currentStep == 0) {
      if (_validateStep1()) setState(() => _currentStep = 1);
    } else {
      if (_validateStep2()) _save();
    }
  }
}
