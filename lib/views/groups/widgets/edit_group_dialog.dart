import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:drift/drift.dart' as drift;
import '../../../config/theme/app_theme.dart';
import '../../../database/app_database.dart';
import '../../../database/tables.dart';
import '../../../providers/class_group_providers.dart';
import '../../../providers/career_providers.dart';
import '../../shared/app_input_decoration.dart';
import '../../shared/app_snackbar.dart';
import '../../shared/full_screen_dialog_layout.dart';

class EditGroupDialog extends ConsumerStatefulWidget {
  final ClassGroup group;

  const EditGroupDialog({super.key, required this.group});

  @override
  ConsumerState<EditGroupDialog> createState() => _EditGroupDialogState();
}

class _EditGroupDialogState extends ConsumerState<EditGroupDialog> {
  late TextEditingController _codigoCtrl;
  late TextEditingController _cicloCtrl;
  String? _selectedCarrera;
  String? _selectedTurno;
  late EstadoGrupo _selectedEstado;
  DateTime? _fechaInicio;
  DateTime? _fechaFin;

  bool _isSaving = false;

  final List<String> _turnos = ['Mañana', 'Tarde', 'Noche', 'Jornada Completa'];

  @override
  void initState() {
    super.initState();
    _codigoCtrl = TextEditingController(text: widget.group.codigo);
    _cicloCtrl = TextEditingController(text: widget.group.ciclo);
    _selectedCarrera = widget.group.carrera;
    _selectedTurno = widget.group.turno;
    _selectedEstado = widget.group.estado;
    _fechaInicio = widget.group.fechaInicio;
    _fechaFin = widget.group.fechaFin;
  }

