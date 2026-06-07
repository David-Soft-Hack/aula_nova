import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../config/theme/app_theme.dart';
import '../../database/app_database.dart';
import '../../database/daos.dart';
import '../../providers/bitacora_providers.dart';
import '../../providers/student_providers.dart';
import 'widgets/attendance_session_card.dart';

class BitacoraAttendanceView extends ConsumerStatefulWidget {
  final BitacoraWithModule bitacoraWithModule;

  const BitacoraAttendanceView({
    super.key,
    required this.bitacoraWithModule,
  });

  @override
  ConsumerState<BitacoraAttendanceView> createState() => _BitacoraAttendanceViewState();
}

class _BitacoraAttendanceViewState extends ConsumerState<BitacoraAttendanceView> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detalle de Asistencia',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            fontFamily: 'Outfit',
            color: AppTheme.slate900,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: AppTheme.slate900,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft),
          onPressed: () => Navigator.of(context).pop(),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.academic600,
          unselectedLabelColor: Colors.grey.shade500,
          indicatorColor: AppTheme.academic600,
          indicatorWeight: 3,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, fontFamily: 'Outfit'),
          tabs: const [
            Tab(text: 'Sesiones'),
            Tab(text: 'Estudiantes'),
          ],
        ),
      ),
      body: Column(
        children: [
          _buildInfoBanner(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildSessionsTab(),
                _buildStudentsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBanner() {
    final bitacora = widget.bitacoraWithModule.bitacora;
    final module = widget.bitacoraWithModule.module;

    return Container(
      width: double.infinity,
      color: AppTheme.academic50,
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            module.nombre,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.slate900,
              fontFamily: 'Outfit',
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              _buildInfoChip(LucideIcons.users, 'Grupo: ${bitacora.codigoGrupo ?? 'N/A'}'),
              if (bitacora.turno != null && bitacora.turno!.isNotEmpty)
                _buildInfoChip(LucideIcons.sun, 'Turno: ${bitacora.turno}'),
              _buildInfoChip(LucideIcons.graduationCap, bitacora.carrera),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppTheme.academic500),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionsTab() {
    final sessionsAsync = ref.watch(calendarioStreamProvider(widget.bitacoraWithModule.bitacora.id));

    return sessionsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (sessions) {
        if (sessions.isEmpty) {
          return const Center(child: Text('Sin sesiones programadas.'));
        }

        final sorted = List<CalendarioBitacora>.from(sessions)
          ..sort((a, b) => (a.fechaProgramada ?? DateTime.now()).compareTo(b.fechaProgramada ?? DateTime.now()));

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: sorted.length,
          itemBuilder: (context, index) {
            final session = sorted[index];
            return AttendanceSessionCard(
              session: session,
              bitacora: widget.bitacoraWithModule,
              sessionNumber: index + 1,
            );
          },
        );
      },
    );
  }

  Widget _buildStudentsTab() {
    final groupCode = widget.bitacoraWithModule.bitacora.codigoGrupo;
    if (groupCode == null || groupCode.isEmpty) {
      return const Center(child: Text('Esta bitácora no tiene un grupo asignado.'));
    }

    final studentsAsync = ref.watch(studentsByGroupProvider(groupCode));

    return studentsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (students) {
        if (students.isEmpty) {
          return const Center(child: Text('No hay estudiantes activos en este grupo.'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: students.length,
          itemBuilder: (context, index) {
            final student = students[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppTheme.academic100,
                  child: Text(
                    student.nombres[0].toUpperCase(),
                    style: const TextStyle(
                      color: AppTheme.academic800,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(
                  '${student.apellidos}, ${student.nombres}',
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
                subtitle: Text(
                  student.codigo,
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                ),
                trailing: const Icon(LucideIcons.chevronRight, color: Colors.grey, size: 16),
                onTap: () => _showStudentDetails(student),
              ),
            );
          },
        );
      },
    );
  }

  void _showStudentDetails(dynamic student) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Detalles de Estudiante',
          style: const TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailField('Nombre', '${student.nombres} ${student.apellidos}'),
            _buildDetailField('Código', student.codigo),
            _buildDetailField('Email', student.email ?? 'No registrado'),
            _buildDetailField('Teléfono', student.telefono ?? 'No registrado'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
