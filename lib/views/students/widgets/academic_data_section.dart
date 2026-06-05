import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../config/theme/app_theme.dart';
import '../../../database/tables.dart';
import 'student_dropdown_field.dart';

class AcademicDataSection extends StatelessWidget {
  final bool isLoadingData;
  final String? selectedCarrera;
  final String? selectedGrupo;
  final List<String> carreras;
  final List<String> grupos;
  final StudentStatus selectedStatus;
  final DateTime? fechaIngreso;
  final ValueChanged<String?> onCarreraChanged;
  final ValueChanged<String?> onGrupoChanged;
  final ValueChanged<StudentStatus?> onStatusChanged;
  final VoidCallback onSelectFechaIngreso;

  const AcademicDataSection({
    super.key,
    required this.isLoadingData,
    required this.selectedCarrera,
    required this.selectedGrupo,
    required this.carreras,
    required this.grupos,
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
          'Datos de Grupo de Clase',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: AppTheme.slate900,
          ),
        ),
        const SizedBox(height: 16),
        if (isLoadingData)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24.0),
            child: Center(
              child: CircularProgressIndicator(
                color: AppTheme.academic600,
              ),
            ),
          )
        else ...[
          StudentDropdownField<String>(
            label: 'Carrera *',
            icon: LucideIcons.graduationCap,
            value: selectedCarrera,
            items: carreras,
            onChanged: onCarreraChanged,
          ),
          StudentDropdownField<String>(
            label: 'Grupo *',
            icon: LucideIcons.users,
            value: selectedGrupo,
            items: grupos,
            onChanged: onGrupoChanged,
          ),
        ],
        const SizedBox(height: 16),
        const Text(
          'Estado',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 13,
            color: AppTheme.slate900,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<StudentStatus>(
          initialValue: selectedStatus,
          items: StudentStatus.values.map((status) {
            final label = switch (status) {
              StudentStatus.activo    => 'Activo',
              StudentStatus.inactivo  => 'Inactivo',
              StudentStatus.graduado  => 'Graduado',
              StudentStatus.suspendido => 'Suspendido',
              StudentStatus.finalizado => 'Finalizado',
              StudentStatus.desertado => 'Desertado',
            };
            return DropdownMenuItem(value: status, child: Text(label));
          }).toList(),
          onChanged: onStatusChanged,
          decoration: InputDecoration(
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
        const SizedBox(height: 20),
        const Text(
          'Fecha de Ingreso',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 13,
            color: AppTheme.slate900,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onSelectFechaIngreso,
                icon: const Icon(LucideIcons.calendar, size: 18),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.slate900,
                  side: BorderSide(color: Colors.grey.shade200),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                label: Text(
                  fechaIngreso == null
                      ? 'Seleccionar fecha'
                      : '${fechaIngreso!.day}/${fechaIngreso!.month}/${fechaIngreso!.year}',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
