import 'package:flutter/material.dart';

/// Tipos de snackbar disponibles
enum SnackbarType { success, error, warning, info }

/// Snackbar premium con diseño oscuro tipo card flotante.
/// Incluye icono colorido, título, descripción opcional y flecha de acción.
class AppSnackbar {
  // ---------------------------------------------------------------------------
  // Métodos públicos de conveniencia
  // ---------------------------------------------------------------------------

  static void showSuccess(
    BuildContext context,
    String title, {
    String? description,
    VoidCallback? onTap,
  }) {
    _show(
      context,
      type: SnackbarType.success,
      title: title,
      description: description,
      onTap: onTap,
    );
  }

  static void showError(
    BuildContext context,
    String title, {
    String? description,
    VoidCallback? onTap,
  }) {
    _show(
      context,
      type: SnackbarType.error,
      title: title,
      description: description,
      onTap: onTap,
    );
  }

  static void showWarning(
    BuildContext context,
    String title, {
    String? description,
    VoidCallback? onTap,
  }) {
    _show(
      context,
      type: SnackbarType.warning,
      title: title,
      description: description,
      onTap: onTap,
    );
  }

  static void showInfo(
    BuildContext context,
    String title, {
    String? description,
    VoidCallback? onTap,
  }) {
    _show(
      context,
      type: SnackbarType.info,
      title: title,
      description: description,
      onTap: onTap,
    );
  }

  // ---------------------------------------------------------------------------
  // Implementación interna
  // ---------------------------------------------------------------------------

  static void _show(
    BuildContext context, {
    required SnackbarType type,
    required String title,
    String? description,
    VoidCallback? onTap,
  }) {
    final config = _SnackbarConfig.fromType(type);

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        duration: const Duration(seconds: 4),
        content: GestureDetector(
          onTap: onTap,
          child: _SnackbarCard(
            config: config,
            title: title,
            description: description,
            showArrow: onTap != null,
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Config por tipo
// ---------------------------------------------------------------------------

class _SnackbarConfig {
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final Color accentBar;

  const _SnackbarConfig({
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.accentBar,
  });

  factory _SnackbarConfig.fromType(SnackbarType type) {
    switch (type) {
      case SnackbarType.success:
        return const _SnackbarConfig(
          icon: Icons.check_rounded,
          iconColor: Color(0xFF22C55E),
          iconBgColor: Color(0x2522C55E),
          accentBar: Color(0xFF22C55E),
        );
      case SnackbarType.error:
        return const _SnackbarConfig(
          icon: Icons.error_rounded,
          iconColor: Color(0xFFEF4444),
          iconBgColor: Color(0x25EF4444),
          accentBar: Color(0xFFEF4444),
        );
      case SnackbarType.warning:
        return const _SnackbarConfig(
          icon: Icons.warning_rounded,
          iconColor: Color(0xFFF59E0B),
          iconBgColor: Color(0x25F59E0B),
          accentBar: Color(0xFFF59E0B),
        );
      case SnackbarType.info:
        return const _SnackbarConfig(
          icon: Icons.info_rounded,
          iconColor: Color(0xFF3B82F6),
          iconBgColor: Color(0x253B82F6),
          accentBar: Color(0xFF3B82F6),
        );
    }
  }
}

// ---------------------------------------------------------------------------
// Widget de la card
// ---------------------------------------------------------------------------

class _SnackbarCard extends StatelessWidget {
  final _SnackbarConfig config;
  final String title;
  final String? description;
  final bool showArrow;

  const _SnackbarCard({
    required this.config,
    required this.title,
    this.description,
    this.showArrow = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.07), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // Barra de acento izquierda
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: Container(
                width: 4,
                decoration: BoxDecoration(
                  color: config.accentBar,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                ),
              ),
            ),
            // Contenido
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
              child: Row(
                children: [
                  // Icono con fondo
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: config.iconBgColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      config.icon,
                      color: config.iconColor,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Texto
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            letterSpacing: 0.1,
                          ),
                        ),
                        if (description != null && description!.isNotEmpty) ...[
                          const SizedBox(height: 3),
                          Text(
                            description!,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.55),
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              height: 1.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  // Flecha (solo si hay acción)
                  if (showArrow) ...[
                    const SizedBox(width: 8),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: Colors.white.withValues(alpha: 0.4),
                      size: 20,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
