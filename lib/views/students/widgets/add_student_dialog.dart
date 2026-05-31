import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../config/theme/app_theme.dart';
import '../../../controllers/student_controller.dart';
import '../../../database/tables.dart';

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
      print('Error loading dropdown data: $e');
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
    super.dispose();
  }

  bool _validateStep1() {
    final codigo = _codigoCtrl.text.trim();
    final nombres = _nombresCtrl.text.trim();
    final apellidos = _apellidosCtrl.text.trim();

    if (codigo.isEmpty) {
      _showMessage('El código es requerido');
      return false;
    }
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _save() async {
    final codigo = _codigoCtrl.text.trim();

    setState(() {
      _isSaving = true;
    });

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
        telefono: _telefonoCtrl.text.trim().isEmpty ? null : _telefonoCtrl.text.trim(),
        carrera: _selectedCarrera,
        grupo: _selectedGrupo,
        status: _selectedStatus,
        fechaIngreso: _fechaIngreso,
      );

      if (mounted) {
        Navigator.pop(context);
      }
    } finally {
      setState(() {
        _isSaving = false;
      });
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
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.academic50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(LucideIcons.userPlus, color: AppTheme.academic600, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text('Nuevo Estudiante', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, fontSize: 18)),
                  ),
                  IconButton(
                    onPressed: _isSaving ? null : () => Navigator.pop(context),
                    icon: Icon(LucideIcons.x, color: Colors.grey.shade400, size: 20),
                    splashRadius: 20,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Progress indicator
              Row(
                children: List.generate(2, (index) {
                  final isActive = index <= _currentStep;
                  return Expanded(
                    child: Column(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: isActive ? AppTheme.academic600 : Colors.grey.shade200,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text('${index + 1}', style: TextStyle(color: isActive ? Colors.white : Colors.grey.shade600, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          index == 0 ? 'Datos Personales' : 'Grupo de Clase',
                          style: TextStyle(fontWeight: index <= _currentStep ? FontWeight.w600 : FontWeight.w400, fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                        if (index < 1)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Container(
                              height: 2,
                              color: isActive ? AppTheme.academic600 : Colors.grey.shade200,
                            ),
                          ),
                      ],
                    ),
                  );
                }),
              ),
              const SizedBox(height: 24),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  child: _currentStep == 0 ? _buildStep1() : _buildStep2(),
                ),
              ),

              // Buttons
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
                      child: const Text('Cancelar', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _handleNextOrSave,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.academic600,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: _isSaving
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : Text(_currentStep == 0 ? 'Siguiente' : 'Guardar', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
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
      if (_validateStep1()) {
        setState(() {
          _currentStep = 1;
        });
      }
    } else {
      if (_validateStep2()) {
        _save();
      }
    }
  }

  Widget _buildStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Paso 1: Información Personal', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 16),
        _buildTextField(label: 'Código', controller: _codigoCtrl, icon: LucideIcons.hash, keyboardType: TextInputType.text),
        _buildTextField(label: 'Nombres', controller: _nombresCtrl, icon: LucideIcons.user, keyboardType: TextInputType.text),
        _buildTextField(label: 'Apellidos', controller: _apellidosCtrl, icon: LucideIcons.user, keyboardType: TextInputType.text),
        _buildTextField(label: 'Email', controller: _emailCtrl, icon: LucideIcons.mail, keyboardType: TextInputType.emailAddress),
        _buildTextField(label: 'Teléfono', controller: _telefonoCtrl, icon: LucideIcons.phone, keyboardType: TextInputType.phone),
      ],
    );
  }

  Widget _buildStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Paso 2: Datos de Grupo de Clase', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 16),
        if (_isLoadingData)
          const Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: LinearProgressIndicator(),
          )
        else
          _buildDropdownField(
            label: 'Carrera',
            icon: LucideIcons.graduationCap,
            value: _selectedCarrera,
            items: _carreras,
            onChanged: (value) {
              setState(() {
                _selectedCarrera = value;
              });
            },
          ),
        _buildDropdownField(
          label: 'Grupo',
          icon: LucideIcons.users,
          value: _selectedGrupo,
          items: _grupos,
          onChanged: (value) {
            setState(() {
              _selectedGrupo = value;
            });
          },
        ),
        const SizedBox(height: 16),
        const Text('Estado', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
        const SizedBox(height: 8),
        DropdownButtonFormField<StudentStatus>(
          value: _selectedStatus,
          items: StudentStatus.values.map((status) {
            final label = status == StudentStatus.activo
                ? 'Activo'
                : status == StudentStatus.inactivo
                    ? 'Inactivo'
                    : 'Graduado';
            return DropdownMenuItem(value: status, child: Text(label));
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
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
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
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  _fechaIngreso == null ? 'Fecha de ingreso' : '${_fechaIngreso!.day}/${_fechaIngreso!.month}/${_fechaIngreso!.year}',
                ),
              ),
            ),
          ],
        ),
      ],
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
          Text(label, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: Colors.grey.shade500, size: 18),
              filled: true,
              fillColor: Colors.grey.shade50,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppTheme.academic600, width: 1.5)),
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
          Text(label, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: value,
            items: items.map((item) {
              return DropdownMenuItem(value: item, child: Text(item));
            }).toList(),
            onChanged: onChanged,
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: Colors.grey.shade500, size: 18),
              filled: true,
              fillColor: Colors.grey.shade50,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppTheme.academic600, width: 1.5)),
            ),
          ),
        ],
      ),
    );
  }
}
