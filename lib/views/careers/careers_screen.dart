import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../config/theme/app_theme.dart';
import '../../database/app_database.dart';
import '../../providers/career_providers.dart';
import '../shared/app_snackbar.dart';
import 'widgets/add_career_dialog.dart';
import 'widgets/edit_career_dialog.dart';
import 'widgets/career_card.dart';

/// Pantalla de gestión de carreras y programas formativos.
///
/// Refactorizada a [ConsumerWidget] para mejorar la eficiencia al eliminar el
/// ciclo de vida innecesario de un [StatefulWidget], y delegando las secciones
/// a widgets independientes para optimizar las reconstrucciones de la UI.
class CareersScreen extends ConsumerWidget {
  const CareersScreen({super.key});

  void _showAddCareerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const AddCareerDialog(),
    );
  }

  void _showEditCareerDialog(BuildContext context, Career career) {
    showDialog(
      context: context,
      builder: (context) => EditCareerDialog(career: career),
    );
  }

  Future<void> _onDelete(BuildContext context, WidgetRef ref, Career career) async {
    final confirmed = await showDeleteCareerDialog(context);
    if (confirmed == true && context.mounted) {
      try {
        await ref.read(careerControllerProvider).deleteCareer(career);
        if (context.mounted) {
          AppSnackbar.showSuccess(context, 'Programa eliminado con éxito');
        }
      } catch (e) {
        if (context.mounted) {
          AppSnackbar.showError(context, 'Error al eliminar programa: $e');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Column(
        children: [
          const _CareersHeader(),
          _AddCareerButton(onPressed: () => _showAddCareerDialog(context)),
          const SizedBox(height: 16),
          Expanded(
            child: _CareerList(
              onEdit: (career) => _showEditCareerDialog(context, career),
              onDelete: (career) => _onDelete(context, ref, career),
            ),
          ),
        ],
      ),
    );
  }
}

class _CareersHeader extends StatelessWidget {
  const _CareersHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Carreras y Programas',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    fontFamily: 'Outfit',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Gestiona los programas que impartes',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AddCareerButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _AddCareerButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: onPressed,
          icon: const Icon(LucideIcons.plus, size: 20),
          label: const Text('Agregar Programa'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.academic600,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 4,
          ),
        ),
      ),
    );
  }
}

class _CareerList extends ConsumerWidget {
  final void Function(Career) onEdit;
  final void Function(Career) onDelete;

  const _CareerList({
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final careersAsync = ref.watch(allCareersStreamProvider);

    return careersAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (careers) {
        if (careers.isEmpty) {
          return const _CareersEmptyState();
        }
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          itemCount: careers.length,
          itemBuilder: (context, index) {
            final career = careers[index];
            return CareerCard(
              career: career,
              onEdit: () => onEdit(career),
              onDelete: () => onDelete(career),
            );
          },
        );
      },
    );
  }
}

class _CareersEmptyState extends StatelessWidget {
  const _CareersEmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(LucideIcons.graduationCap, size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          const Text('No hay programas registrados', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}

