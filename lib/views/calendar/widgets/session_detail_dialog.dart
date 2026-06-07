import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../config/theme/app_theme.dart';
import '../../../database/daos.dart';
import '../../../providers/bitacora_providers.dart';
import '../../attendance/take_attendance_screen.dart';
import '../../shared/app_chip.dart';
import '../../shared/app_snackbar.dart';
import '../../shared/detail_item.dart';

class SessionDetailDialog extends ConsumerStatefulWidget {
  final TodaySessionData sessionData;

  const SessionDetailDialog({super.key, required this.sessionData});

  @override
  ConsumerState<SessionDetailDialog> createState() =>
      _SessionDetailDialogState();
}

class _SessionDetailDialogState extends ConsumerState<SessionDetailDialog> {
  bool _isLoading = false;

  Future<void> _toggleImpartido() async {
    setState(() => _isLoading = true);
    try {
      final updated = widget.sessionData.entry.copyWith(
        estadoImpartido: !widget.sessionData.entry.estadoImpartido,
      );
      await ref.read(bitacoraControllerProvider).updateCalendarioEntry(updated);
      if (mounted) {
        AppSnackbar.showSuccess(
          context,
          widget.sessionData.entry.estadoImpartido
              ? 'Sesión marcada como PENDIENTE'
              : 'Sesión marcada como IMPARTIDA',
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        AppSnackbar.showError(context, 'Error al actualizar la sesión: $e');
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _goTakeAttendance() async {
    final group = widget.sessionData.groupCode;
    if (group == null || group.isEmpty) {
      AppSnackbar.showWarning(
        context,
        'Esta sesión no pertenece a ningún grupo registrado.',
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final bitacoraId = widget.sessionData.entry.idBitacora;
      final controller = ref.read(bitacoraControllerProvider);
      final allSessions = await controller.getCalendario(bitacoraId);

      // Sort sessions chronologically to determine session number
      allSessions.sort(
        (a, b) => (a.fechaProgramada ?? DateTime.now()).compareTo(
          b.fechaProgramada ?? DateTime.now(),
        ),
      );

      final index = allSessions.indexWhere(
        (s) => s.id == widget.sessionData.entry.id,
      );
      final sessionNum = index != -1 ? index + 1 : 1;

      if (!mounted) return;

      Navigator.pop(context); // Close dialog

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => TakeAttendanceScreen(
            session: widget.sessionData.entry,
            groupCode: group,
            moduleName: widget.sessionData.moduleName,
            sessionNumber: sessionNum,
          ),
        ),
      );
    } catch (e) {
      if (mounted) {
        AppSnackbar.showError(
          context,
          'Error al iniciar control de asistencia: $e',
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final session = widget.sessionData.entry;
    final dateStr = session.fechaProgramada != null
        ? DateFormat(
            "EEEE d 'de' MMMM, yyyy",
            'es',
          ).format(session.fechaProgramada!)
        : 'Sin fecha';
    final hasGroup =
        widget.sessionData.groupCode != null &&
        widget.sessionData.groupCode!.isNotEmpty;

    final unitAsync = ref.watch(unitByCodProvider(session.codUnidad ?? ''));
    final activityAsync = ref.watch(
      activityByCodProvider(session.codActividad ?? ''),
    );

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      elevation: 24,
      backgroundColor: Colors.white,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      session.esEvaluativa
                          ? 'Evaluación Formativa'
                          : 'Sesión de Aprendizaje',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: session.esEvaluativa
                            ? Colors.deepOrange
                            : AppTheme.academic600,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: session.estadoImpartido
                          ? Colors.green.shade50
                          : Colors.amber.shade50,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: session.estadoImpartido
                            ? Colors.green.shade200
                            : Colors.amber.shade200,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          session.estadoImpartido
                              ? LucideIcons.checkCircle2
                              : LucideIcons.helpCircle,
                          size: 14,
                          color: session.estadoImpartido
                              ? Colors.green.shade700
                              : Colors.amber.shade700,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          session.estadoImpartido ? 'Impartido' : 'Pendiente',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: session.estadoImpartido
                                ? Colors.green.shade700
                                : Colors.amber.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Module Title
              Text(
                widget.sessionData.moduleName,
                style: const TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),

              // Career & Shift/Group Information
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  AppChip(
                    icon: LucideIcons.graduationCap,
                    text: widget.sessionData.career.toUpperCase(),
                    color: Colors.grey.shade700,
                    backgroundColor: Colors.grey.shade100,
                  ),
                  if (hasGroup)
                    AppChip(
                      icon: LucideIcons.users,
                      text: 'GRUPO ${widget.sessionData.groupCode}',
                      color: Colors.grey.shade700,
                      backgroundColor: Colors.grey.shade100,
                    ),
                  if (widget.sessionData.turno != null)
                    AppChip(
                      icon: LucideIcons.sun,
                      text: widget.sessionData.turno!.toUpperCase(),
                      color: Colors.grey.shade700,
                      backgroundColor: Colors.grey.shade100,
                    ),
                ],
              ),
              const Divider(height: 32),

              // Activity Detail Section
              const Text(
                'DETALLES DE LA SESIÓN',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 16),

              DetailItem(
                icon: LucideIcons.bookOpen,
                label: 'Unidad Didáctica',
                value: unitAsync.when(
                  data: (u) => u?.nombre ?? 'No especificada',
                  loading: () => 'Cargando...',
                  error: (_, _) => 'No especificada',
                ),
              ),
              const SizedBox(height: 12),
              DetailItem(
                icon: LucideIcons.fileText,
                label: 'Actividad Programada',
                value: activityAsync.when(
                  data: (a) => a?.descripcion ?? 'No especificada',
                  loading: () => 'Cargando...',
                  error: (_, _) => 'No especificada',
                ),
              ),
              const SizedBox(height: 12),
              DetailItem(
                icon: LucideIcons.clock,
                label: 'Horas Planificadas',
                value: '${session.horaImpartir ?? 0} horas',
              ),
              const SizedBox(height: 12),
              DetailItem(
                icon: LucideIcons.calendarDays,
                label: 'Fecha Programada',
                value: dateStr,
              ),

              if (session.esEvaluativa) ...[
                const SizedBox(height: 12),
                DetailItem(
                  icon: LucideIcons.award,
                  label: 'Puntaje de Evaluación',
                  value: '${session.puntaje ?? 0.0} pts',
                ),
              ],

              const SizedBox(height: 32),

              // Actions
              if (_isLoading)
                const Center(
                  child: CircularProgressIndicator(color: AppTheme.academic600),
                )
              else
                Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _toggleImpartido,
                        icon: Icon(
                          session.estadoImpartido
                              ? LucideIcons.xCircle
                              : LucideIcons.checkCircle,
                          size: 18,
                        ),
                        label: Text(
                          session.estadoImpartido
                              ? 'Marcar como Pendiente'
                              : 'Marcar como Impartida',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Outfit',
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: session.estadoImpartido
                              ? Colors.amber.shade900
                              : Colors.white,
                          backgroundColor: session.estadoImpartido
                              ? Colors.amber.shade50
                              : AppTheme.academic600,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(
                              color: session.estadoImpartido
                                  ? Colors.amber.shade200
                                  : Colors.transparent,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (hasGroup)
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: _goTakeAttendance,
                          icon: const Icon(LucideIcons.checkSquare, size: 18),
                          label: const Text(
                            'Control de Asistencia',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Outfit',
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppTheme.academic700,
                            side: const BorderSide(color: AppTheme.academic200),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          'Cerrar',
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Outfit',
                          ),
                        ),
                      ),
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