  @override
  void dispose() {
    _codigoCtrl.dispose();
    _cicloCtrl.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final initialDate = isStart
        ? (_fechaInicio ?? DateTime.now())
        : (_fechaFin ?? _fechaInicio ?? DateTime.now());
    
    final selected = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selected != null) {
      setState(() {
        if (isStart) {
          _fechaInicio = selected;
          if (_fechaFin != null && _fechaFin!.isBefore(_fechaInicio!)) {
            _fechaFin = null;
          }
        } else {
          _fechaFin = selected;
        }
      });
    }
  }

  Future<void> _save() async {
    final codigo = _codigoCtrl.text.trim();
    if (codigo.isEmpty) {
      AppSnackbar.showWarning(context, 'El código es requerido');
      return;
    }
    if (_selectedCarrera == null) {
      AppSnackbar.showWarning(context, 'Seleccione una carrera');
      return;
    }

    setState(() => _isSaving = true);
    try {
      final controller = ref.read(classGroupControllerProvider);
      
      // Solo verificamos duplicado si el código cambió
      if (codigo != widget.group.codigo) {
        final exists = await controller.existsGroupByCodigo(codigo);
        if (exists) {
          AppSnackbar.showError(
            context,
            'Código duplicado',
            description: 'Ya existe un grupo con el código "$codigo".',
          );
          return;
        }
      }

      final updatedGroup = widget.group.copyWith(
        codigo: codigo,
        carrera: _selectedCarrera,
        turno: drift.Value(_selectedTurno),
        ciclo: drift.Value(_cicloCtrl.text.trim().isEmpty ? null : _cicloCtrl.text.trim()),
        estado: _selectedEstado,
        fechaInicio: drift.Value(_fechaInicio),
        fechaFin: drift.Value(_fechaFin),
      );

      await controller.updateGroup(updatedGroup);

      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        AppSnackbar.showError(context, 'Error', description: e.toString());
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FullScreenDialogLayout(
      children: [
              _buildHeader(context),
              const SizedBox(height: 24),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTextField(
                        controller: _codigoCtrl,
                        label: 'Código de Grupo *',
                        hint: 'Ej. S-24A',
                        icon: LucideIcons.hash,
                      ),
                      const SizedBox(height: 16),
                      _buildCarreraDropdown(),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildDropdownField(
                              label: 'Turno',
                              value: _selectedTurno,
                              items: _turnos,
                              onChanged: (v) => setState(() => _selectedTurno = v),
                              icon: LucideIcons.clock,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildTextField(
                              controller: _cicloCtrl,
                              label: 'Ciclo Académico',
                              hint: 'Ej. 2024-I',
                              icon: LucideIcons.calendarDays,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildEstadoDropdown(),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildDatePicker(
                              label: 'Fecha de Inicio',
                              date: _fechaInicio,
                              onTap: () => _selectDate(context, true),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildDatePicker(
                              label: 'Fecha de Fin',
                              date: _fechaFin,
                              onTap: () => _selectDate(context, false),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _isSaving ? null : () => Navigator.pop(context),
                    child: const Text('Cancelar'),
                  ),
                  const SizedBox(width: 12),
                  FilledButton(
                    onPressed: _isSaving ? null : _save,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppTheme.academic600,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: _isSaving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Text('Guardar Cambios'),
                  ),
                ],
              ),
            ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.academic50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(LucideIcons.edit3, color: AppTheme.academic600),
            ),
            const SizedBox(width: 16),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Editar Grupo',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Outfit',
                  ),
                ),
                Text(
                  'Modifica los datos del grupo',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(LucideIcons.x),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black87)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: AppInputDecoration.build(
            hintText: hint,
            prefixIcon: icon,
            borderColor: Colors.grey.shade300,
            borderWidth: 2,
            prefixIconColor: Colors.grey.shade400,
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black87)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          isExpanded: true,
          initialValue: value,
          icon: const Icon(LucideIcons.chevronDown, size: 20),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.grey.shade400, size: 20),
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
          ),
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildCarreraDropdown() {
    final careersAsync = ref.watch(allCareersStreamProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Carrera o Programa *', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black87)),
        const SizedBox(height: 8),
        careersAsync.when(
          loading: () => const CircularProgressIndicator(),
          error: (e, _) => Text('Error: $e'),
          data: (careers) {
            final names = careers.map((c) => c.nombre).toList();
            return DropdownButtonFormField<String>(
              isExpanded: true,
              initialValue: names.contains(_selectedCarrera) ? _selectedCarrera : null,
              hint: const Text('Seleccione...'),
              icon: const Icon(LucideIcons.chevronDown, size: 20),
              decoration: InputDecoration(
                prefixIcon: Icon(LucideIcons.graduationCap, color: Colors.grey.shade400, size: 20),
                filled: true,
                fillColor: Colors.grey.shade50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              items: names.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (v) => setState(() => _selectedCarrera = v),
            );
          },
        ),
      ],
    );
  }

  Widget _buildEstadoDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Estado del Grupo', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black87)),
        const SizedBox(height: 8),
        DropdownButtonFormField<EstadoGrupo>(
          isExpanded: true,
          initialValue: _selectedEstado,
          icon: const Icon(LucideIcons.chevronDown, size: 20),
          decoration: InputDecoration(
            prefixIcon: Icon(LucideIcons.activity, color: Colors.grey.shade400, size: 20),
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
          ),
          items: const [
            DropdownMenuItem(value: EstadoGrupo.activo, child: Text('Activo')),
            DropdownMenuItem(value: EstadoGrupo.suspendido, child: Text('Suspendido')),
            DropdownMenuItem(value: EstadoGrupo.finalizado, child: Text('Finalizado')),
          ],
          onChanged: (v) {
            if (v != null) setState(() => _selectedEstado = v);
          },
        ),
      ],
    );
  }

  Widget _buildDatePicker({
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black87)),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                Icon(LucideIcons.calendar, color: Colors.grey.shade400, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    date != null ? '${date.day}/${date.month}/${date.year}' : 'Seleccionar',
                    style: TextStyle(
                      color: date != null ? Colors.black87 : Colors.grey.shade500,
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
