import 'package:floor/floor.dart';
import '../../features/daily_log/data/models/daily_log_entity.dart';
import '../../features/daily_log/data/models/daily_note_entity.dart';

@dao
abstract class DailyLogDao {
  // Daily Log Operations
  @Query('SELECT * FROM daily_logs')
  Future<List<DailyLogEntity>> getAllLogs();

  @Query('SELECT * FROM daily_logs WHERE date = :date')
  Future<DailyLogEntity?> getLogForDate(String date);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<int> insertLog(DailyLogEntity log);

  @Update(onConflict: OnConflictStrategy.replace)
  Future<void> updateLog(DailyLogEntity log);

  // Note Operations
  @Query('SELECT * FROM daily_notes WHERE daily_log_id = :logId')
  Future<List<DailyNoteEntity>> getNotesForLog(int logId);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<int> insertNote(DailyNoteEntity note);

  @delete
  Future<void> deleteNote(DailyNoteEntity note);

  @Query('DELETE FROM daily_notes WHERE id = :id')
  Future<void> deleteNoteById(int id);

  @Query('UPDATE daily_notes SET content = :content WHERE id = :id')
  Future<void> updateNoteContent(int id, String content);
}
