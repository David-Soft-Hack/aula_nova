import '../database/app_database.dart';

export '../database/app_database.dart' show CalendarioBitacora, CalendarioBitacorasCompanion;

extension CalendarioBitacoraExtension on CalendarioBitacora {
  bool get isPending => !estadoImpartido;
}
