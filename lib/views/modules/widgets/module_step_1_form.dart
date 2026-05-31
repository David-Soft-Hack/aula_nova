import 'package:flutter/material.dart';
import 'excel_import_banner.dart';
import 'excel_import_widgets.dart';

class ModuleStep1Form extends StatelessWidget {
  final String creationTab;
  final ValueChanged<String> onTabChanged;
  final String? importedExcelName;
  final int unitsCount;
  final int activitiesCount;
  final String totalHR;
  final String totalHA;
  final VoidCallback onDiscardExcel;
  final VoidCallback onPickExcel;
  final VoidCallback onDownloadTemplate;
  final TextEditingController nombreCtrl;
  final TextEditingController codCtrl;
  final TextEditingController hrCtrl;
  final TextEditingController haCtrl;
  final String carrera;
  final List<String> carreras;
  final ValueChanged<String?> onCarreraChanged;
  final VoidCallback onStateUpdated;
  final bool isProcessing;

  const ModuleStep1Form({
    super.key,
    required this.creationTab,
    required this.onTabChanged,
    required this.importedExcelName,
    required this.unitsCount,
    required this.activitiesCount,
    required this.totalHR,
    required this.totalHA,
    required this.onDiscardExcel,
    required this.onPickExcel,
    required this.onDownloadTemplate,
    required this.nombreCtrl,
    required this.codCtrl,
    required this.hrCtrl,
    required this.haCtrl,
    required this.carrera,
    required this.carreras,
    required this.onCarreraChanged,
    required this.onStateUpdated,
    required this.isProcessing,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          CreationTabSelector(
            selectedTab: creationTab,
            onTabChanged: onTabChanged,
          ),
          const SizedBox(height: 24),

          if (creationTab == 'manual')
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ExcelImportBanner(
                  importedExcelName: importedExcelName,
                  unitsCount: unitsCount,
                  activitiesCount: activitiesCount,
                  totalHR: totalHR,
                  totalHA: totalHA,
                  onDiscard: onDiscardExcel,
                ),
                const Text(
                  'Nombre del Módulo',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: nombreCtrl,
                  onChanged: (_) => onStateUpdated(),
                  decoration: InputDecoration(
                    hintText: 'Ej: Infraestructura de red',
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Código',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: codCtrl,
                  onChanged: (_) => onStateUpdated(),
                  decoration: InputDecoration(
                    hintText: 'Ej: MF 180_2',
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'H. Reloj',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 6),
                          TextField(
                            controller: haCtrl,
                            keyboardType: TextInputType.number,
                            onChanged: (_) => onStateUpdated(),
                            decoration: InputDecoration(
                              hintText: '0',
                              filled: true,
                              fillColor: Colors.grey.shade50,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'H. Académicas',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 6),
                          TextField(
                            controller: hrCtrl,
                            keyboardType: TextInputType.number,
                            onChanged: (_) => onStateUpdated(),
                            decoration: InputDecoration(
                              hintText: '0',
                              filled: true,
                              fillColor: Colors.grey.shade50,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Carrera / Programa',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: carrera,
                      isExpanded: true,
                      onChanged: onCarreraChanged,
                      items: carreras
                          .map(
                            (c) => DropdownMenuItem(value: c, child: Text(c)),
                          )
                          .toList(),
                    ),
                  ),
                ),
              ],
            )
          else
            ExcelDropZone(
              isProcessing: isProcessing,
              onTap: onPickExcel,
              onDownloadTemplate: onDownloadTemplate,
            ),
        ],
      ),
    );
  }
}
