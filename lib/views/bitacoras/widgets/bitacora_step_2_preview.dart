import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../config/theme/app_theme.dart';
import '../../../../database/app_database.dart';
import '../../../../utils/code_utils.dart';
import '../../shared/app_badge.dart';

class BitacoraStep2Preview extends StatelessWidget {
  final List<CalendarioBitacorasCompanion> generatedPreview;
  final bool usarHorasReloj;
  final void Function(int index, bool value) onSessionToggle;

  const BitacoraStep2Preview({
    super.key,
    required this.generatedPreview,
    required this.usarHorasReloj,
    required this.onSessionToggle,
  });



  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Revisión y Vista Previa del Calendario Dosificado',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            fontFamily: 'Outfit',
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'A continuación se muestra la dosificación automática calculada. Puedes marcar si la actividad ya fue impartida/desarrollada.',
          style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: usarHorasReloj ? Colors.amber.shade50 : AppTheme.academic50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: usarHorasReloj ? Colors.amber.shade200 : AppTheme.academic200,
            ),
          ),
          child: Row(
            children: [
              Icon(
                usarHorasReloj ? LucideIcons.hourglass : LucideIcons.bookOpen,
                color: usarHorasReloj ? Colors.amber.shade800 : AppTheme.academic700,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      usarHorasReloj
                          ? 'Tipo de Horas: Horas Reloj (HR)'
                          : 'Tipo de Horas: Horas Académicas (HA)',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: usarHorasReloj ? Colors.amber.shade900 : AppTheme.academic700,
                        fontSize: 14,
                        fontFamily: 'Outfit',
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      usarHorasReloj
                          ? 'Las sesiones están calculadas usando horas de 60 minutos.'
                          : 'Las sesiones están calculadas usando horas de 45 minutos (académicas).',
                      style: TextStyle(
                        color: usarHorasReloj ? Colors.amber.shade800 : AppTheme.academic600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: generatedPreview.length,
          itemBuilder: (context, index) {
            final session = generatedPreview[index];
            final rawUnitCode = session.codUnidad.value ?? '';
            final rawActCode = session.codActividad.value ?? '';

            final unitCode = getRelativeUnitCode(rawUnitCode);
            final actCode = getRelativeActivityCode(rawActCode);
            final hours = session.horaImpartir.value ?? 0;
            final date = session.fechaProgramada.value ?? DateTime.now();
            final dateStr = DateFormat('dd/MM/yyyy').format(date);
            final isDone = session.estadoImpartido.value;

            return Card(
              elevation: 0,
              margin: const EdgeInsets.only(bottom: 12),
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: Colors.grey.shade100),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                leading: Transform.scale(
                  scale: 0.9,
                  child: Checkbox(
                    value: isDone,
                    activeColor: AppTheme.academic600,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    onChanged: (val) {
                      onSessionToggle(index, val ?? false);
                    },
                  ),
                ),
                title: Row(
                  children: [
                    AppBadge(
                      label: unitCode,
                      color: AppTheme.academic700,
                      fontSize: 11,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        actCode,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Outfit',
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    children: [
                      const Icon(LucideIcons.calendar, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        dateStr,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(LucideIcons.clock, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          usarHorasReloj
                              ? '$hours HR (Reloj)'
                              : '$hours HA (Académica)',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
