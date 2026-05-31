import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:drift/drift.dart' hide Column, Table;
import '../../../config/theme/app_theme.dart';
import '../../../models/database_provider.dart';
import '../../../database/app_database.dart';
import '../../../database/tables.dart';
import '../../../database/daos.dart';
import '../../../services/dosificacion_service.dart';
import 'bitacora_resumen_header.dart';
import 'bitacora_session_item.dart';
import 'edit_bitacora_bottom_sheet.dart';
import 'manage_bitacora_footer.dart';

/// Pantalla completa para gestionar las sesiones de una Bitácora.
class ManageBitacoraDialog extends StatefulWidget {
  final BitacoraWithModule bitacoraWithModule;
  final List<CalendarioBitacora> initialSessions;

  const ManageBitacoraDialog({
    super.key,
    required this.bitacoraWithModule,
    required this.initialSessions,
  });

  @override
  State<ManageBitacoraDialog> createState() => _ManageBitacoraDialogState();
}

class _ManageBitacoraDialogState extends State<ManageBitacoraDialog> {
  late List<CalendarioBitacora> _sessions;
  late Bitacora _bitacora;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _sessions = List.from(widget.initialSessions);
    _bitacora = widget.bitacoraWithModule.bitacora;
  }

  void _toggleSessionCompleted(int index, bool val) async {
    final updated = _sessions[index].copyWith(estadoImpartido: val);
    try {
      await DatabaseProvider.bitacoraDao.updateCalendarioEntry(updated);
      if (mounted) setState(() => _sessions[index] = updated);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar clase: $e')),
        );
      }
    }
  }

  Future<void> _onSessionUpdated(int index, CalendarioBitacora updated) async {
    await DatabaseProvider.bitacoraDao.updateCalendarioEntry(updated);
    if (mounted) setState(() => _sessions[index] = updated);
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
    final updated = _bitacora.copyWith(
      frecuenciaClase: freq,
      usarHorasReloj: usarReloj,
    );
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      await DatabaseProvider.bitacoraDao.updateBitacora(updated);

      final module = widget.bitacoraWithModule.module;
      final units = await DatabaseProvider.unitDao.getUnitsByModule(
        module.codModule,
      );
      final unitIds = units.map((u) => u.codUnit).toList();
      final activities = await (DatabaseProvider.db.select(
        DatabaseProvider.db.activities,
      )..where((t) => t.idUnit.isIn(unitIds))).get();

      final reDosified = DosificacionService.dosificar(
        module: module,
        units: units,
        activities: activities,
        fechaInicio: _bitacora.fechaInicio,
        diasClase: (_bitacora.diasClase).cast<String>(),
        horasSesion: freq,
        fechasFeriadas: (_bitacora.fechasFeriadas).cast<String>(),
        usarHorasReloj: usarReloj,
      );

      await DatabaseProvider.bitacoraDao.deleteCalendarioForBitacora(
        _bitacora.id,
      );
      await DatabaseProvider.bitacoraDao.createCalendarioEntries(
        reDosified
            .map((s) => s.copyWith(idBitacora: Value(_bitacora.id)))
            .toList(),
      );

      final newSessions = await DatabaseProvider.bitacoraDao
          .getCalendarioForBitacora(_bitacora.id);

      if (!mounted) return;
      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('Sesiones re-dosificadas con éxito 🎉')),
      );
      setState(() {
        _bitacora = updated;
        _sessions = newSessions;
      });
    } catch (e) {
      if (mounted) {
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text('Error al actualizar bitácora: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isUpdating = false);
    }
  }

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
                  ManageBitacoraFooter(onEdit: _editBitacora),
              ],
            ),
          ),
        ),

        // Overlay de progreso
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
