import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/habit_repository.dart';
import 'habit_event.dart';
import 'habit_state.dart';

class HabitBloc extends Bloc<HabitEvent, HabitState>
    with WidgetsBindingObserver {
  final HabitRepository _habitRepository;
  Timer? _midnightTimer;
  DateTime _lastCheckDate = DateTime.now();

  HabitBloc({required HabitRepository habitRepository})
    : _habitRepository = habitRepository,
      super(const HabitState()) {
    on<LoadHabits>(_onLoadHabits);
    on<AddHabit>(_onAddHabit);
    on<UpdateHabit>(_onUpdateHabit);
    on<DeleteHabit>(_onDeleteHabit);
    on<ToggleHabitCompletion>(_onToggleHabitCompletion);

    // Schedule automatic reload at midnight
    _scheduleMidnightReload();

    // Listen to app lifecycle changes
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Check if date has changed while app was in background
      final now = DateTime.now();
      if (now.year != _lastCheckDate.year ||
          now.month != _lastCheckDate.month ||
          now.day != _lastCheckDate.day) {
        _lastCheckDate = now;
        add(LoadHabits());
        // Reschedule midnight timer for the new date
        _scheduleMidnightReload();
      }
    }
  }

  void _scheduleMidnightReload() {
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final durationUntilMidnight = tomorrow.difference(now);

    _midnightTimer?.cancel();
    _midnightTimer = Timer(durationUntilMidnight, () {
      _lastCheckDate = DateTime.now();
      add(LoadHabits());
      _scheduleMidnightReload(); // Schedule next day's reload
    });
  }

  Future<void> _onLoadHabits(LoadHabits event, Emitter<HabitState> emit) async {
    emit(state.copyWith(status: HabitStatus.loading));
    try {
      final habits = await _habitRepository.getHabits();
      emit(state.copyWith(status: HabitStatus.success, habits: habits));
    } catch (e) {
      emit(
        state.copyWith(status: HabitStatus.failure, errorMessage: e.toString()),
      );
    }
  }

  Future<void> _onAddHabit(AddHabit event, Emitter<HabitState> emit) async {
    try {
      await _habitRepository.addHabit(event.habit);
      add(LoadHabits());
    } catch (e) {
      emit(
        state.copyWith(status: HabitStatus.failure, errorMessage: e.toString()),
      );
    }
  }

  Future<void> _onUpdateHabit(
    UpdateHabit event,
    Emitter<HabitState> emit,
  ) async {
    try {
      await _habitRepository.updateHabit(event.habit);
      add(LoadHabits());
    } catch (e) {
      emit(
        state.copyWith(status: HabitStatus.failure, errorMessage: e.toString()),
      );
    }
  }

  Future<void> _onDeleteHabit(
    DeleteHabit event,
    Emitter<HabitState> emit,
  ) async {
    try {
      await _habitRepository.deleteHabit(event.id);
      add(LoadHabits());
    } catch (e) {
      emit(
        state.copyWith(status: HabitStatus.failure, errorMessage: e.toString()),
      );
    }
  }

  Future<void> _onToggleHabitCompletion(
    ToggleHabitCompletion event,
    Emitter<HabitState> emit,
  ) async {
    try {
      await _habitRepository.toggleCompletion(event.habitId, event.date);
      add(LoadHabits());
    } catch (e) {
      emit(
        state.copyWith(status: HabitStatus.failure, errorMessage: e.toString()),
      );
    }
  }

  @override
  Future<void> close() {
    _midnightTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    return super.close();
  }
}
