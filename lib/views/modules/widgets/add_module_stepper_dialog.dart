import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../controllers/module_controller.dart';
import '../../../controllers/career_controller.dart';
import '../../../models/app_models.dart';
import '../../../services/excel_extractor_service.dart';
import '../../../services/module_extractor.dart';
import 'stepper_nav_widgets.dart';
import 'module_step_1_form.dart';
import 'module_step_2_units.dart';
import 'module_step_3_activities.dart';
import 'module_excel_handler.dart';
import '../../../config/theme/app_theme.dart';

class AddModuleStepperDialog extends StatefulWidget {
  const AddModuleStepperDialog({super.key});

  @override
  State<AddModuleStepperDialog> createState() => _AddModuleStepperDialogState();
}

class _AddModuleStepperDialogState extends State<AddModuleStepperDialog> {
  int _step = 1;
  String _creationTab = 'manual'; // 'manual' or 'upload'
  bool _isProcessing = false;
  bool _isSuccess = false;
  String? _importedExcelName;
  final ModuleExtractor _extractor = ExcelExtractorService();

  // Stepper Form States
  final _nombreCtrl = TextEditingController();
  final _codCtrl = TextEditingController();
  String _carrera = 'Ingeniería de Sistemas';
  List<String> _carreras = ['Ingeniería de Sistemas'];
  final _haCtrl = TextEditingController();
  final _hrCtrl = TextEditingController();

  List<Map<String, dynamic>> _units = [
    {'nombre': '', 'hr': 0, 'ha': 0, 'ponderacion': 0.0},
  ];

  List<Map<String, dynamic>> _activities = [
    {'codigo': '', 'unitIndex': 0, 'descripcion': '', 'hr': 0, 'ha': 0},
  ];

  // Reactive controllers for Units and Activities (so PDF import instantly updates fields)
  List<TextEditingController> _unitNombreCtrl = [];
  List<TextEditingController> _unitHrCtrl = [];
  List<TextEditingController> _unitHaCtrl = [];
  List<TextEditingController> _unitPonderCtrl = [];

  List<TextEditingController> _actCodeCtrl = [];
  List<TextEditingController> _actDescCtrl = [];
  List<TextEditingController> _actHrCtrl = [];
  List<TextEditingController> _actHaCtrl = [];

  void _syncControllersFromData() {
    // Dispose old controllers
    for (final c in [
      ..._unitNombreCtrl,
      ..._unitHrCtrl,
      ..._unitHaCtrl,
      ..._unitPonderCtrl,
    ]) {
      c.dispose();
    }
    for (final c in [
      ..._actDescCtrl,
      ..._actHrCtrl,
      ..._actHaCtrl,
      ..._actCodeCtrl,
    ]) {
      c.dispose();
    }

    _unitNombreCtrl = _units
        .map((u) => TextEditingController(text: u['nombre']?.toString() ?? ''))
        .toList();
    _unitHrCtrl = _units
        .map(
          (u) => TextEditingController(
            text: u['hr'] == 0 ? '' : u['hr'].toString(),
          ),
        )
        .toList();
    _unitHaCtrl = _units
        .map(
          (u) => TextEditingController(
            text: u['ha'] == 0 ? '' : u['ha'].toString(),
          ),
        )
        .toList();
    _unitPonderCtrl = _units
        .map(
          (u) => TextEditingController(
            text: u['ponderacion'] == 0.0 ? '' : u['ponderacion'].toString(),
          ),
        )
        .toList();

    _actCodeCtrl = _activities
        .map((a) => TextEditingController(text: a['codigo']?.toString() ?? ''))
        .toList();
    _actDescCtrl = _activities
        .map(
          (a) =>
              TextEditingController(text: a['descripcion']?.toString() ?? ''),
        )
        .toList();
    _actHrCtrl = _activities
        .map(
          (a) => TextEditingController(
            text: a['hr'] == 0 ? '' : a['hr'].toString(),
          ),
        )
        .toList();
    _actHaCtrl = _activities
        .map(
          (a) => TextEditingController(
            text: a['ha'] == 0 ? '' : a['ha'].toString(),
          ),
        )
        .toList();
  }

