import 'package:aula_nova/database/tables.dart';

import '../database/app_database.dart';

extension StudentHelpers on Student {
  String get fullName => '$nombres $apellidos';

  String get statusLabel {
    switch (estado) {
      case StudentStatus.activo:
        return 'Activo';
      case StudentStatus.inactivo:
        return 'Inactivo';
      case StudentStatus.graduado:
        return 'Graduado';
    }
  }
}
