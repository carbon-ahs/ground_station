import 'package:equatable/equatable.dart';
import '../../data/models/daily_log_entity.dart';
import '../../data/models/daily_note_entity.dart';

enum DailyLogStatus { initial, loading, success, failure }

class DailyLogState extends Equatable {
  final DailyLogStatus status;
  final DailyLogEntity? log;
  final List<DailyNoteEntity> notes;
  final List<DailyLogEntity> history;
  final String? errorMessage;

  const DailyLogState({
    this.status = DailyLogStatus.initial,
    this.log,
    this.notes = const [],
    this.history = const [],
    this.errorMessage,
  });

  DailyLogState copyWith({
    DailyLogStatus? status,
    DailyLogEntity? log,
    List<DailyNoteEntity>? notes,
    List<DailyLogEntity>? history,
    String? errorMessage,
  }) {
    return DailyLogState(
      status: status ?? this.status,
      log: log ?? this.log,
      notes: notes ?? this.notes,
      history: history ?? this.history,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, log, notes, history, errorMessage];
}
