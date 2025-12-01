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

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  // Database
  final database = await $FloorAppDatabase
      .databaseBuilder('app_database.db')
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
}
