import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../controllers/student_controller.dart';
import '../../../database/tables.dart';
import 'personal_data_section.dart';
import 'academic_data_section.dart';
import 'dialog_header.dart';
import 'step_progress_indicator.dart';
import 'form_action_buttons.dart';

class AddStudentDialog extends StatefulWidget {
  final StudentController controller;

  const AddStudentDialog({super.key, required this.controller});

  @override
  State<AddStudentDialog> createState() => _AddStudentDialogState();
}

class _AddStudentDialogState extends State<AddStudentDialog> {
  // Paso 1: Datos personales
  final _codigoCtrl = TextEditingController();
  final _nombresCtrl = TextEditingController();
  final _apellidosCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _telefonoCtrl = TextEditingController();

  // Paso 2: Datos de grupo de clase
  String? _selectedCarrera;
  String? _selectedGrupo;
  StudentStatus _selectedStatus = StudentStatus.activo;
  DateTime? _fechaIngreso;

  // Estados
  int _currentStep = 0;
  bool _isSaving = false;
  bool _isLoadingData = false;

  // Datos cargados
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
      setState(() {
        _carreras = carreras;
        _grupos = grupos;
      });
    } catch (e) {
      debugPrint('Error loading dropdown data: $e');
    } finally {
      setState(() => _isLoadingData = false);
    }
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
    if (_nombresCtrl.text.trim().isEmpty) {
      _showMessage('El nombre es requerido');
      return false;
    }
    if (_apellidosCtrl.text.trim().isEmpty) {
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
    if (_codigoCtrl.text.trim().isEmpty) {
      _showMessage('El código de estudiante no se ha generado correctamente');
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
      setState(() => _isSaving = false);
    }
  }

  Future<void> _selectFechaIngreso() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _fechaIngreso ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (selected != null) {
      setState(() => _fechaIngreso = selected);
    }
  }

  void _handleNextOrSave() {
    if (_currentStep == 0) {
      if (_validateStep1()) setState(() => _currentStep = 1);
    } else {
      if (_validateStep2()) _save();
    }
  }

  void _handleBack() {
    if (_currentStep == 1) {
      setState(() => _currentStep = 0);
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    return Dialog.fullscreen(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isKeyboardVisible ? 16.0 : 24.0,
            vertical: isKeyboardVisible ? 12.0 : 24.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DialogHeader(
                title: 'Nuevo Estudiante',
                icon: LucideIcons.userPlus,
                isKeyboardVisible: isKeyboardVisible,
                isSaving: _isSaving,
                onClose: () => Navigator.pop(context),
              ),
              SizedBox(height: isKeyboardVisible ? 12 : 24),

              StepProgressIndicator(
                totalSteps: 2,
                currentStep: _currentStep,
                stepLabels: const ['Datos Personales', 'Grupo de Clase'],
                isKeyboardVisible: isKeyboardVisible,
              ),
              SizedBox(height: isKeyboardVisible ? 12 : 24),

              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: _currentStep == 0
                        ? PersonalDataSection(
                            codigoCtrl: _codigoCtrl,
                            nombresCtrl: _nombresCtrl,
                            apellidosCtrl: _apellidosCtrl,
                            emailCtrl: _emailCtrl,
                            telefonoCtrl: _telefonoCtrl,
                          )
                        : AcademicDataSection(
                            isLoadingData: _isLoadingData,
                            selectedCarrera: _selectedCarrera,
                            selectedGrupo: _selectedGrupo,
                            carreras: _carreras,
                            grupos: _grupos,
                            selectedStatus: _selectedStatus,
                            fechaIngreso: _fechaIngreso,
                            onCarreraChanged: (value) =>
                                setState(() => _selectedCarrera = value),
                            onGrupoChanged: (value) async {
                              setState(() => _selectedGrupo = value);
                              if (value != null && value.isNotEmpty) {
                                final code = await widget.controller
                                    .generateNextStudentCodigo(value);
                                setState(() => _codigoCtrl.text = code);
                              }
                            },
                            onStatusChanged: (value) {
                              if (value != null) {
                                setState(() => _selectedStatus = value);
                              }
                            },
                            onSelectFechaIngreso: _selectFechaIngreso,
                          ),
                  ),
                ),
              ),

              FormActionButtons(
                currentStep: _currentStep,
                isSaving: _isSaving,
                onBack: _handleBack,
                onNext: _handleNextOrSave,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
