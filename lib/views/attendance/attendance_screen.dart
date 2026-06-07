import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../database/app_database.dart';
import '../../database/daos.dart';
import '../../providers/bitacora_providers.dart';
import '../shared/app_input_decoration.dart';
import 'widgets/session_card.dart';

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
            decoration: AppInputDecoration.build(
              hintText: 'Seleccionar bitácora',
              prefixIcon: LucideIcons.bookOpen,
              borderColor: Colors.grey.shade300,
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

  List<CalendarioBitacora> _sortSessions(List<CalendarioBitacora> sessions) {
    return List<CalendarioBitacora>.from(sessions)
      ..sort(
        (a, b) => (a.fechaProgramada ?? DateTime.now()).compareTo(
          b.fechaProgramada ?? DateTime.now(),
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

        final sorted = _sortSessions(sessions);

        return ListView.builder(
          padding: const EdgeInsets.all(24),
          itemCount: sorted.length,
          itemBuilder: (context, index) {
            final session = sorted[index];
            return SessionCard(
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

