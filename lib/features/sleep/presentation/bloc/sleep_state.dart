import 'package:equatable/equatable.dart';
import '../../domain/entities/sleep_record.dart';

enum SleepStatus { initial, loading, success, failure }

class SleepState extends Equatable {
  final SleepStatus status;
  final double hours;
  final List<SleepRecord> history;
  final String? errorMessage;

  const SleepState({
    this.status = SleepStatus.initial,
    this.hours = 0.0,
    this.history = const [],
    this.errorMessage,
  });

  SleepState copyWith({
    SleepStatus? status,
    double? hours,
    List<SleepRecord>? history,
    String? errorMessage,
  }) {
    return SleepState(
      status: status ?? this.status,
      hours: hours ?? this.hours,
      history: history ?? this.history,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, hours, history, errorMessage];
}
