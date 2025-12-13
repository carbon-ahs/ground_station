import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../habits/presentation/bloc/habit_bloc.dart';
import '../../../habits/presentation/bloc/habit_state.dart';
import '../widgets/stats_card.dart';
import '../../../../core/presentation/widgets/ground_station_app_bar.dart';
import '../widgets/water_intake_card.dart';
import '../widgets/sleep_tracker_card.dart';
import '../widgets/daily_log_card.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GroundStationAppBar(title: 'Ground Station'),
      body: BlocBuilder<HabitBloc, HabitState>(
        builder: (context, state) {
          final totalHabits = state.habits.length;
          final completedToday = state.habits
              .where((h) => h.isCompletedToday)
              .length;
          final completionRate = totalHabits > 0
              ? ((completedToday / totalHabits) * 100).toStringAsFixed(0)
              : '0';

          // Calculate best streak across all habits
          final bestStreak = state.habits.isEmpty
              ? 0
              : state.habits
                    .map((h) => h.currentStreak)
                    .reduce((a, b) => a > b ? a : b);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Water Intake Card
                const WaterIntakeCard(),
                const SizedBox(height: 16),

                // Sleep Tracker Card
                const SleepTrackerCard(),
                const SizedBox(height: 16),

                // Daily Log Card
                // const DailyLogCard(),
                // const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildOverviewWithCards(
    BuildContext context,
    int totalHabits,
    int completedToday,
    String completionRate,
    int bestStreak,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Overview',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: StatsCard(
                title: 'Total',
                value: totalHabits.toString(),
                icon: Icons.list_alt,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatsCard(
                title: 'Done',
                value: completedToday.toString(),
                icon: Icons.check_circle,
                color: Theme.of(context).colorScheme.tertiary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: StatsCard(
                title: 'Rate',
                value: '$completionRate%',
                icon: Icons.trending_up,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatsCard(
                title: 'Streak',
                value: bestStreak.toString(),
                icon: Icons.local_fire_department,
                color: Colors.orange,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
