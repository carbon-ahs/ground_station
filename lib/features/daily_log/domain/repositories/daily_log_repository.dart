import '../../data/models/daily_log_entity.dart';
import '../../data/models/daily_note_entity.dart';

abstract class DailyLogRepository {
  Future<DailyLogEntity?> getLogForDate(DateTime date);
  Future<void> setMIT(DateTime date, String title);
  Future<void> toggleMIT(DateTime date, bool completed);
  Future<void> addNote(DateTime date, String content);
  Future<void> deleteNote(int noteId);
  Future<List<DailyNoteEntity>> getNotesForLog(int logId);
}
