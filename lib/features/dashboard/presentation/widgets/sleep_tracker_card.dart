import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../../settings/presentation/bloc/settings_state.dart';
import '../../../sleep/presentation/bloc/sleep_bloc.dart';
import '../../../sleep/presentation/bloc/sleep_event.dart';
import '../../../sleep/presentation/bloc/sleep_state.dart';

class SleepTrackerCard extends StatelessWidget {
  const SleepTrackerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, settingsState) {
        final target = settingsState.sleepTarget;

        return BlocBuilder<SleepBloc, SleepState>(
          builder: (context, sleepState) {
            final current = sleepState.hours;
            final progress = current / target;
            final isGoalReached = current >= target;

            return Card(
              elevation: 4,
              shadowColor: Colors.deepPurple.withOpacity(0.2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.deepPurple.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.bedtime,
                                color: Colors.deepPurple,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Sleep',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () => context.push('/sleep-history'),
                          icon: const Icon(Icons.history),
                          tooltip: 'View History',
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Progress Section
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          current
                              .toStringAsFixed(1)
                              .replaceAll(RegExp(r'\.0$'), ''),
                          style: Theme.of(context).textTheme.displayMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                                height: 1,
                              ),
                        ),
                        const SizedBox(width: 4),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Text(
                            '/ ${target.toStringAsFixed(1).replaceAll(RegExp(r'\.0$'), '')} hours',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Progress Bar
                    Stack(
                      children: [
                        Container(
                          height: 12,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            return Container(
                              height: 12,
                              width:
                                  constraints.maxWidth *
                                  progress.clamp(0.0, 1.0),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: isGoalReached
                                      ? [Colors.green.shade300, Colors.green]
                                      : [
                                          Colors.deepPurple.shade300,
                                          Colors.deepPurple,
                                        ],
                                ),
                                borderRadius: BorderRadius.circular(6),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        (isGoalReached
                                                ? Colors.green
                                                : Colors.deepPurple)
                                            .withOpacity(0.4),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Action Buttons
                    Row(
                      children: [
                        // Decrement
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: current > 0
                                ? () => context.read<SleepBloc>().add(
                                    UpdateSleep(current - 1.0),
                                  )
                                : null,
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.remove,
                                color: current > 0
                                    ? Colors.grey[700]
                                    : Colors.grey[300],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Increment (Main Action)
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: current < 24.0
                                ? () => context.read<SleepBloc>().add(
                                    UpdateSleep(current + 1.0),
                                  )
                                : null,
                            icon: const Icon(Icons.add),
                            label: const Text('Add 1 Hour'),
                            style: FilledButton.styleFrom(
                              backgroundColor: Colors.deepPurple,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Success Message
                    if (isGoalReached) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.green.shade200),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.bed,
                              color: Colors.green,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Sleep Goal Reached!',
                                    style: TextStyle(
                                      color: Colors.green.shade800,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Rest well!',
                                    style: TextStyle(
                                      color: Colors.green.shade600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
