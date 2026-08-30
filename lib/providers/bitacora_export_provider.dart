import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/bitacora_export_service.dart';

/// Proveedor del servicio de exportación de bitácoras.
/// Se usa como singleton para evitar instancias duplicadas.
final bitacoraExportServiceProvider = Provider<BitacoraExportService>(
  (ref) => BitacoraExportService(),
);
