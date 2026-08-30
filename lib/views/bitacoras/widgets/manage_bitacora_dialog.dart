import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:open_filex/open_filex.dart';
import 'package:share_plus/share_plus.dart';
import '../../../config/theme/app_theme.dart';
import '../../../database/app_database.dart';
import '../../../database/daos.dart';
import '../../../database/tables.dart';
import '../../../models/bitacora_export_data.dart';
import '../../../providers/bitacora_providers.dart';
import '../../../providers/bitacora_export_provider.dart';
import '../../shared/app_snackbar.dart';
import 'bitacora_resumen_header.dart';
import 'bitacora_session_item.dart';
import 'edit_bitacora_bottom_sheet.dart';
import 'manage_bitacora_footer.dart';

class ManageBitacoraDialog extends ConsumerStatefulWidget {
  final BitacoraWithModule bitacoraWithModule;
  final List<CalendarioBitacora> initialSessions;

  const ManageBitacoraDialog({
    super.key,
    required this.bitacoraWithModule,
    required this.initialSessions,
  });

  @override
  ConsumerState<ManageBitacoraDialog> createState() => _ManageBitacoraDialogState();
}

class _ManageBitacoraDialogState extends ConsumerState<ManageBitacoraDialog> {
  late List<CalendarioBitacora> _sessions;
  late Bitacora _bitacora;
  bool _isUpdating = false;
  bool _isExporting = false;

  @override
  void initState() {
    super.initState();
    _sessions = List.from(widget.initialSessions);
    _bitacora = widget.bitacoraWithModule.bitacora;
  }

  void _toggleSessionCompleted(int index, bool val) async {
    final updated = _sessions[index].copyWith(estadoImpartido: val);
    try {
      await ref.read(bitacoraControllerProvider).updateCalendarioEntry(updated);
      if (mounted) setState(() => _sessions[index] = updated);
    } catch (e) {
      if (mounted) AppSnackbar.showError(context, 'Error al actualizar clase: $e');
    }
  }

  Future<void> _onSessionUpdated(int index, CalendarioBitacora updated) async {
    final previous = _sessions[index];
    // Actualizar estado local optimistamente
    if (mounted) setState(() => _sessions[index] = updated);
    try {
      await ref.read(bitacoraControllerProvider).updateCalendarioEntry(updated);
    } catch (e) {
      // Revertir cambio local si la BD falla
      if (mounted) {
        setState(() => _sessions[index] = previous);
        AppSnackbar.showError(context, 'Error al guardar la sesión: $e');
      }
    }
  }

