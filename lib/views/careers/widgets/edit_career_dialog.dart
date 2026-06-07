import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../config/theme/app_theme.dart';
import '../../../database/tables.dart' show TipoCarrera;
import '../../../providers/career_providers.dart';

class EditCareerDialog extends ConsumerStatefulWidget {
  final dynamic career;

  const EditCareerDialog({super.key, required this.career});

  @override
  ConsumerState<EditCareerDialog> createState() => _EditCareerDialogState();
}

class _EditCareerDialogState extends ConsumerState<EditCareerDialog> {
  late TextEditingController _nombreCtrl;
  late TipoCarrera _selectedTipo;

  @override
  void initState() {
    super.initState();
    _nombreCtrl = TextEditingController(text: widget.career.nombre);
    _selectedTipo = widget.career.tipoCarrera;
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final nombre = _nombreCtrl.text.trim();
    if (nombre.isEmpty) return;

    if (nombre.toLowerCase() != widget.career.nombre.toLowerCase()) {
      final exists = await ref.read(careerControllerProvider).existsCareer(nombre);
      if (exists) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(LucideIcons.alertTriangle, color: Colors.white, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'El programa o carrera "$nombre" ya existe.',
                      style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              backgroundColor: Colors.red.shade600,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              margin: const EdgeInsets.all(16),
            ),
          );
        }
        return;
      }
    }

    final updatedCareer = widget.career.copyWith(
      nombre: nombre,
      tipoCarrera: _selectedTipo,
    );

    await ref.read(careerControllerProvider).updateCareer(updatedCareer);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('Editar Carrera/Programa', style: TextStyle(fontWeight: FontWeight.bold)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _nombreCtrl,
            decoration: InputDecoration(
              labelText: 'Nombre',
              hintText: 'Ej: Ingeniería de Sistemas',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Tipo:', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          InputDecorator(
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<TipoCarrera>(
                value: _selectedTipo,
                isExpanded: true,
                items: const [
                  DropdownMenuItem(value: TipoCarrera.curso, child: Text('Curso Libre')),
                  DropdownMenuItem(value: TipoCarrera.tecnica, child: Text('Carrera Técnica / Universitaria')),
                ],
                onChanged: (val) {
                  if (val != null) setState(() => _selectedTipo = val);
                },
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          onPressed: _save,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.academic600,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: const Text('Actualizar'),
        ),
      ],
    );
  }
}
