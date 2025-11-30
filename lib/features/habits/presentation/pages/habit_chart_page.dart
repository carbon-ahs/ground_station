import 'package:flutter/material.dart';
import '../../domain/entities/habit.dart';
import '../../data/datasources/habit_local_data_source.dart';
import '../../../../core/di/injection.dart';
import '../widgets/completion_line_chart.dart';
import '../widgets/weekly_bar_chart.dart';

class HabitChartPage extends StatelessWidget {
  final Habit habit;

  const HabitChartPage({super.key, required this.habit});

  Future<List<DateTime>> _fetchCompletionDates() async {
    final dataSource = getIt<HabitLocalDataSource>();
    final logs = await dataSource.getHabitLogs(habit.id!);
    return logs
        .map((log) => DateTime.fromMillisecondsSinceEpoch(log.timestamp))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(habit.title), centerTitle: true),
      body: FutureBuilder<List<DateTime>>(
        future: _fetchCompletionDates(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final completionDates = snapshot.data ?? [];

          // Calculate weekly completions
          final weekdayCompletions = <int, int>{};
          for (var date in completionDates) {
            final weekday = date.weekday;
            weekdayCompletions[weekday] =
                (weekdayCompletions[weekday] ?? 0) + 1;
          }

          final endDate = DateTime.now();
          final startDate = endDate.subtract(const Duration(days: 30));

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _StatItem(
                          label: 'Current Streak',
                          value: '${habit.currentStreak}',
                          icon: Icons.local_fire_department,
                          color: Colors.orange,
                        ),
                        _StatItem(
                          label: 'Total',
                          value: completionDates.length.toString(),
                          icon: Icons.check_circle,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Completion Trend (Last 30 Days)',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Card(
                  child: CompletionLineChart(
                    completionDates: completionDates,
                    startDate: startDate,
                    endDate: endDate,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Weekly Pattern',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Card(
                  child: WeeklyBarChart(weekdayCompletions: weekdayCompletions),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
