import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../config/theme/app_theme.dart';
import '../../../database/tables.dart' show TipoCarrera;
import '../../../models/database_provider.dart';
import '../career_detail_screen.dart';

/// Diálogo de confirmación para eliminar una carrera.
Future<bool?> showDeleteCareerDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (c) => AlertDialog(
      title: const Text('Eliminar'),
      content: const Text('¿Estás seguro de eliminar este programa?'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Cancelar')),
        TextButton(
          onPressed: () => Navigator.pop(c, true),
          child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );
}

/// Tarjeta de visualización de una carrera o programa formativo.
class CareerCard extends StatelessWidget {
  final dynamic career; // Career model
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CareerCard({
    super.key, 
    required this.career, 
    required this.onEdit, 
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isTecnica = career.tipoCarrera == TipoCarrera.tecnica;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CareerDetailScreen(career: career),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.academic50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  isTecnica ? LucideIcons.book : LucideIcons.bookmark,
                  color: AppTheme.academic600,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      career.nombre,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        Text(
                          isTecnica ? 'Carrera Técnica / Univ.' : 'Curso Libre',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 11.5,
                          ),
                        ),
                        Container(
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade400,
                            shape: BoxShape.circle,
                          ),
                        ),
                        FutureBuilder<int>(
                          future: DatabaseProvider.moduleDao.countModulesByCareer(career.nombre),
                          builder: (context, snapshot) {
                            final count = snapshot.data ?? 0;
                            return Text(
                              '$count ${count == 1 ? 'módulo' : 'módulos'}',
                              style: const TextStyle(
                                color: AppTheme.academic600,
                                fontWeight: FontWeight.bold,
                                fontSize: 11.5,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(LucideIcons.edit3, color: Colors.blue.shade600, size: 18),
                    visualDensity: VisualDensity.compact,
                    padding: const EdgeInsets.all(6),
                    constraints: const BoxConstraints(),
                    tooltip: 'Editar',
                    onPressed: onEdit,
                  ),
                  const SizedBox(width: 6),
                  IconButton(
                    icon: const Icon(LucideIcons.trash2, color: Colors.red, size: 18),
                    visualDensity: VisualDensity.compact,
                    padding: const EdgeInsets.all(6),
                    constraints: const BoxConstraints(),
                    tooltip: 'Eliminar',
                    onPressed: onDelete,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
