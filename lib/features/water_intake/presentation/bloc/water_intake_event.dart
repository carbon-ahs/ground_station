import 'package:equatable/equatable.dart';

abstract class WaterIntakeEvent extends Equatable {
  const WaterIntakeEvent();

  @override
  List<Object> get props => [];
}

class LoadWaterIntake extends WaterIntakeEvent {}

class IncrementWaterIntake extends WaterIntakeEvent {}

class DecrementWaterIntake extends WaterIntakeEvent {}

class ResetWaterIntake extends WaterIntakeEvent {}

class LoadWaterIntakeHistory extends WaterIntakeEvent {
  final int daysBack;

  const LoadWaterIntakeHistory({this.daysBack = 30});

  @override
  List<Object> get props => [daysBack];
}
