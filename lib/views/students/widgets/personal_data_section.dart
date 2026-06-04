import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../config/theme/app_theme.dart';
import 'student_text_field.dart';

class PersonalDataSection extends StatelessWidget {
  final TextEditingController codigoCtrl;
  final TextEditingController nombresCtrl;
  final TextEditingController apellidosCtrl;
  final TextEditingController emailCtrl;
  final TextEditingController telefonoCtrl;
  final bool isEdit;

  const PersonalDataSection({
    super.key,
    required this.codigoCtrl,
    required this.nombresCtrl,
    required this.apellidosCtrl,
    required this.emailCtrl,
    required this.telefonoCtrl,
    this.isEdit = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Información Personal',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: AppTheme.slate900,
          ),
        ),
        const SizedBox(height: 16),
        StudentTextField(
          label: 'Código',
          controller: codigoCtrl,
          icon: LucideIcons.hash,
          keyboardType: TextInputType.text,
          enabled: false,
          hintText: !isEdit && codigoCtrl.text.isEmpty
              ? 'Se generará automáticamente al elegir grupo'
              : null,
        ),
        StudentTextField(
          label: 'Nombres *',
          controller: nombresCtrl,
          icon: LucideIcons.user,
          keyboardType: TextInputType.text,
        ),
        StudentTextField(
          label: 'Apellidos *',
          controller: apellidosCtrl,
          icon: LucideIcons.user,
          keyboardType: TextInputType.text,
        ),
        StudentTextField(
          label: 'Email (Opcional)',
          controller: emailCtrl,
          icon: LucideIcons.mail,
          keyboardType: TextInputType.emailAddress,
        ),
        StudentTextField(
          label: 'Teléfono (Opcional)',
          controller: telefonoCtrl,
          icon: LucideIcons.phone,
          keyboardType: TextInputType.phone,
        ),
      ],
    );
  }
}
