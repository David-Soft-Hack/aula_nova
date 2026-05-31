import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../config/theme/app_theme.dart';
import '../../../../database/app_database.dart';
import '../../../../models/database_provider.dart';

class FormModuleDropdown extends StatelessWidget {
  final Module? selectedModule;
  final ValueChanged<Module?> onModuleChanged;

  const FormModuleDropdown({
    super.key,
    required this.selectedModule,
    required this.onModuleChanged,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Module>>(
      stream: DatabaseProvider.moduleDao.watchAllModules(),
      builder: (context, snapshot) {
        final modules = snapshot.data ?? [];
        return DropdownButtonFormField<Module>(
          isExpanded: true,
          initialValue: selectedModule,
          decoration: InputDecoration(
            labelText: 'Módulo Formativo',
            labelStyle: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
            prefixIcon: const Icon(
              LucideIcons.bookOpen,
              size: 18,
              color: AppTheme.academic600,
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: AppTheme.academic600,
                width: 1.5,
              ),
            ),
          ),
          hint: const Text('Seleccionar módulo...'),
          items: modules.map((m) {
            return DropdownMenuItem(
              value: m,
              child: Text(
                m.nombre,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
          onChanged: onModuleChanged,
        );
      },
    );
  }
}
