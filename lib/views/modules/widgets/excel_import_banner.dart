import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// Banner premium que muestra el resumen del Excel importado con stats y botón de descarte.
class ExcelImportBanner extends StatelessWidget {
  final String? importedExcelName;
  final int unitsCount;
  final int activitiesCount;
  final String totalHR;
  final String totalHA;
  final VoidCallback onDiscard;

  const ExcelImportBanner({
    super.key,
    required this.importedExcelName,
    required this.unitsCount,
    required this.activitiesCount,
    required this.totalHR,
    required this.totalHA,
    required this.onDiscard,
  });

  @override
  Widget build(BuildContext context) {
    if (importedExcelName == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.shade50, Colors.teal.shade50],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                LucideIcons.fileSpreadsheet,
                color: Colors.green.shade700,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '¡Excel Importado con Éxito!',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade900,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      importedExcelName!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.green.shade700,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  LucideIcons.trash2,
                  color: Colors.red.shade700,
                  size: 20,
                ),
                tooltip: 'Descartar datos de Excel',
                onPressed: onDiscard,
              ),
            ],
          ),
          const Divider(height: 20, thickness: 1, color: Color(0x334CAF50)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _BannerStat(
                icon: LucideIcons.bookOpen,
                value: '$unitsCount',
                label: 'Unidades',
                color: Colors.blue.shade700,
              ),
              _BannerStat(
                icon: LucideIcons.checkSquare,
                value: '$activitiesCount',
                label: 'Actividades',
                color: Colors.purple.shade700,
              ),
              _BannerStat(
                icon: LucideIcons.clock,
                value: '${totalHR}h / ${totalHA}h',
                label: 'H. Reloj / Académicas',
                color: Colors.amber.shade700,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BannerStat extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _BannerStat({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 14),
            const SizedBox(width: 4),
            Text(
              value,
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade900,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
