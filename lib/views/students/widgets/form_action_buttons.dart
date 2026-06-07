import 'package:flutter/material.dart';
import '../../../config/theme/app_theme.dart';

class FormActionButtons extends StatelessWidget {
  final bool isLoading;
  final VoidCallback? onBack;
  final VoidCallback? onNext;
  final String? backLabel;
  final String? nextLabel;
  final Color? primaryColor;
  final Color? backForegroundColor;
  final double borderRadius;
  final bool hideBack;

  const FormActionButtons({
    super.key,
    this.isLoading = false,
    this.onBack,
    this.onNext,
    this.backLabel,
    this.nextLabel,
    this.primaryColor,
    this.backForegroundColor,
    this.borderRadius = 12,
    this.hideBack = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (!hideBack) ...[
          Expanded(
            child: OutlinedButton(
              onPressed: isLoading ? null : onBack,
              style: OutlinedButton.styleFrom(
                foregroundColor: backForegroundColor ?? AppTheme.slate900,
                side: BorderSide(color: Colors.grey.shade200),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
              ),
              child: Text(
                backLabel ?? 'Cancelar',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
        ],
        Expanded(
          child: ElevatedButton(
            onPressed: isLoading ? null : onNext,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor ?? AppTheme.academic600,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius),
              ),
            ),
            child: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    nextLabel ?? 'Siguiente',
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
