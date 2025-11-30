import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/habit.dart';
import '../bloc/habit_bloc.dart';
import '../bloc/habit_event.dart';
import 'edit_habit_dialog.dart';
import '../pages/habit_chart_page.dart';

class HabitItem extends StatelessWidget {
  final Habit habit;

  const HabitItem({super.key, required this.habit});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: habit.isCompletedToday ? 1 : 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: habit.isCompletedToday
              ? colorScheme.primary.withValues(alpha: 0.3)
              : Colors.transparent,
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // Checkbox with custom styling
            Transform.scale(
              scale: 1.2,
              child: Checkbox(
                value: habit.isCompletedToday,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                onChanged: (value) {
                  context.read<HabitBloc>().add(
                    ToggleHabitCompletion(habit.id!, DateTime.now()),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    habit.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      decoration: habit.isCompletedToday
                          ? TextDecoration.lineThrough
                          : null,
                      color: habit.isCompletedToday
                          ? colorScheme.onSurface.withValues(alpha: 0.5)
                          : colorScheme.onSurface,
                    ),
                  ),
                  if (habit.description.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      habit.description,
                      style: TextStyle(
                        fontSize: 13,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                  if (habit.currentStreak > 0) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.orange.withValues(alpha: 0.2),
                            Colors.deepOrange.withValues(alpha: 0.2),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.local_fire_department,
                            size: 16,
                            color: Colors.orange,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${habit.currentStreak} day streak',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.orange,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Action buttons
            PopupMenuButton<String>(
              icon: Icon(Icons.more_vert, color: colorScheme.onSurfaceVariant),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'chart',
                  child: Row(
                    children: [
                      Icon(Icons.show_chart, color: colorScheme.primary),
                      const SizedBox(width: 12),
                      const Text('View Chart'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit_outlined, color: colorScheme.primary),
                      const SizedBox(width: 12),
                      const Text('Edit'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete_outline, color: colorScheme.error),
                      const SizedBox(width: 12),
                      const Text('Delete'),
                    ],
                  ),
                ),
              ],
              onSelected: (value) async {
                switch (value) {
                  case 'chart':
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => HabitChartPage(habit: habit),
                      ),
                    );
                    break;
                  case 'edit':
                    final updatedHabit = await showDialog<Habit>(
                      context: context,
                      builder: (context) => EditHabitDialog(habit: habit),
                    );
                    if (updatedHabit != null && context.mounted) {
                      context.read<HabitBloc>().add(UpdateHabit(updatedHabit));
                    }
                    break;
                  case 'delete':
                    if (context.mounted) {
                      context.read<HabitBloc>().add(DeleteHabit(habit.id!));
                    }
                    break;
                }
              },
            ),
          ],
        ),
      ),
    ).animate().fadeIn().slideX(begin: -0.1, end: 0);
  }
}
