import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/water_intake_repository.dart';
import 'water_intake_event.dart';
import 'water_intake_state.dart';

class WaterIntakeBloc extends Bloc<WaterIntakeEvent, WaterIntakeState>
    with WidgetsBindingObserver {
  final WaterIntakeRepository repository;
  DateTime _lastCheckDate = DateTime.now();

  WaterIntakeBloc({required this.repository})
    : super(const WaterIntakeState()) {
    on<LoadWaterIntake>(_onLoadWaterIntake);
    on<IncrementWaterIntake>(_onIncrementWaterIntake);
    on<DecrementWaterIntake>(_onDecrementWaterIntake);
    on<ResetWaterIntake>(_onResetWaterIntake);
    on<LoadWaterIntakeHistory>(_onLoadWaterIntakeHistory);

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
        add(LoadWaterIntake());
      }
    }
  }

  Future<void> _onLoadWaterIntake(
    LoadWaterIntake event,
    Emitter<WaterIntakeState> emit,
  ) async {
    try {
      emit(state.copyWith(status: WaterIntakeStatus.loading));
      final intake = await repository.getWaterIntakeForDate(DateTime.now());
      emit(
        state.copyWith(
          status: WaterIntakeStatus.success,
          glassCount: intake?.glassCount ?? 0,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: WaterIntakeStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onIncrementWaterIntake(
    IncrementWaterIntake event,
    Emitter<WaterIntakeState> emit,
  ) async {
    try {
      await repository.incrementWaterIntake(DateTime.now());
      add(LoadWaterIntake()); // Reload to get updated count
    } catch (e) {
      emit(
        state.copyWith(
          status: WaterIntakeStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onDecrementWaterIntake(
    DecrementWaterIntake event,
    Emitter<WaterIntakeState> emit,
  ) async {
    try {
      await repository.decrementWaterIntake(DateTime.now());
      add(LoadWaterIntake()); // Reload to get updated count
    } catch (e) {
      emit(
        state.copyWith(
          status: WaterIntakeStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onResetWaterIntake(
    ResetWaterIntake event,
    Emitter<WaterIntakeState> emit,
  ) async {
    try {
      await repository.resetWaterIntake(DateTime.now());
      add(LoadWaterIntake()); // Reload to get updated count
    } catch (e) {
      emit(
        state.copyWith(
          status: WaterIntakeStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onLoadWaterIntakeHistory(
    LoadWaterIntakeHistory event,
    Emitter<WaterIntakeState> emit,
  ) async {
    try {
      final history = await repository.getWaterIntakeHistory(event.daysBack);
      emit(state.copyWith(history: history));
    } catch (e) {
      emit(
        state.copyWith(
          status: WaterIntakeStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  @override
  Future<void> close() {
    WidgetsBinding.instance.removeObserver(this);
    return super.close();
  }
}
