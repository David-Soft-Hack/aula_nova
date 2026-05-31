import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:drift/drift.dart' hide Column;
import '../../../config/theme/app_theme.dart';
import '../../../models/database_provider.dart';
import '../../../database/app_database.dart';
import 'activity_list_view.dart';
import 'unit_side_panel.dart';
import 'edit_unit_dialog.dart';
import 'edit_activity_dialog.dart';

class ModuleDetailDialog extends StatefulWidget {
  final Module module;
  const ModuleDetailDialog({super.key, required this.module});

  @override
  State<ModuleDetailDialog> createState() => _ModuleDetailDialogState();
}

class _ModuleDetailDialogState extends State<ModuleDetailDialog> {
  List<Unit> _units = [];
  List<Activity> _activities = [];
  String? _selectedUnitId;
  bool _isLoading = true;
  bool _viewingActivitiesMobile = false;

  @override
  void initState() {
    super.initState();
    _loadDetails();
  }

  void _loadDetails() async {
    final uList = await DatabaseProvider.unitDao.getUnitsByModule(
      widget.module.codModule,
    );
    if (uList.isNotEmpty) {
      final actQuery = DatabaseProvider.db.select(
        DatabaseProvider.db.activities,
      );
      final aList = await actQuery.get();

      setState(() {
        _units = uList;
        _activities = aList;
        _selectedUnitId = uList.first.codUnit;
        _isLoading = false;
      });
    } else {
      setState(() {
        _units = [];
        _activities = [];
        _selectedUnitId = null;
        _isLoading = false;
      });
    }
  }

  void _addUnit() async {
    final idx = _units.length + 1;
    final unitCode = '${widget.module.codModule}-U$idx';

    await DatabaseProvider.unitDao.insertUnit(
      UnitsCompanion(
        codUnit: Value(unitCode),
        nombre: Value('Unidad Didáctica $idx: Fundamentos'),
        totalHoraAcademic: const Value(16),
        totalHoraReloj: const Value(12),
        ponderacion: const Value(20.0),
        idModule: Value(widget.module.codModule),
      ),
    );

    _loadDetails();
  }

  void _deleteUnit(Unit unit) async {
    await (DatabaseProvider.db.delete(
      DatabaseProvider.db.units,
    )..where((t) => t.codUnit.equals(unit.codUnit))).go();
    _loadDetails();
  }

  void _editUnit(Unit unit) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => EditUnitDialog(unit: unit),
    );
    if (result == true) {
      _loadDetails();
    }
  }

  void _addActivity() async {
    if (_selectedUnitId == null) return;

    final unitActs = _activities
        .where((a) => a.idUnit == _selectedUnitId)
        .toList();
    final actCode = '$_selectedUnitId-A${unitActs.length + 1}';

    await DatabaseProvider.db
        .into(DatabaseProvider.db.activities)
        .insert(
          ActivitiesCompanion(
            codActivity: Value(actCode),
            descripcion: Value(
              'A${unitActs.length + 1}: Nueva actividad práctica',
            ),
            totalHoraAcademic: const Value(4),
            totalHoraReloj: const Value(3),
            idUnit: Value(_selectedUnitId!),
          ),
        );

    _loadDetails();
  }

  void _deleteActivity(Activity act) async {
    await (DatabaseProvider.db.delete(
      DatabaseProvider.db.activities,
    )..where((t) => t.codActivity.equals(act.codActivity))).go();
    _loadDetails();
  }

  void _editActivity(Activity act) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => EditActivityDialog(activity: act),
    );
    if (result == true) {
      _loadDetails();
    }
  }

  Widget _buildMobileLayout() {
    if (!_viewingActivitiesMobile || _selectedUnitId == null) {
      // Mobile Units List
      return Container(
        color: Colors.grey.shade50,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: UnitSidePanel(
          units: _units,
          selectedUnitId: _selectedUnitId,
          onUnitSelected: (unitId) {
            setState(() {
              _selectedUnitId = unitId;
              _viewingActivitiesMobile = true;
            });
          },
          onEdit: _editUnit,
          onDelete: _deleteUnit,
          onAddUnit: _addUnit,
        ),
      );
    } else {
      // Mobile Activities List for Selected Unit
      final currentUnit = _units.firstWhere(
        (u) => u.codUnit == _selectedUnitId,
      );
      final unitActs = _activities
          .where((a) => a.idUnit == _selectedUnitId)
          .toList();

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back Button
            InkWell(
              onTap: () => setState(() => _viewingActivitiesMobile = false),
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      LucideIcons.chevronLeft,
                      size: 14,
                      color: AppTheme.academic600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'VOLVER A UNIDADES',
                      style: TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w900,
                        color: AppTheme.academic600,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Header Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'ACTIVIDADES DE APRENDIZAJE',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        currentUnit.nombre,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(
                    LucideIcons.plusCircle,
                    color: AppTheme.academic600,
                    size: 20,
                  ),
                  onPressed: _addActivity,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const Divider(height: 24),

            // Activities List
            Expanded(
              child: ActivityListView(
                activities: unitActs,
                onEdit: _editActivity,
                onDelete: _deleteActivity,
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Column(
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  LucideIcons.bookOpen,
                                  color: AppTheme.academic600,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.module.codModule,
                                      style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.academic600,
                                      ),
                                    ),
                                    Text(
                                      widget.module.nombre,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        IconButton(
                          icon: const Icon(LucideIcons.x),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),

                  // Core Panel
                  Expanded(
                    child: _buildMobileLayout(),
                  ),
                ],
              ),
            ),
    );
  }
}
