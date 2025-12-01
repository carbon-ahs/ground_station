import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/sleep_repository.dart';
import 'sleep_event.dart';
import 'sleep_state.dart';

class SleepBloc extends Bloc<SleepEvent, SleepState>
    with WidgetsBindingObserver {
  final SleepRepository repository;
  DateTime _lastCheckDate = DateTime.now();

  SleepBloc({required this.repository}) : super(const SleepState()) {
    on<LoadSleep>(_onLoadSleep);
    on<UpdateSleep>(_onUpdateSleep);
    on<LoadSleepHistory>(_onLoadSleepHistory);

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      final now = DateTime.now();
      if (now.year != _lastCheckDate.year ||
          now.month != _lastCheckDate.month ||
          now.day != _lastCheckDate.day) {
        _lastCheckDate = now;
        add(LoadSleep());
      }
    }
  }

  Future<void> _onLoadSleep(LoadSleep event, Emitter<SleepState> emit) async {
    try {
      emit(state.copyWith(status: SleepStatus.loading));
      final record = await repository.getSleepForDate(DateTime.now());
      emit(
        state.copyWith(
          status: SleepStatus.success,
          hours: record?.hours ?? 0.0,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: SleepStatus.failure, errorMessage: e.toString()),
      );
    }
  }

  Future<void> _onUpdateSleep(
    UpdateSleep event,
    Emitter<SleepState> emit,
  ) async {
    try {
      if (event.hours > 24.0) {
        emit(
          state.copyWith(
            status: SleepStatus.failure,
            errorMessage: 'Sleep hours cannot exceed 24 hours',
          ),
        );
        return;
      }
      await repository.updateSleepHours(DateTime.now(), event.hours);
      add(LoadSleep());
    } catch (e) {
      emit(
        state.copyWith(status: SleepStatus.failure, errorMessage: e.toString()),
      );
    }
  }

  Future<void> _onLoadSleepHistory(
    LoadSleepHistory event,
    Emitter<SleepState> emit,
  ) async {
    try {
      final history = await repository.getSleepHistory(event.daysBack);
      emit(state.copyWith(history: history));
    } catch (e) {
      emit(
        state.copyWith(status: SleepStatus.failure, errorMessage: e.toString()),
      );
    }
  }

  @override
  Future<void> close() {
    WidgetsBinding.instance.removeObserver(this);
    return super.close();
  }
}
