import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../database/app_database.dart';
import '../../../database/tables.dart';
import '../../../providers/student_providers.dart';
import '../../shared/app_snackbar.dart';
import 'personal_data_section.dart';
import 'academic_data_section.dart';
import 'dialog_header.dart';
import 'form_action_buttons.dart';

class EditStudentDialog extends ConsumerStatefulWidget {
  final Student student;

  const EditStudentDialog({super.key, required this.student});

  @override
  ConsumerState<EditStudentDialog> createState() => _EditStudentDialogState();
}

class _EditStudentDialogState extends ConsumerState<EditStudentDialog> {
  late final TextEditingController _codigoCtrl;
  late final TextEditingController _nombresCtrl;
  late final TextEditingController _apellidosCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _telefonoCtrl;
  late final TextEditingController _carreraCtrl;
  late final TextEditingController _grupoCtrl;
  late StudentStatus _selectedStatus;
  DateTime? _fechaIngreso;
  bool _isSaving = false;
  bool _isLoadingData = false;
  List<String> _carreras = [];
  List<String> _grupos = [];

  @override
  void initState() {
    super.initState();
    _codigoCtrl = TextEditingController(text: widget.student.codigo);
    _nombresCtrl = TextEditingController(text: widget.student.nombres);
    _apellidosCtrl = TextEditingController(text: widget.student.apellidos);
    _emailCtrl = TextEditingController(text: widget.student.email ?? '');
    _telefonoCtrl = TextEditingController(text: widget.student.telefono ?? '');
    _carreraCtrl = TextEditingController(text: widget.student.carrera ?? '');
    _grupoCtrl = TextEditingController(text: widget.student.grupo ?? '');
    _selectedStatus = widget.student.estado;
    _fechaIngreso = widget.student.fechaIngreso;
    _loadDropdownData();
  }

  Future<void> _loadDropdownData() async {
    setState(() => _isLoadingData = true);
    try {
      final controller = ref.read(studentControllerProvider);
      final carreras = await controller.getAllCareers();
      final grupos = await controller.getAllGroups();
      setState(() {
        _carreras = carreras;
        _grupos = grupos;
      });
    } catch (e) {
      debugPrint('Error loading careers/groups: $e');
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
    _carreraCtrl.dispose();
    _grupoCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final nombres = _nombresCtrl.text.trim();
    final apellidos = _apellidosCtrl.text.trim();

    if (nombres.isEmpty) {
      _showMessage('El nombre es requerido');
      return;
    }
    if (apellidos.isEmpty) {
      _showMessage('El apellido es requerido');
      return;
    }

    setState(() => _isSaving = true);

    final updatedStudent = widget.student.copyWith(
      codigo: _codigoCtrl.text.trim(),
      nombres: nombres,
      apellidos: apellidos,
      email: Value(
        _emailCtrl.text.trim().isEmpty ? null : _emailCtrl.text.trim(),
      ),
      telefono: Value(
        _telefonoCtrl.text.trim().isEmpty ? null : _telefonoCtrl.text.trim(),
      ),
      carrera: Value(
        _carreraCtrl.text.trim().isEmpty ? null : _carreraCtrl.text.trim(),
      ),
      grupo: Value(
        _grupoCtrl.text.trim().isEmpty ? null : _grupoCtrl.text.trim(),
      ),
      estado: _selectedStatus,
      fechaIngreso: Value(_fechaIngreso),
    );

    await ref.read(studentControllerProvider).updateStudent(updatedStudent);
    if (mounted) Navigator.pop(context);
  }

  void _showMessage(String message) {
    AppSnackbar.showWarning(context, message);
  }

  Future<void> _selectFechaIngreso() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _fechaIngreso ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (selected != null) setState(() => _fechaIngreso = selected);
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
                title: 'Editar Estudiante',
                icon: LucideIcons.edit3,
                isKeyboardVisible: isKeyboardVisible,
                isSaving: _isSaving,
                onClose: () => Navigator.pop(context),
              ),
              SizedBox(height: isKeyboardVisible ? 12 : 24),

              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PersonalDataSection(
                        codigoCtrl: _codigoCtrl,
                        nombresCtrl: _nombresCtrl,
                        apellidosCtrl: _apellidosCtrl,
                        emailCtrl: _emailCtrl,
                        telefonoCtrl: _telefonoCtrl,
                        isEdit: true,
                      ),
                      const SizedBox(height: 24),
                      AcademicDataSection(
                        isLoadingData: _isLoadingData,
                        selectedCarrera: _carreras.contains(_carreraCtrl.text)
                            ? _carreraCtrl.text
                            : null,
                        selectedGrupo: _grupos.contains(_grupoCtrl.text)
                            ? _grupoCtrl.text
                            : null,
                        carreras: _carreras,
                        grupos: _grupos,
                        selectedStatus: _selectedStatus,
                        fechaIngreso: _fechaIngreso,
                        onCarreraChanged: (v) =>
                            setState(() => _carreraCtrl.text = v ?? ''),
                        onGrupoChanged: (v) =>
                            setState(() => _grupoCtrl.text = v ?? ''),
                        onStatusChanged: (value) {
                          if (value != null) {
                            setState(() => _selectedStatus = value);
                          }
                        },
                        onSelectFechaIngreso: _selectFechaIngreso,
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),

              FormActionButtons(
                isLoading: _isSaving,
                onBack: () => Navigator.pop(context),
                onNext: _save,
                backLabel: 'Cancelar',
                nextLabel: 'Actualizar',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
