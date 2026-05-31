import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../config/theme/app_theme.dart';
import '../../../database/tables.dart';
import 'student_dropdown_field.dart';

class ClassGroupStep extends StatelessWidget {
  final bool isLoadingData;
  final List<String> carreras;
  final List<String> grupos;
  final String? selectedCarrera;
  final String? selectedGrupo;
  final StudentStatus selectedStatus;
  final DateTime? fechaIngreso;
  final ValueChanged<String?> onCarreraChanged;
  final ValueChanged<String?> onGrupoChanged;
  final ValueChanged<StudentStatus?> onStatusChanged;
  final VoidCallback onSelectFechaIngreso;

  const ClassGroupStep({
    super.key,
    required this.isLoadingData,
    required this.carreras,
    required this.grupos,
    required this.selectedCarrera,
    required this.selectedGrupo,
    required this.selectedStatus,
    required this.fechaIngreso,
    required this.onCarreraChanged,
    required this.onGrupoChanged,
    required this.onStatusChanged,
    required this.onSelectFechaIngreso,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Paso 2: Datos de Grupo de Clase',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 16),
        if (isLoadingData)
          const Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: LinearProgressIndicator(),
          )
        else
          StudentDropdownField(
            label: 'Carrera',
            icon: LucideIcons.graduationCap,
            value: selectedCarrera,
            items: carreras,
            onChanged: onCarreraChanged,
            hintText: 'Selecciona una carrera',
            isRequired: true,
          ),
        StudentDropdownField(
          label: 'Grupo',
          icon: LucideIcons.users,
          value: selectedGrupo,
          items: grupos,
          onChanged: onGrupoChanged,
          hintText: 'Selecciona un grupo',
          isRequired: true,
        ),
        const SizedBox(height: 16),
        const Text(
          'Estado',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<StudentStatus>(
          initialValue: selectedStatus,
          items: StudentStatus.values.map((status) {
            final label = status == StudentStatus.activo
                ? 'Activo'
                : status == StudentStatus.inactivo
                ? 'Inactivo'
                : 'Graduado';
            return DropdownMenuItem(value: status, child: Text(label));
          }).toList(),
          onChanged: onStatusChanged,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            enabledBorder: OutlineInputBorder(
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
                onPressed: onSelectFechaIngreso,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.slate900,
                  side: BorderSide(color: Colors.grey.shade200),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.grey.shade200),
                  ),
                ),
                child: Text(
                  fechaIngreso == null
                      ? 'Fecha de ingreso'
                      : '${fechaIngreso!.day}/${fechaIngreso!.month}/${fechaIngreso!.year}',
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
