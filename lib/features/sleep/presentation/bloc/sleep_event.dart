import 'package:equatable/equatable.dart';

abstract class SleepEvent extends Equatable {
  const SleepEvent();

  @override
  List<Object> get props => [];
}

class LoadSleep extends SleepEvent {}

class UpdateSleep extends SleepEvent {
  final double hours;

  const UpdateSleep(this.hours);

  @override
  List<Object> get props => [hours];
}

class LoadSleepHistory extends SleepEvent {
  final int daysBack;

  const LoadSleepHistory({this.daysBack = 30});

  @override
  List<Object> get props => [daysBack];
}
