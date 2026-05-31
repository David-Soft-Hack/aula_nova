import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../config/theme/app_theme.dart';

class FormSessionHours extends StatelessWidget {
  final String selectedShift;
  final ValueChanged<String?> onShiftChanged;
  final int horasSesion;
  final ValueChanged<int> onHorasSesionChanged;
  final bool usarHorasReloj;
  final ValueChanged<bool> onUsarHorasRelojChanged;

  const FormSessionHours({
    super.key,
    required this.selectedShift,
    required this.onShiftChanged,
    required this.horasSesion,
    required this.onHorasSesionChanged,
    required this.usarHorasReloj,
    required this.onUsarHorasRelojChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButtonFormField<String>(
          isExpanded: true,
          initialValue: selectedShift,
          decoration: InputDecoration(
            labelText: 'Turno',
            labelStyle: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
            prefixIcon: const Icon(
              LucideIcons.sun,
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
          items: ['Mañana', 'Tarde', 'Noche'].map((s) {
            return DropdownMenuItem(value: s, child: Text(s));
          }).toList(),
          onChanged: onShiftChanged,
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              flex: 1,
              child: TextFormField(
                initialValue: horasSesion.toString(),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  labelText: 'Horas por Sesión',
                  labelStyle: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade600,
                  ),
                  prefixIcon: const Icon(
                    LucideIcons.clock,
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
                onChanged: (val) {
                  final parsed = int.tryParse(val);
                  if (parsed != null && parsed > 0) {
                    onHorasSesionChanged(parsed);
                  }
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Tipo de Hora',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            usarHorasReloj ? 'Reloj (60m)' : 'Académica (45m)',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: usarHorasReloj ? AppTheme.academic700 : Colors.grey.shade800,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: usarHorasReloj,
                      onChanged: onUsarHorasRelojChanged,
                      activeThumbColor: AppTheme.academic600,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
