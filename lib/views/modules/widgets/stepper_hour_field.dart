import 'package:flutter/material.dart';

/// Campo de hora reutilizable para los steppers de Unidades y Actividades.
class StepperHourField extends StatelessWidget {
  final TextEditingController? controller;
  final String label;
  final IconData icon;
  final ValueChanged<String> onChanged;
  final Color accent;

  const StepperHourField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    required this.onChanged,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      onChanged: onChanged,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: accent),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontSize: 10, color: Colors.grey.shade600),
        prefixIcon: Icon(icon, size: 14, color: accent),
        prefixIconConstraints: const BoxConstraints(minWidth: 32, minHeight: 32),
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: accent, width: 1.5)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      ),
    );
  }
}
