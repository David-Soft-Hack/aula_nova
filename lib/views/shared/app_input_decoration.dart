import 'package:flutter/material.dart';
import '../../config/theme/app_theme.dart';

class AppInputDecoration {
  static InputDecoration build({
    required String hintText,
    required IconData prefixIcon,
    double borderRadius = 12,
    bool filled = true,
    Color? fillColor,
    Color? borderColor,
    Color? focusedBorderColor,
    double? borderWidth,
    Color? prefixIconColor,
    EdgeInsetsGeometry? contentPadding,
    String? labelText,
    TextStyle? labelStyle,
    TextStyle? errorStyle,
    Color? errorBorderColor,
    Color? focusedErrorBorderColor,
    bool showErrors = false,
  }) {
    final defaultBorder = BorderSide(color: borderColor ?? Colors.grey.shade200);
    return InputDecoration(
      hintText: labelText == null ? hintText : null,
      labelText: labelText,
      labelStyle: labelStyle,
      prefixIcon: Icon(prefixIcon, size: 20, color: prefixIconColor),
      filled: filled,
      fillColor: fillColor ?? Colors.grey.shade50,
      contentPadding: contentPadding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      errorStyle: errorStyle,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: defaultBorder,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: defaultBorder,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(
          color: focusedBorderColor ?? AppTheme.academic600,
          width: borderWidth ?? 1.5,
        ),
      ),
      errorBorder: showErrors
          ? OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(color: errorBorderColor ?? Colors.red.shade400),
            )
          : null,
      focusedErrorBorder: showErrors
          ? OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide:
                  BorderSide(color: focusedErrorBorderColor ?? Colors.red.shade600, width: borderWidth ?? 1.5),
            )
          : null,
    );
  }

  static InputDecoration compact({
    required String hintText,
    IconData? prefixIcon,
    double borderRadius = 10,
    Color? fillColor,
    Color? borderColor,
    Color? focusedBorderColor,
    double? borderWidth,
    Color? prefixIconColor,
  }) {
    final defaultBorder = BorderSide(color: borderColor ?? Colors.grey.shade200);
    return InputDecoration(
      hintText: hintText,
      prefixIcon: prefixIcon != null ? Icon(prefixIcon, size: 18, color: prefixIconColor) : null,
      filled: true,
      fillColor: fillColor ?? Colors.grey.shade50,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: defaultBorder,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: defaultBorder,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(
          color: focusedBorderColor ?? AppTheme.academic600,
          width: borderWidth ?? 1.5,
        ),
      ),
    );
  }
}
