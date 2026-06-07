import 'package:drift/drift.dart';
import '../database/app_database.dart';
import '../database/daos.dart';
import '../database/tables.dart';
import '../interfaces/services/i_student_status_service.dart';

class StudentStatusService implements IStudentStatusService {
  final AppDatabase db;
  final StudentDao studentDao;

  StudentStatusService({required this.db, required this.studentDao});

  @override
  Future<void> transitionActiveStudentsForGroup(
    String grupo,
    StudentStatus newStatus,
  ) async {
    await (db.update(db.students)
          ..where(
            (s) =>
                s.grupo.equals(grupo) &
                s.estado.equals(StudentStatus.activo.index),
          ))
        .write(StudentsCompanion(estado: Value(newStatus)));
  }

  @override
  Future<StudentStatus> determineGroupFinalStatus(
    String groupCode,
    List<CalendarioBitacora> sessions,
  ) async {
    final allCompleted =
        sessions.isNotEmpty && sessions.every((s) => s.estadoImpartido);
    return allCompleted ? StudentStatus.finalizado : StudentStatus.suspendido;
  }
}
