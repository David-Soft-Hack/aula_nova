import 'package:flutter/material.dart';
import '../../../../config/theme/app_theme.dart';
import '../../../../database/app_database.dart';

class EditBitacoraBottomSheet extends StatefulWidget {
  final Bitacora bitacora;
  final Function(int freq, bool usarReloj) onSave;

  const EditBitacoraBottomSheet({
    super.key,
    required this.bitacora,
    required this.onSave,
  });

  @override
  State<EditBitacoraBottomSheet> createState() =>
      _EditBitacoraBottomSheetState();
}

class _EditBitacoraBottomSheetState extends State<EditBitacoraBottomSheet> {
  late final TextEditingController _freqController;
  late bool _usarReloj;

  @override
  void initState() {
    super.initState();
    _freqController = TextEditingController(
      text: widget.bitacora.frecuenciaClase.toString(),
    );
    _usarReloj = widget.bitacora.usarHorasReloj;
  }

  @override
  void dispose() {
    _freqController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle indicator
            Center(
              child: Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Editar Configuración de Bitácora',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.slate900,
                fontFamily: 'Outfit',
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Modifica los parámetros principales de las clases.',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
            ),
            const SizedBox(height: 24),

            // Freq Field
            TextField(
              controller: _freqController,
              keyboardType: TextInputType.number,
              style: const TextStyle(fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                labelText: 'Frecuencia de Clase (Horas)',
                labelStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(
                  Icons.timer_outlined,
                  color: AppTheme.academic500,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(
                    color: AppTheme.academic500,
                    width: 1.5,
                  ),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
            ),
            const SizedBox(height: 20),

            // Switch container
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Usar Horas Reloj',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: AppTheme.slate900,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _usarReloj
                            ? 'Sesiones de 60 minutos'
                            : 'Sesiones académicas de 45 minutos',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                  Switch(
                    value: _usarReloj,
                    activeTrackColor: AppTheme.academic600.withValues(
                      alpha: 0.5,
                    ),
                    activeThumbColor: AppTheme.academic600,
                    onChanged: (v) {
                      setState(() {
                        _usarReloj = v;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: const BorderSide(color: Color(0xFFCBD5E1)),
                      foregroundColor: const Color(0xFF475569),
                    ),
                    child: const Text('Cancelar'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      final int? freq = int.tryParse(_freqController.text);
                      if (freq != null && freq > 0) {
                        widget.onSave(freq, _usarReloj);
                        Navigator.of(context).pop();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.academic600,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Guardar Cambios',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
