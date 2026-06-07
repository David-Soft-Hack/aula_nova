import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../config/theme/app_theme.dart';
import '../../../../database/app_database.dart';
import 'form_module_dropdown.dart';
import 'form_session_hours.dart';
import 'form_weekly_frequency.dart';
import 'form_holiday_dates.dart';

class BitacoraStep1Form extends StatelessWidget {
  final Module? selectedModule;
  final ValueChanged<Module?> onModuleChanged;
  final TextEditingController grupoCtrl;
  final TextEditingController carreraCtrl;
  final String selectedShift;
  final ValueChanged<String?> onShiftChanged;
  final int horasSesion;
  final ValueChanged<int> onHorasSesionChanged;
  final bool usarHorasReloj;
  final ValueChanged<bool> onUsarHorasRelojChanged;
  final DateTime startDate;
  final VoidCallback onPickDate;
  final List<String> diasSeleccionados;
  final ValueChanged<String> onToggleDia;
  final List<DateTime> fechasFeriadas;
  final VoidCallback onAddFechaFeriada;
  final ValueChanged<DateTime> onRemoveFechaFeriada;
  final List<String> diasSemana;

  const BitacoraStep1Form({
    super.key,
    required this.selectedModule,
    required this.onModuleChanged,
    required this.grupoCtrl,
    required this.carreraCtrl,
    required this.selectedShift,
    required this.onShiftChanged,
    required this.horasSesion,
    required this.onHorasSesionChanged,
    required this.usarHorasReloj,
    required this.onUsarHorasRelojChanged,
    required this.startDate,
    required this.onPickDate,
    required this.diasSeleccionados,
    required this.onToggleDia,
    required this.fechasFeriadas,
    required this.onAddFechaFeriada,
    required this.onRemoveFechaFeriada,
    required this.diasSemana,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormModuleDropdown(
          selectedModule: selectedModule,
          onModuleChanged: onModuleChanged,
        ),
        const SizedBox(height: 20),
        _buildGroupAndCareerFields(),
        const SizedBox(height: 20),
        FormSessionHours(
          selectedShift: selectedShift,
          onShiftChanged: onShiftChanged,
          horasSesion: horasSesion,
          onHorasSesionChanged: onHorasSesionChanged,
          usarHorasReloj: usarHorasReloj,
          onUsarHorasRelojChanged: onUsarHorasRelojChanged,
        ),
        const SizedBox(height: 20),
        _buildStartDatePicker(context),
        const SizedBox(height: 24),
        FormWeeklyFrequency(
          diasSemana: diasSemana,
          diasSeleccionados: diasSeleccionados,
          onToggleDia: onToggleDia,
        ),
        const SizedBox(height: 24),
        FormHolidayDates(
          fechasFeriadas: fechasFeriadas,
          onAddFechaFeriada: onAddFechaFeriada,
          onRemoveFechaFeriada: onRemoveFechaFeriada,
        ),
      ],
    );
  }

  Widget _buildGroupAndCareerFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Código de Grupo',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Identifica el grupo al que pertenece esta bitácora',
          style: TextStyle(
            fontSize: 11,
            color: Color(0xFF9CA3AF),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: grupoCtrl,
          decoration: InputDecoration(
            hintText: 'Ej. S-24A',
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            prefixIcon: const Icon(
              LucideIcons.users,
              size: 18,
              color: AppTheme.academic600,
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: AppTheme.academic600,
                width: 1.5,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Carrera / Programa',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Programa académico al que pertenece este grupo',
          style: TextStyle(
            fontSize: 11,
            color: Color(0xFF9CA3AF),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: carreraCtrl,
          decoration: InputDecoration(
            hintText: 'Ej. Computación',
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            prefixIcon: const Icon(
              LucideIcons.graduationCap,
              size: 18,
              color: AppTheme.academic600,
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: AppTheme.academic600,
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStartDatePicker(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Fecha de Inicio de Clases',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Primera sesión a partir de la cual se generará el calendario',
          style: TextStyle(
            fontSize: 11,
            color: Color(0xFF9CA3AF),
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: onPickDate,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              children: [
                const Icon(LucideIcons.calendar, size: 18, color: AppTheme.academic600),
                const SizedBox(width: 12),
                Text(
                  DateFormat('dd MMMM, yyyy', 'es').format(startDate),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                const Spacer(),
                Icon(
                  LucideIcons.chevronDown,
                  size: 16,
                  color: Colors.grey.shade400,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
