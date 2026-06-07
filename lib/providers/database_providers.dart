import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/app_database.dart';
import '../database/daos.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) => AppDatabase());

final moduleDaoProvider = Provider<ModuleDao>((ref) => ref.watch(appDatabaseProvider).moduleDao);

final unitDaoProvider = Provider<UnitDao>((ref) => ref.watch(appDatabaseProvider).unitDao);

final activityDaoProvider = Provider<ActivityDao>((ref) => ref.watch(appDatabaseProvider).activityDao);

final bitacoraDaoProvider = Provider<BitacoraDao>((ref) => ref.watch(appDatabaseProvider).bitacoraDao);

final careerDaoProvider = Provider<CareerDao>((ref) => ref.watch(appDatabaseProvider).careerDao);

final studentDaoProvider = Provider<StudentDao>((ref) => ref.watch(appDatabaseProvider).studentDao);
