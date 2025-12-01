import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum SettingsStatus { initial, loading, success, failure }

class SettingsState extends Equatable {
  final SettingsStatus status;
  final ThemeMode themeMode;
  final int waterIntakeTarget;
  final double sleepTarget;
  final String? errorMessage;

  const SettingsState({
    this.status = SettingsStatus.initial,
    this.themeMode = ThemeMode.system,
    this.waterIntakeTarget = 8,
    this.sleepTarget = 8.0,
    this.errorMessage,
  });

  SettingsState copyWith({
    SettingsStatus? status,
    ThemeMode? themeMode,
    int? waterIntakeTarget,
    double? sleepTarget,
    String? errorMessage,
  }) {
    return SettingsState(
      status: status ?? this.status,
      themeMode: themeMode ?? this.themeMode,
      waterIntakeTarget: waterIntakeTarget ?? this.waterIntakeTarget,
      sleepTarget: sleepTarget ?? this.sleepTarget,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    themeMode,
    waterIntakeTarget,
    sleepTarget,
    errorMessage,
  ];
}