  void _editBitacora() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) => EditBitacoraBottomSheet(
        bitacora: _bitacora,
        onSave: _handleBitacoraEdit,
      ),
    );
  }

  Future<void> _handleBitacoraEdit(int freq, bool usarReloj) async {
    setState(() => _isUpdating = true);

    try {
      final newSessions = await ref.read(bitacoraControllerProvider)
          .reDosifyBitacora(
        bitacoraId: _bitacora.id,
        frecuenciaClase: freq,
        usarHorasReloj: usarReloj,
        module: widget.bitacoraWithModule.module,
        fechaInicio: _bitacora.fechaInicio,
        diasClase: _bitacora.diasClase.cast<String>(),
        fechasFeriadas: _bitacora.fechasFeriadas.cast<String>(),
      );

      if (!mounted) return;
      AppSnackbar.showSuccess(context, 'Sesiones re-dosificadas con éxito');
      setState(() {
        _bitacora = _bitacora.copyWith(
          frecuenciaClase: freq,
          usarHorasReloj: usarReloj,
        );
        _sessions = newSessions;
      });
    } catch (e) {
      if (mounted) AppSnackbar.showError(context, 'Error al actualizar bitácora: $e');
    } finally {
      if (mounted) setState(() => _isUpdating = false);
    }
  }

  // ─── Exportación ───────────────────────────────────────────────────────────

  /// Construye el DTO de exportación resolviendo nombres de unidades y actividades.
  Future<BitacoraExportData> _buildExportData() async {
    final controller = ref.read(bitacoraControllerProvider);
    final module = widget.bitacoraWithModule.module;

    // Resolver nombres de unidades
    final unitNames = <String, String>{};
    final unitCodes = _sessions
        .map((s) => s.codUnidad)
        .whereType<String>()
        .toSet();
    for (final cod in unitCodes) {
      final units = await controller.getUnitsByModule(module.codModule);
      final match = units.where((u) => u.codUnit == cod).firstOrNull;
      if (match != null) unitNames[cod] = match.nombre;
    }

    // Resolver nombres de actividades
    final activityNames = <String, String>{};
    final actCodes = _sessions
        .map((s) => s.codActividad)
        .whereType<String>()
        .toSet();
    for (final cod in actCodes) {
      // Quitar sufijo '(Cont.)' para buscar el código base
      final baseCode = cod.replaceAll(' (Cont.)', '').trim();
      // Búsqueda amplia: iterar todas las unidades
      bool found = false;
      for (final unitCode in unitCodes) {
        final unitActs = await controller.getActivitiesByUnit(unitCode);
        final match = unitActs.where((a) => a.codActivity == baseCode).firstOrNull;
        if (match != null) {
          activityNames[cod] = match.descripcion;
          found = true;
          break;
        }
      }
      if (!found) activityNames[cod] = cod;
    }

    return BitacoraExportData(
      bitacora: _bitacora,
      module: module,
      sessions: _sessions,
      unitNames: unitNames,
      activityNames: activityNames,
    );
  }

  Future<void> _handleExport({required bool isPdf}) async {
    if (_isExporting) return;
    setState(() => _isExporting = true);

    final formatLabel = isPdf ? 'PDF' : 'Excel';

    // SnackBar de progreso
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              Text('Generando $formatLabel...'),
            ],
          ),
          duration: const Duration(seconds: 30),
          backgroundColor: AppTheme.academic700,
        ),
      );
    }

    try {
      final exportData = await _buildExportData();
      final exportService = ref.read(bitacoraExportServiceProvider);

      final File file = isPdf
          ? await exportService.exportToPdf(exportData)
          : await exportService.exportToExcel(exportData);

      if (!mounted) return;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      // SnackBar de éxito con acción para abrir / compartir
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isPdf ? LucideIcons.fileText : LucideIcons.fileSpreadsheet,
                  color: Colors.white,
                  size: 16,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$formatLabel generado con éxito',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    Text(
                      file.path.split(Platform.pathSeparator).last,
                      style: const TextStyle(fontSize: 11),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          action: SnackBarAction(
            label: 'COMPARTIR',
            textColor: Colors.white,
            onPressed: () => _shareFile(file),
          ),
          duration: const Duration(seconds: 8),
          backgroundColor: const Color(0xFF16A34A),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(12),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      AppSnackbar.showError(context, 'Error al exportar: $e');
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  Future<void> _shareFile(File file) async {
    try {
      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path)],
          subject: 'Bitácora — ${widget.bitacoraWithModule.module.nombre}',
        ),
      );
    } catch (_) {
      // Si share falla, intentar abrir con la app predeterminada
      await OpenFilex.open(file.path);
    }
  }

  // ─── UI ────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final module = widget.bitacoraWithModule.module;
    final completedCount = _sessions.where((s) => s.estadoImpartido).length;
    final totalCount = _sessions.length;
    final progress = totalCount == 0 ? 0.0 : (completedCount / totalCount);

    return Stack(
      children: [
        Scaffold(
          backgroundColor: const Color(0xFFF8FAFC),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(LucideIcons.arrowLeft, color: Colors.black87),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  module.nombre,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    fontFamily: 'Outfit',
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Grupo ${_bitacora.codigoGrupo ?? "N/A"}',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Divider(
                height: 1,
                thickness: 1,
                color: Colors.grey.shade200,
              ),
            ),
          ),
          body: SafeArea(
            child: Column(
              children: [
                // Header de resumen
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  child: BitacoraResumenHeader(
                    progress: progress,
                    completed: completedCount,
                    total: totalCount,
                    frecuenciaClase: _bitacora.frecuenciaClase,
                    fechaInicio: _bitacora.fechaInicio,
                  ),
                ),
                const Divider(
                  height: 1,
                  thickness: 1,
                  color: Color(0xFFE2E8F0),
                ),

                // Lista de sesiones
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: _sessions.isEmpty
                        ? const Center(
                            child: Text(
                              'Sin clases programadas en esta bitácora.',
                            ),
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Dosificación de Clases',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  fontFamily: 'Outfit',
                                ),
                              ),
                              const SizedBox(height: 16),
                              Expanded(
                                child: ListView.separated(
                                  itemCount: _sessions.length,
                                  separatorBuilder: (_, _) =>
                                      const SizedBox(height: 12),
                                  itemBuilder: (context, index) =>
                                      BitacoraSessionItem(
                                        session: _sessions[index],
                                        index: index,
                                        usarHorasReloj:
                                            _bitacora.usarHorasReloj,
                                        onToggleCompleted:
                                            _toggleSessionCompleted,
                                        onSessionUpdated: _onSessionUpdated,
                                      ),
                                ),
                              ),
                            ],
                          ),
                  ),
                ),

                // Footer de acciones (solo si está activa)
                if (_bitacora.estado == EstadoBitacora.activo)
                  ManageBitacoraFooter(
                    onEdit: _editBitacora,
                    onExportExcel: _isExporting
                        ? null
                        : () => _handleExport(isPdf: false),
                    onExportPdf: _isExporting
                        ? null
                        : () => _handleExport(isPdf: true),
                  )
                else
                  // Para bitácoras finalizadas, mostrar solo botón de exportar
                  _FinalizadaExportFooter(
                    isExporting: _isExporting,
                    onExportExcel: () => _handleExport(isPdf: false),
                    onExportPdf: () => _handleExport(isPdf: true),
                  ),
              ],
            ),
          ),
        ),

        // Overlay de progreso (re-dosificación)
        if (_isUpdating)
          const Stack(
            children: [
              ModalBarrier(dismissible: false, color: Colors.black12),
              Center(
                child: CircularProgressIndicator(color: AppTheme.academic600),
              ),
            ],
          ),
      ],
    );
  }
}

