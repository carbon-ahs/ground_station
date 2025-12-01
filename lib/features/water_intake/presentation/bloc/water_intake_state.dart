import 'package:equatable/equatable.dart';
import '../../domain/entities/water_intake.dart';

enum WaterIntakeStatus { initial, loading, success, failure }

class WaterIntakeState extends Equatable {
  final WaterIntakeStatus status;
  final int glassCount;
  final List<WaterIntake> history;
  final String? errorMessage;

  const WaterIntakeState({
    this.status = WaterIntakeStatus.initial,
    this.glassCount = 0,
    this.history = const [],
    this.errorMessage,
  });

  WaterIntakeState copyWith({
    WaterIntakeStatus? status,
    int? glassCount,
    List<WaterIntake>? history,
    String? errorMessage,
  }) {
    return WaterIntakeState(
      status: status ?? this.status,
      glassCount: glassCount ?? this.glassCount,
      history: history ?? this.history,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, glassCount, history, errorMessage];
}
