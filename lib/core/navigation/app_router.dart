import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/habits/presentation/pages/habits_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/water_intake/presentation/pages/water_intake_history_page.dart';
import '../../features/sleep/presentation/pages/sleep_history_page.dart';
import '../../features/daily_log/presentation/pages/daily_log_history_page.dart';
import '../../features/habits/presentation/bloc/habit_bloc.dart';
import '../../features/habits/presentation/bloc/habit_event.dart';
import '../../core/di/injection.dart';
import 'scaffold_with_nav_bar.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/dashboard',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SplashPage()),
    GoRoute(
      path: '/water-history',
      builder: (context, state) => const WaterIntakeHistoryPage(),
    ),
    GoRoute(
      path: '/sleep-history',
      builder: (context, state) => const SleepHistoryPage(),
    ),
    GoRoute(
      path: '/daily-log-history',
      builder: (context, state) => const DailyLogHistoryPage(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ScaffoldWithNavBar(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/dashboard',
              builder: (context, state) => BlocProvider(
                create: (context) => getIt<HabitBloc>()..add(LoadHabits()),
                child: const DashboardPage(),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/habits',
              builder: (context, state) => BlocProvider(
                create: (context) => getIt<HabitBloc>()..add(LoadHabits()),
                child: const HabitsPage(),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/settings',
              builder: (context, state) => const SettingsPage(),
            ),
          ],
        ),
      ],
    ),
  ],
);
