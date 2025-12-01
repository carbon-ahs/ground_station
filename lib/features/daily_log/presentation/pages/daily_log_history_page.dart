import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../presentation/bloc/daily_log_bloc.dart';
import '../../presentation/bloc/daily_log_event.dart';
import '../../presentation/bloc/daily_log_state.dart';

class DailyLogHistoryPage extends StatelessWidget {
  const DailyLogHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Trigger load history when page opens
    context.read<DailyLogBloc>().add(const LoadDailyLogHistory());

    return Scaffold(
      appBar: AppBar(title: const Text('Daily Focus History')),
      body: BlocBuilder<DailyLogBloc, DailyLogState>(
        builder: (context, state) {
          if (state.status == DailyLogStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.history.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.history,
                    size: 64,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No history yet',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                ],
              ),
            );
          }

          // Sort history by date descending
          final sortedHistory = List.of(state.history)
            ..sort((a, b) => b.date.compareTo(a.date));

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: sortedHistory.length,
            itemBuilder: (context, index) {
              final log = sortedHistory[index];
              final date = DateTime.parse(log.date);
              final formattedDate = DateFormat.yMMMd().format(date);

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: log.mitCompleted
                        ? Colors.green.withValues(alpha: 0.1)
                        : Colors.orange.withValues(alpha: 0.1),
                    child: Icon(
                      log.mitCompleted ? Icons.check : Icons.priority_high,
                      color: log.mitCompleted ? Colors.green : Colors.orange,
                    ),
                  ),
                  title: Text(
                    (log.mitTitle ?? '').isNotEmpty
                        ? log.mitTitle!
                        : 'No MIT set',
                    style: TextStyle(
                      decoration: log.mitCompleted
                          ? TextDecoration.lineThrough
                          : null,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Text(formattedDate),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
