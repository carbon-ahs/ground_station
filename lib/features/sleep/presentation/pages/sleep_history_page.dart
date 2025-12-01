import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/presentation/widgets/ground_station_app_bar.dart';
import '../../../../core/presentation/widgets/weekly_bar_chart.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../../settings/presentation/bloc/settings_state.dart';
import '../bloc/sleep_bloc.dart';
import '../bloc/sleep_event.dart';
import '../bloc/sleep_state.dart';
import '../../domain/entities/sleep_record.dart';

class SleepHistoryPage extends StatefulWidget {
  const SleepHistoryPage({super.key});

  @override
  State<SleepHistoryPage> createState() => _SleepHistoryPageState();
}

class _SleepHistoryPageState extends State<SleepHistoryPage> {
  @override
  void initState() {
    super.initState();
    context.read<SleepBloc>().add(const LoadSleepHistory());
  }

  // Helper to get last 7 days data
  Map<String, dynamic> _getWeeklyData(List<SleepRecord> history) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    List<double> values = [];
    List<DateTime> dates = [];

    // Iterate backwards from today for 7 days
    for (int i = 6; i >= 0; i--) {
      final date = today.subtract(Duration(days: i));
      dates.add(date);

      // Find record for this date
      final record = history.firstWhere((h) {
        final hDate = DateTime(h.date.year, h.date.month, h.date.day);
        return hDate.isAtSameMomentAs(date);
      }, orElse: () => SleepRecord(id: null, date: date, hours: 0.0));

      values.add(record.hours);
    }

    return {'values': values, 'dates': dates};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GroundStationAppBar(title: 'Sleep History'),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, settingsState) {
          final target = settingsState.sleepTarget;

          return BlocBuilder<SleepBloc, SleepState>(
            builder: (context, sleepState) {
              if (sleepState.history.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.bedtime_outlined,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No sleep history yet',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Start tracking your sleep!',
                        style: TextStyle(color: Colors.grey[500]),
                      ),
                    ],
                  ),
                );
              }

              final weeklyData = _getWeeklyData(sleepState.history);

              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Weekly Chart
                  WeeklyBarChart(
                    weeklyValues: weeklyData['values'] as List<double>,
                    dates: weeklyData['dates'] as List<DateTime>,
                    target: target,
                    barColor: Colors.deepPurple,
                    unit: 'hours',
                  ),
                  const SizedBox(height: 24),

                  Text(
                    'History Log',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // History List
                  ...sleepState.history.map((record) {
                    final dateStr = DateFormat(
                      'MMM dd, yyyy',
                    ).format(record.date);
                    final isToday =
                        DateFormat('yyyy-MM-dd').format(record.date) ==
                        DateFormat('yyyy-MM-dd').format(DateTime.now());
                    final progress = record.hours / target;
                    final achieved = record.hours >= target;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        leading: CircleAvatar(
                          backgroundColor: achieved
                              ? Colors.green.withOpacity(0.2)
                              : Colors.deepPurple.withOpacity(0.2),
                          child: Icon(
                            achieved ? Icons.check_circle : Icons.bedtime,
                            color: achieved ? Colors.green : Colors.deepPurple,
                          ),
                        ),
                        title: Row(
                          children: [
                            Text(
                              dateStr,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (isToday) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'Today',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            Text(
                              '${record.hours.toStringAsFixed(1).replaceAll(RegExp(r'\.0$'), '')} / ${target.toStringAsFixed(1).replaceAll(RegExp(r'\.0$'), '')} hours',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: progress.clamp(0.0, 1.0),
                                minHeight: 8,
                                backgroundColor: Colors.grey[200],
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  achieved ? Colors.green : Colors.deepPurple,
                                ),
                              ),
                            ),
                          ],
                        ),
                        trailing: Text(
                          '${(progress * 100).toInt()}%',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: achieved ? Colors.green : Colors.deepPurple,
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
