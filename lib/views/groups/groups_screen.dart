import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../config/theme/app_theme.dart';
import '../../../database/app_database.dart';
import '../../../providers/career_providers.dart';
import '../../../providers/class_group_providers.dart';
import '../shared/requirement_dialog.dart';
import 'widgets/add_group_dialog.dart';
import 'widgets/edit_group_dialog.dart';
import 'widgets/group_card.dart';

class GroupsScreen extends ConsumerStatefulWidget {
  const GroupsScreen({super.key});

  @override
  ConsumerState<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends ConsumerState<GroupsScreen> {
  Future<void> _showAddGroupDialog() async {
    final careers = await ref.read(careerControllerProvider).getAllCareers();
    if (!mounted) return;

    if (careers.isEmpty) {
      RequirementDialog.show(
        context,
        title: 'Programa Requerido',
        message: 'No puedes crear un grupo de clase porque aún no has registrado ningún Programa o Carrera.\n\nPor favor, ve a la sección de "Programas" y agrega al menos un programa o carrera primero.',
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => const AddGroupDialog(),
    );
  }

  Future<void> _onDelete(ClassGroup group) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Grupo'),
        content: Text('¿Estás seguro de que deseas eliminar el grupo ${group.codigo}? Esta acción no se puede deshacer.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(classGroupControllerProvider).deleteGroup(group);
    }
  }

  void _showEditGroupDialog(ClassGroup group) {
    showDialog(
      context: context,
      builder: (context) => EditGroupDialog(group: group),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          _buildHeader(context),
          _buildAddButton(),
          const SizedBox(height: 16),
          Expanded(child: _buildGroupList()),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Grupos de Clases',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    fontFamily: 'Outfit',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Gestiona los grupos que tienes a tu cargo',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: _showAddGroupDialog,
          icon: const Icon(LucideIcons.plus, size: 20),
          label: const Text('Agregar Grupo'),
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

  Widget _buildGroupList() {
    final groupsAsync = ref.watch(allClassGroupsStreamProvider);

    return groupsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (groups) {
        if (groups.isEmpty) {
          return const _GroupsEmptyState();
        }
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          itemCount: groups.length,
          itemBuilder: (context, index) {
            final group = groups[index];
            return GroupCard(
              group: group,
              onEdit: () => _showEditGroupDialog(group),
              onDelete: () => _onDelete(group),
            );
          },
        );
      },
    );
  }
}

class _GroupsEmptyState extends StatelessWidget {
  const _GroupsEmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(LucideIcons.users, size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          const Text('No hay grupos registrados', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
