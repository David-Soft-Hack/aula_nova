import 'package:aula_nova/database/daos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import '../../config/theme/app_theme.dart';
import '../../database/app_database.dart';
import '../../providers/bitacora_providers.dart';
import '../shared/app_snackbar.dart';
import 'take_attendance_screen.dart';

class AttendanceScreen extends ConsumerStatefulWidget {
  const AttendanceScreen({super.key});

  @override
  ConsumerState<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends ConsumerState<AttendanceScreen> {
  BitacoraWithModule? _selectedBitacora;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 16),
          _buildBitacoraSelector(),
          const SizedBox(height: 8),
          const Divider(height: 1),
          Expanded(child: _buildSessionsList()),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Control de Asistencia',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w900,
              fontFamily: 'Outfit',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Selecciona una bitácora y la sesión para pasar lista',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  Widget _buildBitacoraSelector() {
    final bitacorasAsync = ref.watch(bitacorasWithModuleStreamProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: bitacorasAsync.when(
        loading: () => const CircularProgressIndicator(),
        error: (e, _) => Text('Error al cargar bitácoras: $e'),
        data: (bitacoras) {
          if (bitacoras.isEmpty) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                'No tienes bitácoras registradas. Crea una bitácora primero.',
                style: TextStyle(color: Colors.grey),
              ),
            );
          }

          if (_selectedBitacora == null) {
            // Seleccionar por defecto la primera activa
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) setState(() => _selectedBitacora = bitacoras.first);
            });
          }

          return DropdownButtonFormField<BitacoraWithModule>(
            isExpanded: true,
            initialValue: _selectedBitacora,
            icon: const Icon(LucideIcons.chevronDown, size: 20),
            decoration: InputDecoration(
              prefixIcon: Icon(
                LucideIcons.bookOpen,
                color: Colors.grey.shade400,
                size: 20,
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            items: bitacoras.map((b) {
              return DropdownMenuItem(
                value: b,
                child: Text(
                  'Grupo ${b.bitacora.codigoGrupo ?? 'Sin grupo'} - ${b.module.nombre}',
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
            onChanged: (v) {
              if (v != null) setState(() => _selectedBitacora = v);
            },
          );
        },
      ),
    );
  }

  Widget _buildSessionsList() {
    if (_selectedBitacora == null) {
      return const Center(child: Text('Selecciona una bitácora'));
    }

    final sessionsAsync = ref.watch(
      calendarioStreamProvider(_selectedBitacora!.bitacora.id),
    );

    return sessionsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (sessions) {
        if (sessions.isEmpty) {
          return const Center(
            child: Text('La bitácora no tiene sesiones calendarizadas.'),
          );
        }

        // Ordenar por fecha programada (las más recientes arriba o las pasadas)
        // Por simplicidad, se muestran tal como están en la BD o las ordenamos cronológicamente.
        final sorted = List<CalendarioBitacora>.from(sessions)
          ..sort(
            (a, b) => (a.fechaProgramada ?? DateTime.now()).compareTo(
              b.fechaProgramada ?? DateTime.now(),
            ),
          );

        return ListView.builder(
          padding: const EdgeInsets.all(24),
          itemCount: sorted.length,
          itemBuilder: (context, index) {
            final session = sorted[index];
            return _SessionCard(
              session: session,
              bitacora: _selectedBitacora!,
              sessionNumber: index + 1,
            );
          },
        );
      },
    );
  }
}

class _SessionCard extends ConsumerWidget {
  final CalendarioBitacora session;
  final BitacoraWithModule bitacora;
  final int sessionNumber;

  const _SessionCard({
    required this.session,
    required this.bitacora,
    required this.sessionNumber,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateStr = session.fechaProgramada != null
        ? DateFormat('EEEE, dd MMM yyyy', 'es').format(session.fechaProgramada!)
        : 'Fecha no definida';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: InkWell(
        onTap: () {
          if (bitacora.bitacora.codigoGrupo == null) {
            AppSnackbar.showWarning(context, 'Esta bitácora no tiene un grupo asignado.');
            return;
          }
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => TakeAttendanceScreen(
                session: session,
                groupCode: bitacora.bitacora.codigoGrupo!,
                moduleName: bitacora.module.nombre,
                sessionNumber: sessionNumber,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppTheme.academic50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    'S$sessionNumber',
                    style: const TextStyle(
                      color: AppTheme.academic600,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Actividad: ${session.codActividad ?? 'Sin Actividad'}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          LucideIcons.calendar,
                          size: 14,
                          color: Colors.grey.shade500,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          dateStr,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(LucideIcons.chevronRight, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
