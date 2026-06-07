import '../interfaces/controllers/i_dashboard_controller.dart';
import '../interfaces/repositories/i_module_repository.dart';
import '../interfaces/repositories/i_bitacora_repository.dart';
import '../interfaces/repositories/i_student_repository.dart';
import '../database/daos.dart';
import '../database/tables.dart';

class DashboardController implements IDashboardController {
  final IModuleRepository _moduleRepository;
  final IBitacoraRepository _bitacoraRepository;
  final IStudentRepository _studentRepository;

  DashboardController({
    required IModuleRepository moduleRepository,
    required IBitacoraRepository bitacoraRepository,
    required IStudentRepository studentRepository,
  })  : _moduleRepository = moduleRepository,
        _bitacoraRepository = bitacoraRepository,
        _studentRepository = studentRepository;

  @override
  Stream<int> get totalModules =>
      _moduleRepository.watchAllModules().map((list) => list.length);

  @override
  Stream<int> get activeBitacoras => _bitacoraRepository
      .watchBitacorasWithModule()
      .map((list) => list.where((item) => item.bitacora.estado == EstadoBitacora.activo).length);

  @override
  Stream<int> get activeStudents =>
      _studentRepository.watchAllStudents().map((list) => list.where((s) => s.estado == StudentStatus.activo).length);

  @override
  Stream<int> get totalHours => _moduleRepository
      .watchAllModules()
      .map((list) => list.fold(0, (sum, m) => sum + (m.totalHoraAcademic)));

  @override
  Stream<List<TodaySessionData>> get todaySessions =>
      _bitacoraRepository.watchTodaySessions();

  @override
  Stream<List<TodaySessionData>> get upcomingSessions =>
      _bitacoraRepository.watchUpcomingSessions(days: 7);
}
