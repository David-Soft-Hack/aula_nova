import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../config/theme/app_theme.dart';

/// Indicador de paso numerado con título y estados visuales (completado, activo, inactivo).
class StepIndicator extends StatelessWidget {
  final int stepNum;
  final String title;
  final int currentStep;

  const StepIndicator({
    super.key,
    required this.stepNum,
    required this.title,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    final active = currentStep >= stepNum;
    final completed = currentStep > stepNum;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: completed
                ? Colors.green
                : active
                    ? AppTheme.academic600
                    : Colors.grey.shade100,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: active || completed
                ? [
                    BoxShadow(
                      color: (completed ? Colors.green : AppTheme.academic600)
                          .withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: completed
                  ? const Icon(LucideIcons.check, color: Colors.white, size: 18)
                  : Text(
                      '$stepNum',
                      style: TextStyle(
                        color: active ? Colors.white : Colors.grey.shade400,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 11,
            fontWeight: active ? FontWeight.bold : FontWeight.w500,
            color: completed
                ? Colors.green.shade700
                : active
                    ? AppTheme.academic600
                    : Colors.grey.shade400,
          ),
        ),
      ],
    );
  }
}

/// Línea conectora animada entre dos StepIndicators.
class StepLineConnector extends StatelessWidget {
  final int afterStep;
  final int currentStep;

  const StepLineConnector({
    super.key,
    required this.afterStep,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    final active = currentStep > afterStep;
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(bottom: 22),
        height: 2,
        child: Stack(
          children: [
            Container(color: Colors.grey.shade100),
            AnimatedFractionallySizedBox(
              duration: const Duration(milliseconds: 300),
              widthFactor: active ? 1.0 : 0.0,
              curve: Curves.easeInOut,
              child: Container(color: AppTheme.academic600),
            ),
          ],
        ),
      ),
    );
  }
}

/// Barra de navegación del stepper con botones Anterior / Siguiente.
class StepperFooter extends StatelessWidget {
  final int step;
  final bool isProcessing;
  final bool canAdvance;
  final VoidCallback? onPrevious;
  final VoidCallback onNext;

  const StepperFooter({
    super.key,
    required this.step,
    required this.isProcessing,
    this.canAdvance = true,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            onPressed: step == 1 ? null : onPrevious,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey.shade50,
              foregroundColor: Colors.grey.shade600,
              disabledBackgroundColor: Colors.grey.shade50.withValues(alpha: 0.5),
              disabledForegroundColor: Colors.grey.shade300,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: const Text('Anterior', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          ElevatedButton(
            onPressed: (isProcessing || !canAdvance) ? null : onNext,
            style: ElevatedButton.styleFrom(
              backgroundColor: step == 3 ? Colors.green : AppTheme.academic600,
              foregroundColor: Colors.white,
              disabledBackgroundColor: Colors.grey.shade100,
              disabledForegroundColor: Colors.grey.shade400,
              elevation: 4,
              shadowColor: (step == 3 ? Colors.green : AppTheme.academic600).withValues(alpha: 0.3),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: isProcessing
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          step == 3 ? 'Finalizar' : 'Siguiente Paso',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 8),
                        Icon(step == 3 ? LucideIcons.checkCircle : LucideIcons.chevronRight, size: 16),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Encabezado del diálogo del stepper con título, subtítulo y botón cerrar.
class StepperDialogHeader extends StatelessWidget {
  final VoidCallback onClose;

  const StepperDialogHeader({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Plan de Módulo Académico',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(
                  'Completa los pasos para generar la estructura didáctica',
                  style: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(LucideIcons.x),
            color: Colors.grey.shade400,
            onPressed: onClose,
          ),
        ],
      ),
    );
  }
}

/// Pantalla animada de éxito al finalizar la creación del módulo.
class ModuleSuccessView extends StatefulWidget {
  const ModuleSuccessView({super.key});

  @override
  State<ModuleSuccessView> createState() => _ModuleSuccessViewState();
}

class _ModuleSuccessViewState extends State<ModuleSuccessView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 850),
    );
    _scaleAnimation = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withValues(alpha: 0.15),
                    blurRadius: 20,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: const Icon(LucideIcons.checkCircle, size: 48, color: Colors.green),
            ),
            const SizedBox(height: 24),
            const Text(
              '¡Módulo Creado!',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, letterSpacing: -0.5),
            ),
            const SizedBox(height: 8),
            Text(
              'La planeación ha sido registrada correctamente.',
              style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
