import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../habits/presentation/bloc/habit_bloc.dart';
import '../../../habits/presentation/bloc/habit_state.dart';
import '../widgets/stats_card.dart';
import '../widgets/quick_action_button.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ground Station'), centerTitle: true),
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
                Text(
                  'Overview',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // Stats Cards - Row layout to prevent overflow
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

                const SizedBox(height: 32),

                Text(
                  'Quick Actions',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    QuickActionButton(
                      label: 'View All Habits',
                      icon: Icons.view_list,
                      onPressed: () => context.go('/habits'),
                    ),
                    QuickActionButton(
                      label: 'Add New Habit',
                      icon: Icons.add_circle,
                      onPressed: () => context.go('/habits'),
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
