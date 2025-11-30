import 'package:go_router/go_router.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/habits/presentation/pages/habits_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/habits/presentation/bloc/habit_bloc.dart';
import '../../features/habits/presentation/bloc/habit_event.dart';
import '../../core/di/injection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SplashPage()),
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => BlocProvider(
        create: (context) => getIt<HabitBloc>()..add(LoadHabits()),
        child: const DashboardPage(),
      ),
    ),
    GoRoute(path: '/habits', builder: (context, state) => const HabitsPage()),
    GoRoute(
      path: '/settings',
      builder: (context, state) => BlocProvider(
        create: (context) => getIt<HabitBloc>()..add(LoadHabits()),
        child: const SettingsPage(),
      ),
    ),
  ],
);
