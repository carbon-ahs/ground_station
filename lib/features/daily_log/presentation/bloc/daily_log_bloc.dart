import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/daily_log_repository.dart';
import 'daily_log_event.dart';
import 'daily_log_state.dart';

class DailyLogBloc extends Bloc<DailyLogEvent, DailyLogState>
    with WidgetsBindingObserver {
  final DailyLogRepository repository;
  DateTime _lastCheckDate = DateTime.now();

  DailyLogBloc({required this.repository}) : super(const DailyLogState()) {
    on<LoadDailyLog>(_onLoadDailyLog);
    on<SetMIT>(_onSetMIT);
    on<ToggleMIT>(_onToggleMIT);
    on<AddNote>(_onAddNote);
    on<DeleteNote>(_onDeleteNote);

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
        add(const LoadDailyLog());
      }
    }
  }

  Future<void> _onLoadDailyLog(
    LoadDailyLog event,
    Emitter<DailyLogState> emit,
  ) async {
    try {
      emit(state.copyWith(status: DailyLogStatus.loading));
      final log = await repository.getLogForDate(DateTime.now());
      final notes = log != null ? await repository.getNotesForLog(log.id!) : [];

      // If log is null, we still return success with null log (empty state)
      // Or we could return a default empty log entity if preferred, but null is fine for UI to show "Set MIT"
      emit(
        state.copyWith(
          status: DailyLogStatus.success,
          log: log,
          notes: notes as dynamic,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: DailyLogStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onSetMIT(SetMIT event, Emitter<DailyLogState> emit) async {
    try {
      await repository.setMIT(DateTime.now(), event.title);
      add(const LoadDailyLog());
    } catch (e) {
      emit(
        state.copyWith(
          status: DailyLogStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onToggleMIT(
    ToggleMIT event,
    Emitter<DailyLogState> emit,
  ) async {
    try {
      await repository.toggleMIT(DateTime.now(), event.completed);
      add(const LoadDailyLog());
    } catch (e) {
      emit(
        state.copyWith(
          status: DailyLogStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onAddNote(AddNote event, Emitter<DailyLogState> emit) async {
    try {
      await repository.addNote(DateTime.now(), event.content);
      add(const LoadDailyLog());
    } catch (e) {
      emit(
        state.copyWith(
          status: DailyLogStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onDeleteNote(
    DeleteNote event,
    Emitter<DailyLogState> emit,
  ) async {
    try {
      await repository.deleteNote(event.noteId);
      add(const LoadDailyLog());
    } catch (e) {
      emit(
        state.copyWith(
          status: DailyLogStatus.failure,
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
