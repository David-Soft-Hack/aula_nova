import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../config/theme/app_theme.dart';
import '../../../database/tables.dart' show TipoCarrera;

/// Selector optimizado para elegir el tipo de programa formativo
/// utilizando ChoiceChips y encapsulando el estado para evitar rebuilds globales.
class CareerTypeSelector extends StatefulWidget {
  final TipoCarrera initialTipo;
  final ValueChanged<TipoCarrera> onTypeSelected;

  const CareerTypeSelector({
    super.key,
    required this.initialTipo,
    required this.onTypeSelected,
  });

  @override
  State<CareerTypeSelector> createState() => _CareerTypeSelectorState();
}

class _CareerTypeSelectorState extends State<CareerTypeSelector> {
  late TipoCarrera _selectedTipo;

  @override
  void initState() {
    super.initState();
    _selectedTipo = widget.initialTipo;
  }

  void _updateTipo(TipoCarrera tipo) {
    if (_selectedTipo == tipo) return;
    setState(() {
      _selectedTipo = tipo;
    });
    widget.onTypeSelected(tipo);
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ChoiceChip(
          label: const Text('Curso Libre'),
          avatar: Icon(
            LucideIcons.bookmark,
            size: 16,
            color: _selectedTipo == TipoCarrera.curso ? Colors.white : Colors.amber.shade700,
          ),
          selected: _selectedTipo == TipoCarrera.curso,
          selectedColor: AppTheme.academic600,
          backgroundColor: Colors.white,
          showCheckmark: false,
          labelStyle: TextStyle(
            color: _selectedTipo == TipoCarrera.curso ? Colors.white : AppTheme.slate900,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
          side: BorderSide(
            color: _selectedTipo == TipoCarrera.curso ? AppTheme.academic600 : Colors.grey.shade300,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          onSelected: (selected) {
            if (selected) _updateTipo(TipoCarrera.curso);
          },
        ),
        ChoiceChip(
          label: const Text('Carrera Técnica / Univ.'),
          avatar: Icon(
            LucideIcons.graduationCap,
            size: 16,
            color: _selectedTipo == TipoCarrera.tecnica ? Colors.white : AppTheme.academic600,
          ),
          selected: _selectedTipo == TipoCarrera.tecnica,
          selectedColor: AppTheme.academic600,
          backgroundColor: Colors.white,
          showCheckmark: false,
          labelStyle: TextStyle(
            color: _selectedTipo == TipoCarrera.tecnica ? Colors.white : AppTheme.slate900,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
          side: BorderSide(
            color: _selectedTipo == TipoCarrera.tecnica ? AppTheme.academic600 : Colors.grey.shade300,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          onSelected: (selected) {
            if (selected) _updateTipo(TipoCarrera.tecnica);
          },
        ),
      ],
    );
  }
}
