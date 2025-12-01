import 'package:floor/floor.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/database/app_database.dart';
import '../../features/habits/data/datasources/habit_local_data_source.dart';
import '../../features/habits/data/repositories/habit_repository_impl.dart';
import '../../features/habits/domain/repositories/habit_repository.dart';
import '../../features/habits/presentation/bloc/habit_bloc.dart';
import '../../features/settings/presentation/bloc/settings_bloc.dart';
import '../../features/water_intake/data/datasources/water_intake_local_data_source.dart';
import '../../features/water_intake/data/repositories/water_intake_repository_impl.dart';
import '../../features/water_intake/domain/repositories/water_intake_repository.dart';
import '../../features/water_intake/presentation/bloc/water_intake_bloc.dart';
import '../../features/sleep/data/datasources/sleep_local_data_source.dart';
import '../../features/sleep/data/repositories/sleep_repository_impl.dart';
import '../../features/sleep/domain/repositories/sleep_repository.dart';
import '../../features/sleep/presentation/bloc/sleep_bloc.dart';
import '../../features/daily_log/data/repositories/daily_log_repository_impl.dart';
import '../../features/daily_log/domain/repositories/daily_log_repository.dart';
import '../../features/daily_log/presentation/bloc/daily_log_bloc.dart';
import '../../core/services/data_export_service.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  // Database Migrations
  final migration1to2 = Migration(1, 2, (database) async {
    await database.execute(
      'CREATE TABLE IF NOT EXISTS `water_intake` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `date` TEXT NOT NULL, `glass_count` INTEGER NOT NULL)',
    );
  });

  final migration2to3 = Migration(2, 3, (database) async {
    await database.execute(
      'CREATE TABLE IF NOT EXISTS `sleep_records` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `date` TEXT NOT NULL, `hours` REAL NOT NULL)',
    );
  });

  final migration3to4 = Migration(3, 4, (database) async {
    await database.execute(
      'CREATE TABLE IF NOT EXISTS `daily_logs` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `date` TEXT NOT NULL, `mit_title` TEXT, `mit_completed` INTEGER NOT NULL)',
    );
    await database.execute(
      'CREATE TABLE IF NOT EXISTS `daily_notes` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `daily_log_id` INTEGER NOT NULL, `content` TEXT NOT NULL, FOREIGN KEY (`daily_log_id`) REFERENCES `daily_logs` (`id`) ON DELETE CASCADE)',
    );
  });

  // Database
  final database = await $FloorAppDatabase
      .databaseBuilder('app_database.db')
      .addMigrations([migration1to2, migration2to3, migration3to4])
      .build();
  getIt.registerSingleton<AppDatabase>(database);

  // DataSources
  getIt.registerLazySingleton<HabitLocalDataSource>(
    () => HabitLocalDataSourceImpl(getIt()),
  );

  getIt.registerLazySingleton<WaterIntakeLocalDataSource>(
    () => WaterIntakeLocalDataSourceImpl(getIt()),
  );

  getIt.registerLazySingleton<SleepLocalDataSource>(
    () => SleepLocalDataSourceImpl(getIt()),
  );

  // Repositories
  getIt.registerLazySingleton<HabitRepository>(
    () => HabitRepositoryImpl(getIt()),
  );

  getIt.registerLazySingleton<WaterIntakeRepository>(
    () => WaterIntakeRepositoryImpl(getIt()),
  );

  getIt.registerLazySingleton<SleepRepository>(
    () => SleepRepositoryImpl(getIt()),
  );

  getIt.registerLazySingleton<DailyLogRepository>(
    () => DailyLogRepositoryImpl(getIt()),
  );

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton(() => sharedPreferences);

  // Services
  getIt.registerLazySingleton<DataExportService>(
    () => DataExportService(getIt(), getIt()),
  );

  // Blocs
  getIt.registerFactory(() => HabitBloc(habitRepository: getIt()));
  getIt.registerFactory(() => SettingsBloc(getIt()));
  getIt.registerFactory(() => WaterIntakeBloc(repository: getIt()));
  getIt.registerFactory(() => SleepBloc(repository: getIt()));
  getIt.registerFactory(() => DailyLogBloc(repository: getIt()));
}