/// Footer compacto que muestra solo el botón de exportar para bitácoras finalizadas.
class _FinalizadaExportFooter extends StatelessWidget {
  final bool isExporting;
  final VoidCallback onExportExcel;
  final VoidCallback onExportPdf;

  const _FinalizadaExportFooter({
    required this.isExporting,
    required this.onExportExcel,
    required this.onExportPdf,
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFDCFCE7),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(LucideIcons.checkCircle, size: 14, color: Color(0xFF16A34A)),
                SizedBox(width: 5),
                Text(
                  'Finalizada',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF16A34A),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          PopupMenuButton<String>(
            tooltip: 'Exportar Bitácora',
            onSelected: (value) {
              if (value == 'excel') onExportExcel();
              if (value == 'pdf') onExportPdf();
            },
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            offset: const Offset(0, -100),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'excel',
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0FDF4),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(LucideIcons.fileSpreadsheet,
                          color: Color(0xFF16A34A), size: 18),
                    ),
                    const SizedBox(width: 10),
                    const Text('Exportar Excel', style: TextStyle(fontSize: 13)),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem(
                value: 'pdf',
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF1F2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(LucideIcons.fileText,
                          color: Color(0xFFDC2626), size: 18),
                    ),
                    const SizedBox(width: 10),
                    const Text('Exportar PDF', style: TextStyle(fontSize: 13)),
                  ],
                ),
              ),
            ],
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isExporting)
                    const SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  else
                    const Icon(LucideIcons.download,
                        color: Colors.white, size: 16),
                  const SizedBox(width: 6),
                  const Text(
                    'Exportar',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
