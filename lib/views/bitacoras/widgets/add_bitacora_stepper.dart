import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:drift/drift.dart' show Value;
import '../../../config/theme/app_theme.dart';
import '../../../database/app_database.dart';
import '../../../database/tables.dart';
import '../../../providers/bitacora_providers.dart';
import '../../shared/app_snackbar.dart';
import 'bitacora_step_1_form.dart';
import 'bitacora_step_2_preview.dart';

class AddBitacoraStepper extends ConsumerStatefulWidget {
  const AddBitacoraStepper({super.key});

  @override
  ConsumerState<AddBitacoraStepper> createState() => _AddBitacoraStepperState();
}

class _AddBitacoraStepperState extends ConsumerState<AddBitacoraStepper> {
  int _currentStep = 1;
  Module? _selectedModule;
  final TextEditingController _grupoCtrl = TextEditingController();
  final TextEditingController _carreraCtrl = TextEditingController();
  String _selectedShift = 'Mañana';
  DateTime _startDate = DateTime.now();
  int _horasSesion = 4;
  bool _usarHorasReloj = false;
  final List<String> _diasSeleccionados = [];
  final List<DateTime> _fechasFeriadas = [];

  List<CalendarioBitacorasCompanion> _generatedPreview = [];
  bool _generating = false;

  final List<String> _diasSemana = [
    'Lunes',
    'Martes',
    'Miércoles',
    'Jueves',
    'Viernes',
    'Sábado',
    'Domingo',
  ];

