import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ground_station/features/daily_log/presentation/bloc/daily_log_bloc.dart';
import 'package:ground_station/features/daily_log/presentation/bloc/daily_log_event.dart';
import 'package:ground_station/features/daily_log/presentation/bloc/daily_log_state.dart';

class DailyLogCard extends StatelessWidget {
  const DailyLogCard({super.key});

  void _showSetMITDialog(BuildContext context, String? currentTitle) {
    final controller = TextEditingController(text: currentTitle);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Set Most Important Task'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'What is your main focus today?',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                context.read<DailyLogBloc>().add(
                  SetMIT(controller.text.trim()),
                );
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showAddNoteDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Note'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Enter your note...',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                context.read<DailyLogBloc>().add(
                  AddNote(controller.text.trim()),
                );
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DailyLogBloc, DailyLogState>(
      builder: (context, state) {
        final mitTitle = state.log?.mitTitle;
        final mitCompleted = state.log?.mitCompleted ?? false;
        final notes = state.notes;

        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.today,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Daily Focus',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // MIT Section
                Text(
                  'Most Important Task',
                  style: Theme.of(
                    context,
                  ).textTheme.labelLarge?.copyWith(color: Colors.grey[600]),
                ),
                const SizedBox(height: 8),
                if (mitTitle == null || mitTitle.isEmpty)
                  InkWell(
                    onTap: () => _showSetMITDialog(context, null),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey.shade50,
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.add, color: Colors.grey[600], size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Set your MIT for today',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  InkWell(
                    onLongPress: () => _showSetMITDialog(context, mitTitle),
                    borderRadius: BorderRadius.circular(8),
                    child: Row(
                      children: [
                        Transform.scale(
                          scale: 1.2,
                          child: Checkbox(
                            value: mitCompleted,
                            onChanged: (value) {
                              context.read<DailyLogBloc>().add(
                                ToggleMIT(value ?? false),
                              );
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            mitTitle,
                            style: TextStyle(
                              fontSize: 16,
                              decoration: mitCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                              color: mitCompleted ? Colors.grey : null,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 24),

                // Notes Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Daily Notes',
                      style: Theme.of(
                        context,
                      ).textTheme.labelLarge?.copyWith(color: Colors.grey[600]),
                    ),
                    IconButton(
                      onPressed: () => _showAddNoteDialog(context),
                      icon: const Icon(Icons.add_circle_outline),
                      tooltip: 'Add Note',
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
                if (notes.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      'No notes yet',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: notes.length,
                    separatorBuilder: (context, index) =>
                        const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final note = notes[index];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(note.content),
                        trailing: IconButton(
                          icon: const Icon(Icons.close, size: 18),
                          onPressed: () {
                            context.read<DailyLogBloc>().add(
                              DeleteNote(note.id!),
                            );
                          },
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
