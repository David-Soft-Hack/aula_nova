import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../database/tables.dart';
import '../../models/app_models.dart';
import '../../providers/attendance_providers.dart';
import '../shared/app_snackbar.dart';
import 'widgets/student_attendance_row.dart';
import 'widgets/session_info_header.dart';
import 'widgets/save_attendance_button.dart';

class TakeAttendanceScreen extends ConsumerStatefulWidget {
  final CalendarioBitacora session;
  final String groupCode;
  final String moduleName;
  final int sessionNumber;

  const TakeAttendanceScreen({
    super.key,
    required this.session,
    required this.groupCode,
    required this.moduleName,
    required this.sessionNumber,
  });

  @override
  ConsumerState<TakeAttendanceScreen> createState() => _TakeAttendanceScreenState();
}

class _TakeAttendanceScreenState extends ConsumerState<TakeAttendanceScreen> {
  List<AttendanceRecord>? _records;
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final records = await ref.read(attendanceControllerProvider).getAttendanceListForSession(
      widget.session.id,
      widget.groupCode,
    );
    if (mounted) {
      setState(() {
        _records = records;
        _isLoading = false;
      });
    }
  }

  Future<void> _save() async {
    if (_records == null) return;
    setState(() => _isSaving = true);
    try {
      await ref.read(attendanceControllerProvider).saveAttendances(widget.session.id, _records!);
      if (mounted) {
        AppSnackbar.showSuccess(context, 'Asistencia guardada correctamente.');
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        AppSnackbar.showError(context, 'Error al guardar', description: e.toString());
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _markAllAs(EstadoAsistencia status) {
    if (_records == null) return;
    setState(() {
      for (var r in _records!) {
        r.currentStatus = status;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Sesión ${widget.sessionNumber} - Grupo ${widget.groupCode}'),
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        actions: [
          PopupMenuButton<EstadoAsistencia>(
            icon: const Icon(LucideIcons.checkSquare),
            tooltip: 'Marcar a todos',
            onSelected: _markAllAs,
            itemBuilder: (context) => const [
              PopupMenuItem(value: EstadoAsistencia.presente, child: Text('Marcar todos Presentes')),
              PopupMenuItem(value: EstadoAsistencia.ausente, child: Text('Marcar todos Ausentes')),
            ],
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                SessionInfoHeader(moduleName: widget.moduleName, session: widget.session),
                Expanded(
                  child: _records == null || _records!.isEmpty
                      ? const Center(child: Text('No hay estudiantes activos en este grupo.'))
                      : ListView.separated(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          itemCount: _records!.length,
                          separatorBuilder: (_, _) => const Divider(height: 1),
                          itemBuilder: (context, index) {
                            return StudentAttendanceRow(
                              record: _records![index],
                              onStatusChanged: (status) {
                                setState(() {
                                  _records![index].currentStatus = status;
                                });
                              },
                            );
                          },
                        ),
                ),
              ],
            ),
      bottomNavigationBar: SaveAttendanceButton(
        isLoading: _isSaving,
        onPressed: _save,
      ),
    );
  }
}

