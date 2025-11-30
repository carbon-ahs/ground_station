import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../domain/entities/habit.dart';
import '../bloc/habit_bloc.dart';
import '../bloc/habit_event.dart';
import '../bloc/habit_state.dart';
import '../widgets/add_habit_dialog.dart';
import '../widgets/habit_item.dart';

class HabitsPage extends StatelessWidget {
  const HabitsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<HabitBloc>()..add(LoadHabits()),
      child: const HabitsView(),
    );
  }
}

class HabitsView extends StatelessWidget {
  const HabitsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ground Station'), centerTitle: true),
      body: BlocBuilder<HabitBloc, HabitState>(
        builder: (context, state) {
          if (state.status == HabitStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.status == HabitStatus.failure) {
            return Center(child: Text('Error: ${state.errorMessage}'));
          } else if (state.habits.isEmpty) {
            return const Center(child: Text('No habits yet. Add one!'));
          } else {
            return ListView.builder(
              itemCount: state.habits.length,
              itemBuilder: (context, index) {
                return HabitItem(habit: state.habits[index]);
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final habit = await showDialog<Habit>(
            context: context,
            builder: (context) => const AddHabitDialog(),
          );
          if (habit != null && context.mounted) {
            context.read<HabitBloc>().add(AddHabit(habit));
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