  @override
  void initState() {
    super.initState();
    _syncControllersFromData();
    _loadCareers();
  }

  void _loadCareers() async {
    final controller = CareerController();
    final careers = await controller.getAllCareers();
    if (careers.isNotEmpty) {
      if (mounted) {
        setState(() {
          _carreras = careers.map((e) => e.nombre).toList();
          if (!_carreras.contains(_carrera)) {
            _carrera = _carreras.first;
          }
        });
      }
    }
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _codCtrl.dispose();
    _haCtrl.dispose();
    _hrCtrl.dispose();
    for (final c in [
      ..._unitNombreCtrl,
      ..._unitHrCtrl,
      ..._unitHaCtrl,
      ..._unitPonderCtrl,
    ]) {
      c.dispose();
    }
    for (final c in [
      ..._actDescCtrl,
      ..._actHrCtrl,
      ..._actHaCtrl,
      ..._actCodeCtrl,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  void _pickAndImportExcel() {
    ModuleExcelHandler.pickAndImportExcel(
      context: context,
      mounted: mounted,
      extractor: _extractor,
      carreras: _carreras,
      nombreCtrl: _nombreCtrl,
      codCtrl: _codCtrl,
      haCtrl: _haCtrl,
      hrCtrl: _hrCtrl,
      onProcessingChanged: (val) {
        setState(() {
          _isProcessing = val;
        });
      },
      onImportSuccess:
          ({
            required String importedExcelName,
            required String nombre,
            required String codigo,
            required String career,
            required List<Map<String, dynamic>> units,
            required List<Map<String, dynamic>> activities,
          }) {
            setState(() {
              _importedExcelName = importedExcelName;
              _nombreCtrl.text = nombre;
              _codCtrl.text = codigo;
              _carrera = career;
              _haCtrl.text = '96';
              _hrCtrl.text = '72';
              _units = units;
              _activities = activities;
              _syncControllersFromData();
              _creationTab = 'manual';
              _step = 1;
            });
          },
    );
  }

  void _downloadExcelTemplate() {
    ModuleExcelHandler.downloadExcelTemplate(
      context: context,
      mounted: mounted,
      onProcessingChanged: (val) {
        setState(() {
          _isProcessing = val;
        });
      },
    );
  }

  void _finalizePlanning() async {
    final localContext = context;
    setState(() {
      _isProcessing = true;
    });

    try {
      final moduleCode = _codCtrl.text.trim().isEmpty
          ? 'MOD-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}'
          : _codCtrl.text.trim();

      // Check if a module with this code already exists in the database
      final existing = await DatabaseProvider.moduleDao.getModuleByCod(
        moduleCode,
      );
      if (!localContext.mounted) return;
      if (existing != null) {
        setState(() {
          _isProcessing = false;
        });
        ScaffoldMessenger.of(localContext).showSnackBar(
          SnackBar(
            content: Text(
              'El módulo con código "$moduleCode" ya existe en la base de datos.',
            ),
            backgroundColor: Colors.red.shade600,
          ),
        );
        return;
      }

      final totalHa = int.tryParse(_haCtrl.text) ?? 0;
      final totalHr = int.tryParse(_hrCtrl.text) ?? (totalHa * 0.8).floor();

      final moduleData = Module(
        codModule: moduleCode,
        nombre: _nombreCtrl.text.isEmpty ? 'Nuevo Módulo' : _nombreCtrl.text,
        totalHoraAcademic: totalHa,
        totalHoraReloj: totalHr,
        carrera: _carrera,
        fechaCreacion: DateTime.now(),
      );

      final List<Unit> unitsData = [];
      final List<Activity> activitiesData = [];

      for (int i = 0; i < _units.length; i++) {
        final u = _units[i];
        final unitCode = '$moduleCode-U${i + 1}';

        unitsData.add(
          Unit(
            codUnit: unitCode,
            nombre: u['nombre'].toString().isEmpty
                ? 'Unidad ${i + 1}'
                : u['nombre'].toString(),
            totalHoraAcademic: u['ha'] as int? ?? 0,
            totalHoraReloj: u['hr'] as int? ?? 0,
            ponderacion: u['ponderacion'] as double? ?? 0.0,
            idModule: moduleCode,
          ),
        );

        final actsForUnit = _activities
            .where((a) => a['unitIndex'] == i)
            .toList();
        for (int j = 0; j < actsForUnit.length; j++) {
          final act = actsForUnit[j];
          final rawCustomCode = act['codigo']?.toString().trim() ?? '';
          final customCode = rawCustomCode.isEmpty
              ? 'A${j + 1}'
              : rawCustomCode;
          final actCode = '$unitCode-$customCode';

          activitiesData.add(
            Activity(
              codActivity: actCode,
              descripcion: act['descripcion'].toString().isEmpty
                  ? 'Actividad ${j + 1}'
                  : act['descripcion'].toString(),
              totalHoraAcademic: act['ha'] as int? ?? 0,
              totalHoraReloj: act['hr'] as int? ?? 0,
              idUnit: unitCode,
            ),
          );
        }
      }

      final controller = ModuleController();
      await controller.createModuleWithDetails(
        module: moduleData,
        units: unitsData,
        activities: activitiesData,
      );

      if (!localContext.mounted) return;
      setState(() {
        _isProcessing = false;
        _isSuccess = true;
      });

      Timer(const Duration(milliseconds: 1500), () {
        if (localContext.mounted) Navigator.pop(localContext);
      });
    } catch (e) {
      if (!localContext.mounted) return;
      setState(() {
        _isProcessing = false;
      });
      ScaffoldMessenger.of(
        localContext,
      ).showSnackBar(SnackBar(content: Text('Error al crear planeación: $e')));
    }
  }

  bool get _canAdvance {
    if (_step == 1) {
      if (_creationTab == 'excel') return false;
      return _nombreCtrl.text.trim().isNotEmpty &&
          _codCtrl.text.trim().isNotEmpty &&
          _haCtrl.text.trim().isNotEmpty;
    } else if (_step == 2) {
      if (_units.isEmpty) return false;
      for (var u in _units) {
        if (u['nombre'].toString().trim().isEmpty) return false;
      }
      return true;
    } else if (_step == 3) {
      if (_activities.isEmpty) return false;
      for (var a in _activities) {
        if (a['descripcion'].toString().trim().isEmpty) return false;
      }
      return true;
    }
    return false;
  }

  Widget _buildUnifiedHeader() {
    final theme = Theme.of(context);
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return Container(
      padding: EdgeInsets.fromLTRB(
        20,
        isKeyboardOpen ? 10 : 16,
        16,
        isKeyboardOpen ? 10 : 14,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade100, width: 1.5)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isKeyboardOpen) ...[
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.academic50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    LucideIcons.bookOpen,
                    color: AppTheme.academic600,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Badge de paso
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppTheme.academic50,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Paso $_step de 3',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.academic600,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Titulo principal
                    Text(
                      'Plan de Módulo Académico',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: isKeyboardOpen ? 15 : 17,
                        color: AppTheme.slate900,
                      ),
                    ),
                    const SizedBox(height: 2),
                    // Subtítulo descriptivo según el paso
                    Text(
                      _getStepDescription(),
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: isKeyboardOpen ? 11 : 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  LucideIcons.x,
                  color: Colors.grey.shade400,
                  size: 20,
                ),
                splashRadius: 20,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Barra de progreso siempre visible
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: _step / 3,
              backgroundColor: Colors.grey.shade100,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppTheme.academic600,
              ),
              minHeight: 5,
            ),
          ),
          const SizedBox(height: 4),
          // Etiqueta del paso actual
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _getStepTitle(),
                style: TextStyle(
                  color: AppTheme.academic600,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '$_step/3 completado',
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getStepTitle() {
    switch (_step) {
      case 1:
        return 'Información General';
      case 2:
        return 'Unidades Didácticas';
      case 3:
        return 'Actividades de Aprendizaje';
      default:
        return '';
    }
  }

  String _getStepDescription() {
    switch (_step) {
      case 1:
        return 'Ingresa el nombre, código y horas del módulo';
      case 2:
        return 'Define las unidades didácticas y su ponderación';
      case 3:
        return 'Agrega las actividades de aprendizaje por unidad';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildUnifiedHeader(),

            if (_isSuccess)
              const Expanded(child: ModuleSuccessView())
            else ...[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: _buildStepContent(),
                ),
              ),

              if (!isKeyboardOpen)
                StepperFooter(
                  step: _step,
                  isProcessing: _isProcessing,
                  canAdvance: _canAdvance,
                  onPrevious: () => setState(() => _step = _step - 1),
                  onNext: () async {
                    final localContext = context;
                    if (_step == 1) {
                      final moduleCode = _codCtrl.text.trim();
                      if (moduleCode.isNotEmpty) {
                        setState(() {
                          _isProcessing = true;
                        });
                        try {
                          final existing = await DatabaseProvider.moduleDao
                              .getModuleByCod(moduleCode);
                          if (!localContext.mounted) return;
                          if (existing != null) {
                            setState(() {
                              _isProcessing = false;
                            });
                            ScaffoldMessenger.of(localContext).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'El módulo con código "$moduleCode" ya existe en la base de datos.',
                                ),
                                backgroundColor: Colors.red.shade600,
                              ),
                            );
                            return;
                          }
                        } catch (e) {
                          debugPrint('Error al verificar código de módulo: $e');
                        } finally {
                          if (localContext.mounted) {
                            setState(() {
                              _isProcessing = false;
                            });
                          }
                        }
                      }
                    }

                    if (_step == 3) {
                      _finalizePlanning();
                    } else {
                      setState(() => _step = _step + 1);
                    }
                  },
                ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStepContent() {
    if (_step == 1) {
      return ModuleStep1Form(
        creationTab: _creationTab,
        onTabChanged: (val) => setState(() => _creationTab = val),
        importedExcelName: _importedExcelName,
        unitsCount: _units.length,
        activitiesCount: _activities.length,
        totalHR: _hrCtrl.text,
        totalHA: _haCtrl.text,
        onDiscardExcel: () {
          setState(() {
            _importedExcelName = null;
            _nombreCtrl.clear();
            _codCtrl.clear();
            _haCtrl.clear();
            _hrCtrl.clear();
            _units = [
              {'nombre': '', 'hr': 0, 'ha': 0, 'ponderacion': 0.0},
            ];
            _activities = [
              {
                'codigo': '',
                'unitIndex': 0,
                'descripcion': '',
                'hr': 0,
                'ha': 0,
              },
            ];
            _syncControllersFromData();
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Datos importados descartados.')),
          );
        },
        onPickExcel: _pickAndImportExcel,
        onDownloadTemplate: _downloadExcelTemplate,
        nombreCtrl: _nombreCtrl,
        codCtrl: _codCtrl,
        hrCtrl: _hrCtrl,
        haCtrl: _haCtrl,
        carrera: _carrera,
        carreras: _carreras,
        onCarreraChanged: (val) {
          if (val != null) setState(() => _carrera = val);
        },
        onStateUpdated: () => setState(() {}),
        isProcessing: _isProcessing,
      );
    }

    if (_step == 2) {
      return ModuleStep2Units(
        units: _units,
        unitNombreCtrl: _unitNombreCtrl,
        unitHrCtrl: _unitHrCtrl,
        unitHaCtrl: _unitHaCtrl,
        unitPonderCtrl: _unitPonderCtrl,
        onAddUnit: () {
          setState(() {
            _units.add({'nombre': '', 'hr': 0, 'ha': 0, 'ponderacion': 0.0});
          });
        },
        onStateUpdated: () => setState(() {}),
      );
    }

    if (_step == 3) {
      return ModuleStep3Activities(
        activities: _activities,
        units: _units,
        actCodeCtrl: _actCodeCtrl,
        actDescCtrl: _actDescCtrl,
        actHrCtrl: _actHrCtrl,
        actHaCtrl: _actHaCtrl,
        onAddActivity: () {
          setState(() {
            _activities.add({
              'codigo': '',
              'unitIndex': 0,
              'descripcion': '',
              'hr': 0,
              'ha': 0,
            });
          });
        },
        onStateUpdated: () => setState(() {}),
      );
    }

    return const SizedBox();
  }
}
