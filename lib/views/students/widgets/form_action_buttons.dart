import 'package:flutter/material.dart';
import '../../../config/theme/app_theme.dart';

class FormActionButtons extends StatelessWidget {
  final int currentStep;
  final bool isSaving;
  final VoidCallback onBack;
  final VoidCallback onNext;
  final String? backLabel;
  final String? nextLabel;

  const FormActionButtons({
    super.key,
    required this.currentStep,
    required this.isSaving,
    required this.onBack,
    required this.onNext,
    this.backLabel,
    this.nextLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: isSaving ? null : onBack,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.slate900,
              side: BorderSide(color: Colors.grey.shade200),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              backLabel ?? (currentStep == 1 ? 'Atrás' : 'Cancelar'),
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: isSaving ? null : onNext,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.academic600,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: isSaving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    nextLabel ?? (currentStep == 0 ? 'Siguiente' : 'Guardar'),
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
