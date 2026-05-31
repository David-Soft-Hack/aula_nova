import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../config/theme/app_theme.dart';

class SessionDocumentSection extends StatelessWidget {
  final String? nombreDocumento;
  final VoidCallback onPickDocument;
  final VoidCallback onOpenDocument;
  final VoidCallback onRemoveDocument;

  const SessionDocumentSection({
    super.key,
    required this.nombreDocumento,
    required this.onPickDocument,
    required this.onOpenDocument,
    required this.onRemoveDocument,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(LucideIcons.fileText,
                size: 16, color: const Color(0xFFEA580C)),
            const SizedBox(width: 6),
            const Text(
              'Instrumento de Evaluación',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Document attached
        if (nombreDocumento != null) ...[
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.academic50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.academic100),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.academic600.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    nombreDocumento!.endsWith('.pdf')
                        ? LucideIcons.fileText
                        : LucideIcons.fileSpreadsheet,
                    size: 18,
                    color: AppTheme.academic600,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nombreDocumento!,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'Documento adjunto',
                        style: TextStyle(
                            fontSize: 11, color: Colors.grey.shade500),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Open button
                IconButton(
                  onPressed: onOpenDocument,
                  icon: const Icon(LucideIcons.externalLink, size: 18),
                  color: AppTheme.academic600,
                  tooltip: 'Abrir documento',
                  style: IconButton.styleFrom(
                    backgroundColor:
                        AppTheme.academic600.withValues(alpha: 0.08),
                  ),
                ),
                // Remove button
                IconButton(
                  onPressed: onRemoveDocument,
                  icon: const Icon(LucideIcons.x, size: 16),
                  color: Colors.grey.shade500,
                  tooltip: 'Eliminar documento',
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],

        // Pick document button
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: onPickDocument,
            icon: Icon(
              nombreDocumento != null
                  ? LucideIcons.refreshCw
                  : LucideIcons.uploadCloud,
              size: 16,
            ),
            label: Text(
              nombreDocumento != null
                  ? 'Cambiar Documento'
                  : 'Adjuntar PDF o Word',
            ),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              side: BorderSide(color: Colors.grey.shade300),
              foregroundColor: Colors.grey.shade700,
            ),
          ),
        ),
      ],
    );
  }
}
