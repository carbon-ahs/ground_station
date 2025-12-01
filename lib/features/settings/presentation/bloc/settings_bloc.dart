import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'settings_event.dart';
import 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SharedPreferences _prefs;
  static const String _themeKey = 'theme_mode';
  static const String _waterIntakeTargetKey = 'water_intake_target';
  static const String _sleepTargetKey = 'sleep_target';

  SettingsBloc(this._prefs) : super(const SettingsState()) {
    on<LoadSettings>(_onLoadSettings);
    on<UpdateTheme>(_onUpdateTheme);
    on<UpdateWaterIntakeTarget>(_onUpdateWaterIntakeTarget);
    on<UpdateSleepTarget>(_onUpdateSleepTarget);
  }

  void _onLoadSettings(LoadSettings event, Emitter<SettingsState> emit) {
    try {
      final themeIndex = _prefs.getInt(_themeKey);
      ThemeMode themeMode = ThemeMode.system;

      if (themeIndex != null) {
        themeMode = ThemeMode.values[themeIndex];
      }

      final waterIntakeTarget = _prefs.getInt(_waterIntakeTargetKey) ?? 8;
      final sleepTarget = _prefs.getDouble(_sleepTargetKey) ?? 8.0;

      emit(
        state.copyWith(
          status: SettingsStatus.success,
          themeMode: themeMode,
          waterIntakeTarget: waterIntakeTarget,
          sleepTarget: sleepTarget,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: SettingsStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onUpdateTheme(
    UpdateTheme event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      await _prefs.setInt(_themeKey, event.themeMode.index);
      emit(state.copyWith(themeMode: event.themeMode));
    } catch (e) {
      emit(
        state.copyWith(
          status: SettingsStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onUpdateWaterIntakeTarget(
    UpdateWaterIntakeTarget event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      await _prefs.setInt(_waterIntakeTargetKey, event.target);
      emit(state.copyWith(waterIntakeTarget: event.target));
    } catch (e) {
      emit(
        state.copyWith(
          status: SettingsStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onUpdateSleepTarget(
    UpdateSleepTarget event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      await _prefs.setDouble(_sleepTargetKey, event.target);
      emit(state.copyWith(sleepTarget: event.target));
    } catch (e) {
      emit(
        state.copyWith(
          status: SettingsStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
