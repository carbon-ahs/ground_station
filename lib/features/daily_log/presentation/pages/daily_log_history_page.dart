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

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.history.length,
            itemBuilder: (context, index) {
              final item = state.history[index];
              final log = item.log;
              final notes = item.notes;
              final date = DateTime.parse(log.date);
              final dateStr = DateFormat('EEEE, MMMM d, y').format(date);

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dateStr,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      ),
                      const Divider(),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            log.mitCompleted
                                ? Icons.check_circle
                                : Icons.radio_button_unchecked,
                            color: log.mitCompleted
                                ? Colors.green
                                : Colors.grey,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              (log.mitTitle?.isNotEmpty ?? false)
                                  ? log.mitTitle!
                                  : 'No main goal set',
                              style: TextStyle(
                                decoration: log.mitCompleted
                                    ? TextDecoration.lineThrough
                                    : null,
                                color: log.mitCompleted ? Colors.grey : null,
                                fontStyle: (log.mitTitle?.isEmpty ?? true)
                                    ? FontStyle.italic
                                    : null,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (notes.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Text(
                          'Notes:',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        const SizedBox(height: 4),
                        ...notes.map(
                          (note) => Padding(
                            padding: const EdgeInsets.only(left: 8, bottom: 4),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('• '),
                                Expanded(child: Text(note.content)),
                              ],
                            ),
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
      ),
    );
  }
}
