import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../config/theme/app_theme.dart';
import '../../controllers/career_controller.dart';
import '../../database/app_database.dart';
import 'widgets/add_career_dialog.dart';
import 'widgets/edit_career_dialog.dart';
import 'widgets/career_card.dart';

/// Pantalla de gestión de Carreras y Programas Formativos.
class CareersScreen extends StatefulWidget {
  const CareersScreen({super.key});

  @override
  State<CareersScreen> createState() => _CareersScreenState();
}

class _CareersScreenState extends State<CareersScreen> {
  final CareerController _controller = CareerController();

  void _showAddCareerDialog() {
    showDialog(
      context: context,
      builder: (context) => AddCareerDialog(controller: _controller),
    );
  }

  Future<void> _onDelete(Career career) async {
    final confirmed = await showDeleteCareerDialog(context);
    if (confirmed == true) {
      await _controller.deleteCareer(career);
    }
  }

  void _showEditCareerDialog(Career career) {
    showDialog(
      context: context,
      builder: (context) => EditCareerDialog(controller: _controller, career: career),
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
          Expanded(child: _buildCareerList()),
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

  Widget _buildAddButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: _showAddCareerDialog,
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

  Widget _buildCareerList() {
    return StreamBuilder<List<Career>>(
      stream: _controller.watchAllCareers(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final careers = snapshot.data ?? [];
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
              onEdit: () => _showEditCareerDialog(career),
              onDelete: () => _onDelete(career),
            );
          },
        );
      },
    );
  }
}

/// Estado vacío para la pantalla de Carreras.
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
