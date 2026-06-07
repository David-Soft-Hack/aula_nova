import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../database/app_database.dart';
import '../../../database/tables.dart';

class GroupCard extends StatelessWidget {
  final ClassGroup group;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const GroupCard({
    super.key,
    required this.group,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: InkWell(
        onTap: onEdit,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _StatusChip(estado: group.estado),
                  PopupMenuButton<String>(
                    icon: Icon(LucideIcons.moreVertical, color: Colors.grey.shade400, size: 20),
                    onSelected: (value) {
                      if (value == 'edit') onEdit();
                      if (value == 'delete') onDelete();
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(LucideIcons.edit2, size: 18),
                            SizedBox(width: 8),
                            Text('Editar'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(LucideIcons.trash2, color: Colors.red, size: 18),
                            SizedBox(width: 8),
                            Text('Eliminar', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                group.codigo,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Outfit',
                ),
              ),
              const SizedBox(height: 8),
              if (group.carrera.isNotEmpty) ...[
                Row(
                  children: [
                    Icon(LucideIcons.graduationCap, size: 16, color: Colors.grey.shade500),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        group.carrera,
                        style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
              ],
              Row(
                children: [
                  if (group.turno != null && group.turno!.isNotEmpty) ...[
                    Icon(LucideIcons.clock, size: 16, color: Colors.grey.shade500),
                    const SizedBox(width: 4),
                    Text(
                      group.turno!,
                      style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                    ),
                    const SizedBox(width: 16),
                  ],
                  if (group.ciclo != null && group.ciclo!.isNotEmpty) ...[
                    Icon(LucideIcons.calendarDays, size: 16, color: Colors.grey.shade500),
                    const SizedBox(width: 4),
                    Text(
                      group.ciclo!,
                      style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final EstadoGrupo estado;

  const _StatusChip({required this.estado});

  @override
  Widget build(BuildContext context) {
    Color color;
    String text;

    switch (estado) {
      case EstadoGrupo.activo:
        color = Colors.green;
        text = 'Activo';
        break;
      case EstadoGrupo.finalizado:
        color = Colors.grey;
        text = 'Finalizado';
        break;
      case EstadoGrupo.suspendido:
        color = Colors.orange;
        text = 'Suspendido';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color.withValues(alpha: 0.9),
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
