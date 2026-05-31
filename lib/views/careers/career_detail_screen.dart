import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../config/theme/app_theme.dart';
import '../../database/app_database.dart';
import '../../database/tables.dart' show TipoCarrera;
import '../../models/database_provider.dart';
import '../modules/widgets/module_card.dart';
import '../modules/widgets/module_options_sheet.dart';
import '../modules/widgets/edit_module_dialog.dart';
import '../modules/widgets/module_detail_dialog.dart';

/// Pantalla de detalle para visualizar información consolidada de una carrera/programa
/// y la lista de sus módulos asignados.
class CareerDetailScreen extends StatelessWidget {
  final Career career;

  const CareerDetailScreen({super.key, required this.career});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isTecnica = career.tipoCarrera == TipoCarrera.tecnica;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              career.nombre,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontFamily: 'Outfit',
                fontSize: 16,
              ),
            ),
            Text(
              isTecnica ? 'Carrera Técnica / Universitaria' : 'Curso Libre / Continuo',
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: StreamBuilder<List<Module>>(
          stream: DatabaseProvider.moduleDao.watchModulesByCareer(career.nombre),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: AppTheme.academic600),
              );
            }

            final modules = snapshot.data ?? [];
            final totalHA = modules.fold<int>(
              0,
              (sum, m) => sum + m.totalHoraAcademic,
            );
            final totalHR = modules.fold<int>(
              0,
              (sum, m) => sum + m.totalHoraReloj,
            );

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Tarjeta compacta de consolidación de carga horaria ────────
                  _buildCompactSummaryCard(totalHA, totalHR),
                  const SizedBox(height: 20),

                  // ── Encabezado de la sección de módulos ──────────────────────────
                  Row(
                    children: [
                      const Icon(
                        LucideIcons.bookOpen,
                        size: 18,
                        color: AppTheme.slate900,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Módulos Asignados (${modules.length})',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.slate900,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // ── Lista de módulos ──────────────────────────────────────────
                  if (modules.isEmpty)
                    _buildEmptyState()
                  else
                    Column(
                      children: modules.map((module) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: ModuleCard(
                            module: module,
                            onOptions: () => _showModuleOptions(context, module),
                            onManage: () => _showDetailModal(context, module),
                          ),
                        );
                      }).toList(),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCompactSummaryCard(int totalHA, int totalHR) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.01),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildCompactHourItem(
            title: 'H. Reloj',
            value: '$totalHR',
            color: AppTheme.academic600,
            icon: LucideIcons.clock,
          ),
          Container(width: 1, height: 24, color: Colors.grey.shade200),
          _buildCompactHourItem(
            title: 'H. Académicas',
            value: '$totalHA',
            color: Colors.amber.shade700,
            icon: LucideIcons.bookOpen,
          ),
        ],
      ),
    );
  }

  Widget _buildCompactHourItem({
    required String title,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.08),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 14, color: color),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        children: [
          Icon(LucideIcons.bookOpen, size: 48, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          const Text(
            'Sin módulos asignados',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: AppTheme.slate900,
            ),
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              'Este programa no tiene módulos formativos asignados actualmente.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
            ),
          ),
        ],
      ),
    );
  }

  void _showModuleOptions(BuildContext context, Module module) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => ModuleOptionsSheet(
        module: module,
        onEdit: () {
          showDialog(
            context: context,
            builder: (context) => EditModuleDialog(module: module),
          );
        },
      ),
    );
  }

  void _showDetailModal(BuildContext context, Module module) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Cerrar',
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) =>
          ModuleDetailDialog(module: module),
    );
  }
}
