import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// Footer de la pantalla de gestión de bitácora.
/// Incluye el botón "Editar Bitácora" y el menú de exportación (Excel / PDF).
class ManageBitacoraFooter extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback? onExportExcel;
  final VoidCallback? onExportPdf;

  const ManageBitacoraFooter({
    super.key,
    required this.onEdit,
    this.onExportExcel,
    this.onExportPdf,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x06000000),
            blurRadius: 10,
            offset: Offset(0, -4),
          ),
        ],
        border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: Row(
        children: [
          // Botón principal: Editar
          Expanded(
            child: OutlinedButton.icon(
              onPressed: onEdit,
              icon: const Icon(LucideIcons.edit, size: 16),
              label: const Text('Editar Bitácora'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                side: const BorderSide(color: Color(0xFFCBD5E1)),
                foregroundColor: const Color(0xFF475569),
              ),
            ),
          ),

          const SizedBox(width: 10),

          // Botón de exportar con menú desplegable
          _ExportMenuButton(
            onExportExcel: onExportExcel,
            onExportPdf: onExportPdf,
          ),
        ],
      ),
    );
  }
}

/// Botón circular con ícono de descarga que abre un PopupMenu
/// con las opciones Excel y PDF.
class _ExportMenuButton extends StatelessWidget {
  final VoidCallback? onExportExcel;
  final VoidCallback? onExportPdf;

  const _ExportMenuButton({
    this.onExportExcel,
    this.onExportPdf,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      tooltip: 'Exportar Bitácora',
      onSelected: (value) {
        if (value == 'excel') onExportExcel?.call();
        if (value == 'pdf') onExportPdf?.call();
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      offset: const Offset(0, -130),
      itemBuilder: (context) => [
        _buildMenuItem(
          value: 'excel',
          icon: LucideIcons.fileSpreadsheet,
          iconColor: const Color(0xFF16A34A),
          bgColor: const Color(0xFFF0FDF4),
          label: 'Exportar como Excel',
          subtitle: 'Descarga el archivo .xlsx',
        ),
        const PopupMenuDivider(height: 1),
        _buildMenuItem(
          value: 'pdf',
          icon: LucideIcons.fileText,
          iconColor: const Color(0xFFDC2626),
          bgColor: const Color(0xFFFFF1F2),
          label: 'Exportar como PDF',
          subtitle: 'Descarga el archivo .pdf',
        ),
      ],
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2563EB).withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Icon(LucideIcons.download, color: Colors.white, size: 20),
      ),
    );
  }

  PopupMenuItem<String> _buildMenuItem({
    required String value,
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required String label,
    required String subtitle,
  }) {
    return PopupMenuItem<String>(
      value: value,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  fontFamily: 'Outfit',
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
