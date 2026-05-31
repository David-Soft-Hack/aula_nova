import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// Barra de búsqueda con icono de filtros para la pantalla de módulos.
class ModuleSearchBar extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const ModuleSearchBar({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TextField(
              onChanged: onChanged,
              decoration: InputDecoration(
                hintText: 'Buscar módulo o carrera...',
                hintStyle: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 14,
                ),
                prefixIcon: Icon(
                  LucideIcons.search,
                  color: Colors.grey.shade400,
                  size: 18,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade100),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(LucideIcons.sliders),
            color: Colors.grey.shade600,
            onPressed: () {},
          ),
        ),
      ],
    );
  }
}
