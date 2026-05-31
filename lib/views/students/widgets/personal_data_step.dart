import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'student_text_field.dart';

class PersonalDataStep extends StatelessWidget {
  final TextEditingController codigoCtrl;
  final TextEditingController nombresCtrl;
  final TextEditingController apellidosCtrl;
  final TextEditingController emailCtrl;
  final TextEditingController telefonoCtrl;

  const PersonalDataStep({
    super.key,
    required this.codigoCtrl,
    required this.nombresCtrl,
    required this.apellidosCtrl,
    required this.emailCtrl,
    required this.telefonoCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Paso 1: Información Personal',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 16),
        StudentTextField(
          label: 'Código',
          controller: codigoCtrl,
          icon: LucideIcons.hash,
          keyboardType: TextInputType.text,
          hintText: 'Se asignará automáticamente',
          isRequired: true,
          enabled: false,
        ),
        StudentTextField(
          label: 'Nombres',
          controller: nombresCtrl,
          icon: LucideIcons.user,
          keyboardType: TextInputType.text,
          hintText: 'Ej: Juan Carlos',
          isRequired: true,
        ),
        StudentTextField(
          label: 'Apellidos',
          controller: apellidosCtrl,
          icon: LucideIcons.user,
          keyboardType: TextInputType.text,
          hintText: 'Ej: Pérez López',
          isRequired: true,
        ),
        StudentTextField(
          label: 'Email',
          controller: emailCtrl,
          icon: LucideIcons.mail,
          keyboardType: TextInputType.emailAddress,
          hintText: 'Ej: juan@correo.com',
          isRequired: false,
        ),
        StudentTextField(
          label: 'Teléfono',
          controller: telefonoCtrl,
          icon: LucideIcons.phone,
          keyboardType: TextInputType.phone,
          hintText: 'Ej: +51 987654321',
          isRequired: true,
        ),
      ],
    );
  }
}
