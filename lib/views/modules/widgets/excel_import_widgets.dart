import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../config/theme/app_theme.dart';

/// Selector de pestaña Manual / Importar Excel estilo Segmented Control deslizante.
class CreationTabSelector extends StatelessWidget {
  final String selectedTab;
  final ValueChanged<String> onTabChanged;

  const CreationTabSelector({
    super.key,
    required this.selectedTab,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isManual = selectedTab == 'manual';
    return Container(
      height: 52,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOutCubic,
            alignment: isManual ? Alignment.centerLeft : Alignment.centerRight,
            child: FractionallySizedBox(
              widthFactor: 0.5,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Row(
            children: [
              _TabOption(
                icon: LucideIcons.fileSignature,
                label: 'Registro Manual',
                isActive: isManual,
                onTap: () => onTabChanged('manual'),
              ),
              _TabOption(
                icon: LucideIcons.sheet,
                label: 'Importar Excel',
                isActive: !isManual,
                onTap: () => onTabChanged('upload'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TabOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _TabOption({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: isActive ? AppTheme.academic600 : Colors.grey.shade500),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: isActive ? AppTheme.academic600 : Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Zona de arrastre/toque interactiva para importar Excel con efecto dashed border dinámico.
class ExcelDropZone extends StatefulWidget {
  final bool isProcessing;
  final VoidCallback onTap;
  final VoidCallback onDownloadTemplate;

  const ExcelDropZone({
    super.key,
    required this.isProcessing,
    required this.onTap,
    required this.onDownloadTemplate,
  });

  @override
  State<ExcelDropZone> createState() => _ExcelDropZoneState();
}

class _ExcelDropZoneState extends State<ExcelDropZone> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final activeColor = _isHovered ? AppTheme.academic600 : AppTheme.academic200;
    final bgColor = _isHovered
        ? AppTheme.academic50.withValues(alpha: 0.6)
        : AppTheme.academic50.withValues(alpha: 0.2);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.isProcessing ? null : widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 250,
          width: double.infinity,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(24),
          ),
          child: CustomPaint(
            painter: DashedRectPainter(color: activeColor, strokeWidth: 2, gap: 8, radius: 24),
            child: Center(
              child: widget.isProcessing
                  ? _ProcessingIndicator()
                  : _DropZoneContent(
                      isHovered: _isHovered,
                      onDownloadTemplate: widget.onDownloadTemplate,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ProcessingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          width: 48,
          height: 48,
          child: CircularProgressIndicator(color: AppTheme.academic600, strokeWidth: 3),
        ),
        const SizedBox(height: 20),
        Text(
          'Procesando archivo Excel...',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.grey.shade700),
        ),
        const SizedBox(height: 4),
        Text(
          'Leyendo celdas y hojas de cálculo',
          style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
        ),
      ],
    );
  }
}

class _DropZoneContent extends StatelessWidget {
  final bool isHovered;
  final VoidCallback onDownloadTemplate;

  const _DropZoneContent({required this.isHovered, required this.onDownloadTemplate});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isHovered ? AppTheme.academic100.withValues(alpha: 0.5) : Colors.grey.shade50,
            shape: BoxShape.circle,
          ),
          child: Icon(
            LucideIcons.sheet,
            size: 40,
            color: isHovered ? AppTheme.academic600 : Colors.grey.shade400,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Importar Planeación desde Excel',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: isHovered ? AppTheme.academic700 : Colors.grey.shade800,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Toca aquí para seleccionar un archivo Excel (.xlsx)',
          style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
        ),
        const SizedBox(height: 16),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onDownloadTemplate,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(LucideIcons.download, size: 14, color: AppTheme.academic600),
                  const SizedBox(width: 6),
                  Text(
                    'Descargar plantilla Excel vacía',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.academic600,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Pintor para bordes redondeados con líneas discontinuas.
class DashedRectPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;
  final double radius;

  DashedRectPainter({
    required this.color,
    this.strokeWidth = 2,
    this.gap = 6,
    this.radius = 24,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Radius.circular(radius),
      ));

    final Path dashPath = Path();
    double distance = 0.0;
    for (final PathMetric measurePath in path.computeMetrics()) {
      while (distance < measurePath.length) {
        dashPath.addPath(measurePath.extractPath(distance, distance + gap), Offset.zero);
        distance += gap + gap;
      }
    }
    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant DashedRectPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.gap != gap ||
        oldDelegate.radius != radius;
  }
}
