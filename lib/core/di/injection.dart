import 'package:get_it/get_it.dart';
import '../../core/database/app_database.dart';
import '../../features/habits/data/datasources/habit_local_data_source.dart';
import '../../features/habits/data/repositories/habit_repository_impl.dart';
import '../../features/habits/domain/repositories/habit_repository.dart';
import '../../features/habits/presentation/bloc/habit_bloc.dart';

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

  // Repositories
  getIt.registerLazySingleton<HabitRepository>(
    () => HabitRepositoryImpl(getIt()),
  );

  // BLoCs
  getIt.registerFactory(() => HabitBloc(habitRepository: getIt()));
}
