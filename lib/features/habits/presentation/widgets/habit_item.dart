import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/habit.dart';
import '../bloc/habit_bloc.dart';
import '../bloc/habit_event.dart';
import 'edit_habit_dialog.dart';

class HabitItem extends StatelessWidget {
  final Habit habit;

  const HabitItem({super.key, required this.habit});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: Checkbox(
          value: habit.isCompletedToday,
          onChanged: (value) {
            context.read<HabitBloc>().add(
              ToggleHabitCompletion(habit.id!, DateTime.now()),
            );
          },
        ),
        title: Text(
          habit.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            decoration: habit.isCompletedToday
                ? TextDecoration.lineThrough
                : null,
            color: habit.isCompletedToday ? Colors.grey : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (habit.description.isNotEmpty) Text(habit.description),
            if (habit.currentStreak > 0)
              Row(
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
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: () async {
                final updatedHabit = await showDialog<Habit>(
                  context: context,
                  builder: (context) => EditHabitDialog(habit: habit),
                );
                if (updatedHabit != null && context.mounted) {
                  context.read<HabitBloc>().add(UpdateHabit(updatedHabit));
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () {
                context.read<HabitBloc>().add(DeleteHabit(habit.id!));
              },
            ),
          ],
        ),
      ),
    ).animate().fadeIn().slideX(begin: -0.1, end: 0);
  }
}
