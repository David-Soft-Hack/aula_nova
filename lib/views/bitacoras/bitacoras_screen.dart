import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/theme/app_theme.dart';
import '../../database/app_database.dart';
import '../../database/tables.dart';
import '../../database/daos.dart';
import '../../providers/bitacora_providers.dart';
import 'widgets/bitacora_grid.dart';
import 'widgets/bitacoras_layout.dart';
import 'widgets/add_bitacora_stepper.dart';
import 'widgets/manage_bitacora_dialog.dart';
import '../shared/requirement_dialog.dart';

class BitacorasScreen extends ConsumerStatefulWidget {
  const BitacorasScreen({super.key});

  @override
  ConsumerState<BitacorasScreen> createState() => _BitacorasScreenState();
}

class _BitacorasScreenState extends ConsumerState<BitacorasScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchTerm = '';
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bitacorasAsync = ref.watch(bitacorasWithModuleStreamProvider);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BitacorasPageHeader(
                    onNewBitacora: () => _showAddBitacoraModal(context),
                  ),
                  const SizedBox(height: 12),
                  BitacoraSearchBar(
                    controller: _searchCtrl,
                    searchTerm: _searchTerm,
                    onChanged: (val) => setState(() => _searchTerm = val),
                    onClear: () => setState(() {
                      _searchTerm = '';
                      _searchCtrl.clear();
                    }),
                  ),
                ],
              ),
            ),

            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                labelColor: AppTheme.academic600,
                unselectedLabelColor: Colors.grey.shade500,
                indicatorColor: AppTheme.academic600,
                indicatorWeight: 3,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
                tabs: const [
                  Tab(text: 'Activas'),
                  Tab(text: 'Finalizadas'),
                ],
              ),
            ),
            const Divider(height: 1, thickness: 1),

            Expanded(
              child: bitacorasAsync.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(color: AppTheme.academic600),
                ),
                error: (e, _) => Center(child: Text('Error: $e')),
                data: (list) {
                  if (list.isEmpty) {
                    return BitacorasEmptyState(
                      onCreateBitacora: () => _showAddBitacoraModal(context),
                    );
                  }

                  final term = _searchTerm.toLowerCase();
                  final filtered = list.where((item) {
                    return item.bitacora.codigoGrupo
                            .toString()
                            .toLowerCase()
                            .contains(term) ||
                        item.module.nombre.toLowerCase().contains(term) ||
                        item.bitacora.carrera.toLowerCase().contains(term);
                  }).toList();

                  return TabBarView(
                    controller: _tabController,
                    children: [
                      BitacoraGrid(
                        items: filtered
                            .where((i) => i.bitacora.estado == EstadoBitacora.activo)
                            .toList(),
                        onManage: _showManageBitacoraModal,
                      ),
                      BitacoraGrid(
                        items: filtered
                            .where((i) => i.bitacora.estado == EstadoBitacora.finalizado)
                            .toList(),
                        onManage: _showManageBitacoraModal,
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showAddBitacoraModal(BuildContext context) async {
    final modules = await ref.read(bitacoraControllerProvider).getAllModules();
    if (!context.mounted) return;

    if (modules.isEmpty) {
      RequirementDialog.show(
        context,
        title: 'Módulo Requerido',
        message: 'No puedes configurar una bitácora porque aún no has registrado ningún Módulo Formativo.\n\nPor favor, ve a la sección de "Módulos Formativos" y sube o agrega un módulo primero.',
      );
      return;
    }

    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      pageBuilder: (context, _, _) => const AddBitacoraStepper(),
    );
  }

  void _showManageBitacoraModal(
    BitacoraWithModule item,
    List<CalendarioBitacora> sessions,
  ) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Cerrar',
      transitionDuration: const Duration(milliseconds: 400),
      transitionBuilder: (context, animation, _, child) {
        final curve = CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOutCubic,
        );
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, 0.15),
            end: Offset.zero,
          ).animate(curve),
          child: FadeTransition(opacity: animation, child: child),
        );
      },
      pageBuilder: (context, _, _) => ManageBitacoraDialog(
        bitacoraWithModule: item,
        initialSessions: sessions,
      ),
    );
  }
}
