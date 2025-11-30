import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'settings_event.dart';
import 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SharedPreferences _prefs;
  static const String _themeKey = 'theme_mode';

  SettingsBloc(this._prefs) : super(const SettingsState()) {
    on<LoadSettings>(_onLoadSettings);
    on<UpdateTheme>(_onUpdateTheme);
  }

  void _onLoadSettings(LoadSettings event, Emitter<SettingsState> emit) {
    try {
      final themeIndex = _prefs.getInt(_themeKey);
      ThemeMode themeMode = ThemeMode.system;

      if (themeIndex != null) {
        themeMode = ThemeMode.values[themeIndex];
      }

      emit(
        state.copyWith(status: SettingsStatus.success, themeMode: themeMode),
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
      emit(
        state.copyWith(
          status: SettingsStatus.success,
          themeMode: event.themeMode,
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
}
