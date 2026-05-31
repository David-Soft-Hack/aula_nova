import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../config/theme/app_theme.dart';
import '../../../controllers/student_controller.dart';
import '../../../database/app_database.dart';
import '../../../database/tables.dart';

class EditStudentDialog extends StatefulWidget {
  final StudentController controller;
  final Student student;

  const EditStudentDialog({
    super.key,
    required this.controller,
    required this.student,
  });

  @override
  State<EditStudentDialog> createState() => _EditStudentDialogState();
}

class _EditStudentDialogState extends State<EditStudentDialog> {
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
    setState(() {
      _isLoadingData = true;
    });

    try {
      final carreras = await widget.controller.getAllCareers();
      final grupos = await widget.controller.getAllGroups();

      setState(() {
        _carreras = carreras;
        _grupos = grupos;
      });
    } catch (e) {
      // ignore: avoid_print
      print('Error loading careers/groups: $e');
    } finally {
      setState(() {
        _isLoadingData = false;
      });
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
    setState(() {
      _isSaving = true;
    });

    final updatedStudent = widget.student.copyWith(
      codigo: _codigoCtrl.text.trim(),
      nombres: _nombresCtrl.text.trim(),
      apellidos: _apellidosCtrl.text.trim(),
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

    await widget.controller.updateStudent(updatedStudent);
    if (mounted) Navigator.pop(context);
  }

  Future<void> _selectFechaIngreso() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _fechaIngreso ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (selected != null) {
      setState(() {
        _fechaIngreso = selected;
      });
    }
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
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.academic50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      LucideIcons.edit3,
                      color: AppTheme.academic600,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Editar Estudiante',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      LucideIcons.x,
                      color: Colors.grey.shade400,
                      size: 20,
                    ),
                    splashRadius: 20,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTextField(
                        label: 'Código',
                        controller: _codigoCtrl,
                        icon: LucideIcons.hash,
                        keyboardType: TextInputType.text,
                      ),
                      _buildTextField(
                        label: 'Nombres',
                        controller: _nombresCtrl,
                        icon: LucideIcons.user,
                        keyboardType: TextInputType.text,
                      ),
                      _buildTextField(
                        label: 'Apellidos',
                        controller: _apellidosCtrl,
                        icon: LucideIcons.user,
                        keyboardType: TextInputType.text,
                      ),
                      _buildTextField(
                        label: 'Email',
                        controller: _emailCtrl,
                        icon: LucideIcons.mail,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      _buildTextField(
                        label: 'Teléfono',
                        controller: _telefonoCtrl,
                        icon: LucideIcons.phone,
                        keyboardType: TextInputType.phone,
                      ),

                      // Carrera: prefer dropdown if data loaded
                      if (_isLoadingData)
                        const Padding(
                          padding: EdgeInsets.only(bottom: 16),
                          child: LinearProgressIndicator(),
                        )
                      else if (_carreras.isNotEmpty)
                        _buildDropdownField(
                          label: 'Carrera',
                          icon: LucideIcons.graduationCap,
                          value: _carreras.contains(_carreraCtrl.text)
                              ? _carreraCtrl.text
                              : null,
                          items: _carreras,
                          onChanged: (v) {
                            setState(() {
                              _carreraCtrl.text = v ?? '';
                            });
                          },
                        )
                      else
                        _buildTextField(
                          label: 'Carrera',
                          controller: _carreraCtrl,
                          icon: LucideIcons.graduationCap,
                          keyboardType: TextInputType.text,
                        ),

                      // Grupo: prefer dropdown if data loaded
                      if (_grupos.isNotEmpty)
                        _buildDropdownField(
                          label: 'Grupo',
                          icon: LucideIcons.users,
                          value: _grupos.contains(_grupoCtrl.text)
                              ? _grupoCtrl.text
                              : null,
                          items: _grupos,
                          onChanged: (v) {
                            setState(() {
                              _grupoCtrl.text = v ?? '';
                            });
                          },
                        )
                      else
                        _buildTextField(
                          label: 'Grupo',
                          controller: _grupoCtrl,
                          icon: LucideIcons.users,
                          keyboardType: TextInputType.text,
                        ),
                      const SizedBox(height: 16),
                      const Text(
                        'Estado',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<StudentStatus>(
                        initialValue: _selectedStatus,
                        items: StudentStatus.values.map((status) {
                          return DropdownMenuItem(
                            value: status,
                            child: Text(status.name.toUpperCase()),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedStatus = value;
                            });
                          }
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey.shade50,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade200),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: _selectFechaIngreso,
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppTheme.slate900,
                                side: BorderSide(color: Colors.grey.shade200),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                _fechaIngreso == null
                                    ? 'Fecha de ingreso'
                                    : '${_fechaIngreso!.day}/${_fechaIngreso!.month}/${_fechaIngreso!.year}',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
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
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Cancelar',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
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
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
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
                              'Actualizar',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
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

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: Colors.grey.shade500, size: 18),
              filled: true,
              fillColor: Colors.grey.shade50,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
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
                borderSide: const BorderSide(
                  color: AppTheme.academic600,
                  width: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required IconData icon,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            initialValue: value,
            items: items
                .map((item) => DropdownMenuItem(value: item, child: Text(item)))
                .toList(),
            onChanged: onChanged,
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: Colors.grey.shade500, size: 18),
              filled: true,
              fillColor: Colors.grey.shade50,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
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
                borderSide: const BorderSide(
                  color: AppTheme.academic600,
                  width: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