  @override
  void dispose() {
    _grupoCtrl.dispose();
    _carreraCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(DateTime.now().year, 1, 1),
      lastDate: DateTime(DateTime.now().year, 12, 31),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppTheme.academic600,
              onPrimary: Colors.white,
              onSurface: Colors.black87,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _startDate = picked;
      });
    }
  }

  Future<void> _pickDateFeriado(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(DateTime.now().year, 1, 1),
      lastDate: DateTime(DateTime.now().year, 12, 31),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.redAccent,
              onPrimary: Colors.white,
              onSurface: Colors.black87,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      if (!_fechasFeriadas.contains(picked)) {
        setState(() {
          _fechasFeriadas.add(picked);
          _fechasFeriadas.sort();
        });
      }
    }
  }

  void _generateCalendarPreview() async {
    if (_selectedModule == null) return;
    setState(() {
      _generating = true;
    });

    try {
      final holidayStrings = _fechasFeriadas.map((d) {
        final year = d.year.toString();
        final month = d.month.toString().padLeft(2, '0');
        final day = d.day.toString().padLeft(2, '0');
        return '$year-$month-$day';
      }).toList();

      final preview = await ref.read(bitacoraControllerProvider).previewSchedule(
        module: _selectedModule!,
        fechaInicio: _startDate,
        diasClase: _diasSeleccionados,
        horasSesion: _horasSesion,
        fechasFeriadas: holidayStrings,
        usarHorasReloj: _usarHorasReloj,
      );

      if (mounted) {
        setState(() {
          _generatedPreview = preview;
          _generating = false;
          _currentStep = 2;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _generating = false;
        });
        AppSnackbar.showError(context, 'Error al dosificar: $e');
      }
    }
  }

  void _saveBitacora() async {
    if (_selectedModule == null) return;

    try {
      final holidayStrings = _fechasFeriadas.map((d) {
        final year = d.year.toString();
        final month = d.month.toString().padLeft(2, '0');
        final day = d.day.toString().padLeft(2, '0');
        return '$year-$month-$day';
      }).toList();

      final bitacoraCompanion = BitacorasCompanion.insert(
        frecuenciaClase: _horasSesion,
        fechaInicio: _startDate,
        fechasFeriadas: holidayStrings,
        diasClase: _diasSeleccionados,
        usarHorasReloj: Value(_usarHorasReloj),
        codigoGrupo: Value(
          _grupoCtrl.text.isNotEmpty ? _grupoCtrl.text : 'G-A',
        ),
        carrera: _carreraCtrl.text.isNotEmpty
            ? _carreraCtrl.text
            : 'Ing. de Software',
        tipoCarrera: TipoCarrera.tecnica,
        estado: EstadoBitacora.activo,
        idModule: _selectedModule!.codModule,
        turno: Value(_selectedShift),
      );

      await ref.read(bitacoraControllerProvider).createBitacoraFromPreview(
        bitacora: bitacoraCompanion,
        sessions: _generatedPreview,
      );

      if (mounted) {
        Navigator.of(context).pop();
        AppSnackbar.showSuccess(context, 'Bitácora y calendario creados con éxito');
      }
    } catch (e) {
      if (mounted) {
        AppSnackbar.showError(context, 'Error al guardar bitácora: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            // Premium Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x08000000),
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
                border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          width: 8,
                          height: 24,
                          decoration: BoxDecoration(
                            color: AppTheme.academic600,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: AppTheme.academic50,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      'Paso $_currentStep de 2',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: AppTheme.academic600,
                                        fontFamily: 'Outfit',
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                _currentStep == 1
                                    ? 'Configuración de la Bitácora'
                                    : 'Vista Previa del Calendario',
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E293B),
                                  fontFamily: 'Outfit',
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                _currentStep == 1
                                    ? 'Selecciona el módulo y configura los parámetros del grupo'
                                    : 'Revisa las sesiones generadas y confirma el calendario',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade500,
                                  fontFamily: 'Outfit',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(LucideIcons.x, color: Color(0xFF64748B)),
                    style: IconButton.styleFrom(
                      backgroundColor: const Color(0xFFF1F5F9),
                      padding: const EdgeInsets.all(8),
                    ),
                  ),
                ],
              ),
            ),

            // Step Content
            Expanded(child: _buildStepContent()),

            // Sticky Bottom Actions
            Container(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 16,
                bottom: isKeyboardOpen ? 12 : 20,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x08000000),
                    blurRadius: 10,
                    offset: Offset(0, -2),
                  ),
                ],
                border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_currentStep == 2)
                    OutlinedButton.icon(
                      onPressed: () {
                        setState(() {
                          _currentStep = 1;
                        });
                      },
                      icon: const Icon(LucideIcons.arrowLeft, size: 18),
                      label: const Text('Atrás'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: const BorderSide(color: Color(0xFFCBD5E1)),
                        foregroundColor: const Color(0xFF475569),
                      ),
                    )
                  else
                    const SizedBox.shrink(),
                  ElevatedButton(
                    onPressed: _currentStep == 1
                        ? _generateCalendarPreview
                        : _saveBitacora,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.academic600,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: _generating
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            _currentStep == 1
                                ? 'Siguiente'
                                : 'Generar Bitácora',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepContent() {
    if (_currentStep == 1) {
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: BitacoraStep1Form(
            selectedModule: _selectedModule,
            onModuleChanged: (val) {
              setState(() {
                _selectedModule = val;
                if (val != null && val.carrera != null) {
                  _carreraCtrl.text = val.carrera!;
                }
              });
            },
            grupoCtrl: _grupoCtrl,
            carreraCtrl: _carreraCtrl,
            selectedShift: _selectedShift,
            onShiftChanged: (val) {
              if (val != null) {
                setState(() => _selectedShift = val);
              }
            },
            horasSesion: _horasSesion,
            onHorasSesionChanged: (val) {
              setState(() => _horasSesion = val);
            },
            usarHorasReloj: _usarHorasReloj,
            onUsarHorasRelojChanged: (val) {
              setState(() => _usarHorasReloj = val);
            },
            startDate: _startDate,
            onPickDate: () => _pickDate(context),
            diasSeleccionados: _diasSeleccionados,
            onToggleDia: (day) {
              setState(() {
                if (_diasSeleccionados.contains(day)) {
                  _diasSeleccionados.remove(day);
                } else {
                  _diasSeleccionados.add(day);
                }
              });
            },
            fechasFeriadas: _fechasFeriadas,
            onAddFechaFeriada: () => _pickDateFeriado(context),
            onRemoveFechaFeriada: (date) {
              setState(() => _fechasFeriadas.remove(date));
            },
            diasSemana: _diasSemana,
          ),
        ),
      );
    } else {
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: BitacoraStep2Preview(
            generatedPreview: _generatedPreview,
            usarHorasReloj: _usarHorasReloj,
            onSessionToggle: (index, val) {
              setState(() {
                _generatedPreview[index] = _generatedPreview[index].copyWith(
                  estadoImpartido: Value(val),
                );
              });
            },
          ),
        ),
      );
    }
  }
}
