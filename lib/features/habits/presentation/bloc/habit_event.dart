import 'package:equatable/equatable.dart';
import '../../domain/entities/habit.dart';

abstract class HabitEvent extends Equatable {
  const HabitEvent();

  @override
  List<Object> get props => [];
}

class LoadHabits extends HabitEvent {}

class AddHabit extends HabitEvent {
  final Habit habit;

  const AddHabit(this.habit);

  @override
  List<Object> get props => [habit];
}

class UpdateHabit extends HabitEvent {
  final Habit habit;

  const UpdateHabit(this.habit);

  @override
  List<Object> get props => [habit];
}

class DeleteHabit extends HabitEvent {
  final int id;

  const DeleteHabit(this.id);

  @override
  List<Object> get props => [id];
}

class ToggleHabitCompletion extends HabitEvent {
  final int habitId;
  final DateTime date;

  const ToggleHabitCompletion(this.habitId, this.date);

  @override
  List<Object> get props => [habitId, date];
}
