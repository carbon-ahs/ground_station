import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/presentation/widgets/ground_station_app_bar.dart';
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
    return const HabitsView();
  }
}

class HabitsView extends StatelessWidget {
  const HabitsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GroundStationAppBar(title: 'Habits'),
      body: BlocBuilder<HabitBloc, HabitState>(
        builder: (context, state) {
          if (state.status == HabitStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.status == HabitStatus.failure) {
            return Center(child: Text('Error: ${state.errorMessage}'));
          } else if (state.habits.isEmpty) {
            return Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // lottie animation
                    Lottie.asset(
                      'assets/animations/antenna.json',
                      height:
                          MediaQuery.of(context).orientation ==
                              Orientation.landscape
                          ? 200
                          : null,
                      delegates: Theme.of(context).brightness == Brightness.dark
                          ? LottieDelegates(
                              values: [
                                // Dim the environment (Clouds, Trees, Bush, Floor)
                                ValueDelegate.color(const [
                                  'Cloud',
                                  '**',
                                  'Fill 1',
                                ], value: Colors.grey[800]),
                                ValueDelegate.color(const [
                                  'Branch',
                                  '**',
                                  'Fill 1',
                                ], value: Colors.grey[700]),
                                ValueDelegate.color(const [
                                  'Bush',
                                  '**',
                                  'Fill 1',
                                ], value: Colors.grey[700]),
                                ValueDelegate.color(const [
                                  'Ground',
                                  '**',
                                  'Fill 1',
                                ], value: Colors.grey[700]),
                                ValueDelegate.color(const [
                                  'Background',
                                  '**',
                                  'Fill 1',
                                ], value: Colors.transparent),
                                // Antenna Structure (Blue -> Light Blue)
                                ValueDelegate.color(const [
                                  'Receiver',
                                  '**',
                                  'Fill 1',
                                ], value: Colors.lightBlue[200]),
                                ValueDelegate.color(const [
                                  'Tower Poles',
                                  '**',
                                  'Fill 1',
                                ], value: Colors.lightBlue[200]),
                                ValueDelegate.color(const [
                                  'Ground Line',
                                  '**',
                                  'Fill 1',
                                ], value: Colors.lightBlue[200]),
                                ValueDelegate.color(const [
                                  'Receiver Shadow',
                                  '**',
                                  'Fill 1',
                                ], value: Colors.blueGrey[700]),
                                ValueDelegate.color(const [
                                  'Ground Shadow',
                                  '**',
                                  'Fill 1',
                                ], value: Colors.blueGrey[900]),
                                // Signals (Yellow -> Yellow Accent)
                                ValueDelegate.color(const [
                                  'Left Signal',
                                  '**',
                                  'Fill 1',
                                ], value: Colors.yellowAccent),
                                ValueDelegate.color(const [
                                  'Right Signal',
                                  '**',
                                  'Fill 1',
                                ], value: Colors.yellowAccent),
                              ],
                            )
                          : null,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No habits yet. Add one!',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: state.habits.length,
              itemBuilder: (context, index) {
                final habit = state.habits[index];
                return HabitItem(key: ValueKey(habit.id), habit: habit);
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
