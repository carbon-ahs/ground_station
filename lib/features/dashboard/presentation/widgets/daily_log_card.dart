import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../daily_log/data/models/daily_note_entity.dart';
import '../../../daily_log/presentation/bloc/daily_log_bloc.dart';
import '../../../daily_log/presentation/bloc/daily_log_event.dart';
import '../../../daily_log/presentation/bloc/daily_log_state.dart';

class DailyLogCard extends StatelessWidget {
  const DailyLogCard({super.key});

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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () => context.push('/daily-log-history'),
                      icon: const Icon(Icons.history),
                      tooltip: 'View History',
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
                          Icon(
                            Icons.add_circle_outline,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Set today\'s main goal',
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 16,
                            ),
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
                        IconButton(
                          icon: const Icon(Icons.edit, size: 20),
                          onPressed: () => _showSetMITDialog(context, mitTitle),
                          tooltip: 'Edit MIT',
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
                      'Notes',
                      style: Theme.of(
                        context,
                      ).textTheme.labelLarge?.copyWith(color: Colors.grey[600]),
                    ),
                    TextButton.icon(
                      onPressed: () => _showNoteDialog(context),
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Add Note'),
                      style: TextButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                  ],
                ),
                if (notes.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, size: 18),
                              onPressed: () =>
                                  _showNoteDialog(context, note: note),
                              tooltip: 'Edit Note',
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, size: 18),
                              onPressed: () {
                                context.read<DailyLogBloc>().add(
                                  DeleteNote(note.id!),
                                );
                              },
                              tooltip: 'Delete Note',
                            ),
                          ],
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

  Future<void> _showSetMITDialog(BuildContext context, String? currentTitle) {
    final controller = TextEditingController(text: currentTitle);
    return showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(currentTitle == null ? 'Set Main Goal' : 'Edit Main Goal'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'What is your most important task?',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
          textCapitalization: TextCapitalization.sentences,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                context.read<DailyLogBloc>().add(
                  SetMIT(controller.text.trim()),
                );
                Navigator.pop(dialogContext);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _showNoteDialog(BuildContext context, {DailyNoteEntity? note}) {
    final controller = TextEditingController(text: note?.content);
    final isEditing = note != null;

    return showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(isEditing ? 'Edit Note' : 'Add Note'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Enter your note...',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
          textCapitalization: TextCapitalization.sentences,
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                if (isEditing) {
                  context.read<DailyLogBloc>().add(
                    EditNote(note.id!, controller.text.trim()),
                  );
                } else {
                  context.read<DailyLogBloc>().add(
                    AddNote(controller.text.trim()),
                  );
                }
                Navigator.pop(dialogContext);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
