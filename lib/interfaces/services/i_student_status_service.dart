import '../../database/app_database.dart';
import '../../database/tables.dart';

abstract class IStudentStatusService {
  Future<void> transitionActiveStudentsForGroup(String grupo, StudentStatus newStatus);
  Future<StudentStatus> determineGroupFinalStatus(
    String groupCode,
    List<CalendarioBitacora> sessions,
  );
}
