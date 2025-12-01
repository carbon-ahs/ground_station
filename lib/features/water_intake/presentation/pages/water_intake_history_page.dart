import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/presentation/widgets/ground_station_app_bar.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../../settings/presentation/bloc/settings_state.dart';
import '../bloc/water_intake_bloc.dart';
import '../bloc/water_intake_event.dart';
import '../bloc/water_intake_state.dart';

class WaterIntakeHistoryPage extends StatefulWidget {
  const WaterIntakeHistoryPage({super.key});

  @override
  State<WaterIntakeHistoryPage> createState() => _WaterIntakeHistoryPageState();
}

class _WaterIntakeHistoryPageState extends State<WaterIntakeHistoryPage> {
  @override
  void initState() {
    super.initState();
    context.read<WaterIntakeBloc>().add(const LoadWaterIntakeHistory());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GroundStationAppBar(title: 'Water Intake History'),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, settingsState) {
          final target = settingsState.waterIntakeTarget;

          return BlocBuilder<WaterIntakeBloc, WaterIntakeState>(
            builder: (context, intakeState) {
              if (intakeState.history.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.water_drop_outlined,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No water intake history yet',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Start tracking your daily water intake!',
                        style: TextStyle(color: Colors.grey[500]),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: intakeState.history.length,
                itemBuilder: (context, index) {
                  final intake = intakeState.history[index];
                  final dateStr = DateFormat(
                    'MMM dd, yyyy',
                  ).format(intake.date);
                  final isToday =
                      DateFormat('yyyy-MM-dd').format(intake.date) ==
                      DateFormat('yyyy-MM-dd').format(DateTime.now());
                  final progress = intake.glassCount / target;
                  final achieved = intake.glassCount >= target;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: CircleAvatar(
                        backgroundColor: achieved
                            ? Colors.green.withOpacity(0.2)
                            : Colors.blue.withOpacity(0.2),
                        child: Icon(
                          achieved ? Icons.check_circle : Icons.water_drop,
                          color: achieved ? Colors.green : Colors.blue,
                        ),
                      ),
                      title: Row(
                        children: [
                          Text(
                            dateStr,
                            style: const TextStyle(fontWeight: FontWeight.bold),
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
                                  color: Theme.of(context).colorScheme.primary,
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
                            '${intake.glassCount} / $target glasses',
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
                                achieved ? Colors.green : Colors.blue,
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
                          color: achieved ? Colors.green : Colors.blue,
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
