import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/habit_repository.dart';
import 'habit_event.dart';
import 'habit_state.dart';

class HabitBloc extends Bloc<HabitEvent, HabitState> {
  final HabitRepository _habitRepository;

  HabitBloc({required HabitRepository habitRepository})
      : _habitRepository = habitRepository,
        super(const HabitState()) {
    on<LoadHabits>(_onLoadHabits);
    on<AddHabit>(_onAddHabit);
    on<UpdateHabit>(_onUpdateHabit);
    on<DeleteHabit>(_onDeleteHabit);
    on<ToggleHabitCompletion>(_onToggleHabitCompletion);
  }

  Future<void> _onLoadHabits(LoadHabits event, Emitter<HabitState> emit) async {
    emit(state.copyWith(status: HabitStatus.loading));
    try {
      final habits = await _habitRepository.getHabits();
      emit(state.copyWith(status: HabitStatus.success, habits: habits));
    } catch (e) {
      emit(state.copyWith(status: HabitStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> _onAddHabit(AddHabit event, Emitter<HabitState> emit) async {
    try {
      await _habitRepository.addHabit(event.habit);
      add(LoadHabits());
    } catch (e) {
      emit(state.copyWith(status: HabitStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> _onUpdateHabit(UpdateHabit event, Emitter<HabitState> emit) async {
    try {
      await _habitRepository.updateHabit(event.habit);
      add(LoadHabits());
    } catch (e) {
      emit(state.copyWith(status: HabitStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> _onDeleteHabit(DeleteHabit event, Emitter<HabitState> emit) async {
    try {
      await _habitRepository.deleteHabit(event.id);
      add(LoadHabits());
    } catch (e) {
      emit(state.copyWith(status: HabitStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> _onToggleHabitCompletion(ToggleHabitCompletion event, Emitter<HabitState> emit) async {
    try {
      await _habitRepository.toggleCompletion(event.habitId, event.date);
      add(LoadHabits());
    } catch (e) {
      emit(state.copyWith(status: HabitStatus.failure, errorMessage: e.toString()));
    }
  }
}
