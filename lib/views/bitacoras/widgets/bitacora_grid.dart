import 'package:flutter/material.dart';
import '../../../database/app_database.dart';
import '../../../database/daos.dart';
import 'bitacora_card.dart';

/// Grid de tarjetas de bitácoras con estado vacío integrado.
class BitacoraGrid extends StatelessWidget {
  final List<BitacoraWithModule> items;
  final void Function(BitacoraWithModule item, List<CalendarioBitacora> sessions) onManage;

  const BitacoraGrid({
    super.key,
    required this.items,
    required this.onManage,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Center(
        child: Text(
          'No se encontraron bitácoras en esta sección.',
          style: TextStyle(color: Colors.grey.shade500),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        crossAxisSpacing: 16,
        mainAxisSpacing: 12,
        mainAxisExtent: 160,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return BitacoraCard(
          item: item,
          onManage: (sessions) => onManage(item, sessions),
        );
      },
    );
  }
}
