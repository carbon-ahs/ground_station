import 'package:equatable/equatable.dart';

abstract class DailyLogEvent extends Equatable {
  const DailyLogEvent();

  @override
  List<Object?> get props => [];
}

class LoadDailyLog extends DailyLogEvent {
  const LoadDailyLog();
}

class LoadDailyLogHistory extends DailyLogEvent {
  const LoadDailyLogHistory();
}

class SetMIT extends DailyLogEvent {
  final String title;
  const SetMIT(this.title);

  @override
  List<Object?> get props => [title];
}

class ToggleMIT extends DailyLogEvent {
  final bool completed;
  const ToggleMIT(this.completed);

  @override
  List<Object?> get props => [completed];
}

class AddNote extends DailyLogEvent {
  final String content;
  const AddNote(this.content);

  @override
  List<Object?> get props => [content];
}

class EditNote extends DailyLogEvent {
  final int noteId;
  final String content;
  const EditNote(this.noteId, this.content);

  @override
  List<Object?> get props => [noteId, content];
}

class DeleteNote extends DailyLogEvent {
  final int noteId;
  const DeleteNote(this.noteId);

  @override
  List<Object?> get props => [noteId];
}
