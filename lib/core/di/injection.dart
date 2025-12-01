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

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  // Database Migrations
  final migration1to2 = Migration(1, 2, (database) async {
    await database.execute(
      'CREATE TABLE IF NOT EXISTS `WaterIntakeEntity` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `date` TEXT NOT NULL, `glassCount` INTEGER NOT NULL)',
    );
  });

  final migration2to3 = Migration(2, 3, (database) async {
    await database.execute(
      'CREATE TABLE IF NOT EXISTS `sleep_records` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `date` TEXT NOT NULL, `hours` REAL NOT NULL)',
    );
  });

  // Database
  final database = await $FloorAppDatabase
      .databaseBuilder('app_database.db')
      .addMigrations([migration1to2, migration2to3])
      .build();
  getIt.registerSingleton<AppDatabase>(database);

  // DataSources
  getIt.registerLazySingleton<HabitLocalDataSource>(
    () => HabitLocalDataSourceImpl(getIt()),
  );

  getIt.registerLazySingleton<WaterIntakeLocalDataSource>(
    () => WaterIntakeLocalDataSourceImpl(getIt()),
  );

  // Repositories
  getIt.registerLazySingleton<HabitRepository>(
    () => HabitRepositoryImpl(getIt()),
  );

  getIt.registerLazySingleton<WaterIntakeRepository>(
    () => WaterIntakeRepositoryImpl(getIt()),
  );

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton(() => sharedPreferences);

  // Blocs
  getIt.registerFactory(() => HabitBloc(habitRepository: getIt()));
  getIt.registerFactory(() => SettingsBloc(getIt()));
  getIt.registerFactory(() => WaterIntakeBloc(repository: getIt()));
  // Sleep Feature
  getIt.registerLazySingleton<SleepLocalDataSource>(
    () => SleepLocalDataSourceImpl(getIt()),
  );
  getIt.registerLazySingleton<SleepRepository>(
    () => SleepRepositoryImpl(getIt()),
  );
  getIt.registerFactory(() => SleepBloc(repository: getIt()));
}
