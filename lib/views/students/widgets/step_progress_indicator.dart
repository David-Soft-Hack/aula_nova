import 'package:flutter/material.dart';
import '../../../config/theme/app_theme.dart';

class StepProgressIndicator extends StatelessWidget {
  final int totalSteps;
  final int currentStep;
  final List<String> stepLabels;
  final bool isKeyboardVisible;

  const StepProgressIndicator({
    super.key,
    required this.totalSteps,
    required this.currentStep,
    required this.stepLabels,
    required this.isKeyboardVisible,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(totalSteps, (index) {
        final isActive = index <= currentStep;
        return Expanded(
          child: Column(
            children: [
              Row(
                children: [
                  if (index > 0)
                    Expanded(
                      child: Container(
                        height: 2,
                        color: isActive
                            ? AppTheme.academic600
                            : Colors.grey.shade200,
                      ),
                    ),
                  Container(
                    width: isKeyboardVisible ? 28 : 40,
                    height: isKeyboardVisible ? 28 : 40,
                    decoration: BoxDecoration(
                      color: isActive
                          ? AppTheme.academic600
                          : Colors.grey.shade100,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isActive
                            ? AppTheme.academic600
                            : Colors.grey.shade300,
                        width: 1.5,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          color:
                              isActive ? Colors.white : Colors.grey.shade600,
                          fontWeight: FontWeight.bold,
                          fontSize: isKeyboardVisible ? 11 : 14,
                        ),
                      ),
                    ),
                  ),
                  if (index < totalSteps - 1)
                    Expanded(
                      child: Container(
                        height: 2,
                        color: currentStep > index
                            ? AppTheme.academic600
                            : Colors.grey.shade200,
                      ),
                    ),
                ],
              ),
              if (!isKeyboardVisible && index < stepLabels.length) ...[
                const SizedBox(height: 8),
                Text(
                  stepLabels[index],
                  style: TextStyle(
                    color: index <= currentStep
                        ? AppTheme.slate900
                        : Colors.grey.shade500,
                    fontWeight: index <= currentStep
                        ? FontWeight.w600
                        : FontWeight.w400,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        );
      }),
    );
  }
}
