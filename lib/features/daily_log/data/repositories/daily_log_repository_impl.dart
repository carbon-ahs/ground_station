import 'package:intl/intl.dart';
import '../../../../core/database/app_database.dart';
import '../../data/models/daily_log_entity.dart';
import '../../data/models/daily_note_entity.dart';
import '../../domain/repositories/daily_log_repository.dart';

class DailyLogRepositoryImpl implements DailyLogRepository {
  final AppDatabase _database;

  DailyLogRepositoryImpl(this._database);

  String _formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  @override
  Future<DailyLogEntity?> getLogForDate(DateTime date) async {
    return await _database.dailyLogDao.getLogForDate(_formatDate(date));
  }

  @override
  Future<void> setMIT(DateTime date, String title) async {
    final dateStr = _formatDate(date);
    var log = await _database.dailyLogDao.getLogForDate(dateStr);

    if (log == null) {
      log = DailyLogEntity(date: dateStr, mitTitle: title);
      await _database.dailyLogDao.insertLog(log);
    } else {
      log = DailyLogEntity(
        id: log.id,
        date: log.date,
        mitTitle: title,
        mitCompleted: log.mitCompleted,
      );
      await _database.dailyLogDao.updateLog(log);
    }
  }

  @override
  Future<void> toggleMIT(DateTime date, bool completed) async {
    final dateStr = _formatDate(date);
    var log = await _database.dailyLogDao.getLogForDate(dateStr);

    if (log != null) {
      log = DailyLogEntity(
        id: log.id,
        date: log.date,
        mitTitle: log.mitTitle,
        mitCompleted: completed,
      );
      await _database.dailyLogDao.updateLog(log);
    }
  }

  @override
  Future<void> addNote(DateTime date, String content) async {
    final dateStr = _formatDate(date);
    var log = await _database.dailyLogDao.getLogForDate(dateStr);

    // Ensure log exists
    if (log == null) {
      final newLogId = await _database.dailyLogDao.insertLog(
        DailyLogEntity(date: dateStr),
      );
      log = DailyLogEntity(id: newLogId, date: dateStr);
    }

    final note = DailyNoteEntity(dailyLogId: log.id!, content: content);
    await _database.dailyLogDao.insertNote(note);
  }

  @override
  Future<void> deleteNote(int noteId) async {
    await _database.dailyLogDao.deleteNoteById(noteId);
  }

  @override
  Future<List<DailyNoteEntity>> getNotesForLog(int logId) async {
    return await _database.dailyLogDao.getNotesForLog(logId);
  }

  @override
  Future<List<DailyLogEntity>> getAllLogs() async {
    return await _database.dailyLogDao.getAllLogs();
  }
}
