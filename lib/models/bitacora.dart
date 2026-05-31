import '../database/app_database.dart';
import '../database/tables.dart';

export '../database/app_database.dart' show Bitacora, BitacorasCompanion;
export '../database/tables.dart' show TipoCarrera, EstadoBitacora;

extension BitacoraExtension on Bitacora {
  bool get isFinalized => estado == EstadoBitacora.finalizado;
}
