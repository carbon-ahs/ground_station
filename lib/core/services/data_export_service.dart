import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../../features/habits/data/models/habit_entity.dart';
import '../../features/habits/data/models/habit_log_entity.dart';
import '../../features/habits/data/datasources/habit_local_data_source.dart';
import '../../core/database/app_database.dart';
import '../../features/daily_log/data/models/daily_log_entity.dart';
import '../../features/daily_log/data/models/daily_note_entity.dart';

class DataExportService {
  final HabitLocalDataSource habitDataSource;
  final AppDatabase database;

  DataExportService(this.habitDataSource, this.database);

  Future<String> exportDataToJSON() async {
    // 1. Fetch Habits & Logs
    final habits = await habitDataSource.getHabits();
    final List<Map<String, dynamic>> habitsJson = [];
    final List<Map<String, dynamic>> habitLogsJson = [];

    for (var habit in habits) {
      habitsJson.add({
        'id': habit.id,
        'title': habit.title,
        'description': habit.description,
        'created_at': habit.createdAtMillis,
      });

      final logs = await habitDataSource.getHabitLogs(habit.id!);
      for (var log in logs) {
        habitLogsJson.add({'habit_id': habit.id, 'timestamp': log.timestamp});
      }
    }

    // 2. Fetch Daily Logs & Notes
    final dailyLogs = await database.dailyLogDao.getAllLogs();
    final List<Map<String, dynamic>> dailyLogsJson = [];

    for (var log in dailyLogs) {
      final notes = await database.dailyLogDao.getNotesForLog(log.id!);
      dailyLogsJson.add({
        'date': log.date,
        'mit_title': log.mitTitle,
        'mit_completed': log.mitCompleted,
        'notes': notes.map((n) => n.content).toList(),
      });
    }

    // 3. Construct JSON
    final exportData = {
      'version': 1,
      'habits': habitsJson,
      'habit_logs': habitLogsJson,
      'daily_logs': dailyLogsJson,
    };

    final jsonString = const JsonEncoder.withIndent('  ').convert(exportData);

    // 4. Save to file
    final directory = await getApplicationDocumentsDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final file = File(
      '${directory.path}/ground_station_backup_$timestamp.json',
    );
    await file.writeAsString(jsonString);

    return file.path;
  }

  Future<void> importDataFromJSON(String filePath) async {
    final file = File(filePath);
    final jsonString = await file.readAsString();
    final Map<String, dynamic> data = jsonDecode(jsonString);

    // 1. Import Habits
    final habits = (data['habits'] as List).cast<Map<String, dynamic>>();
    for (var h in habits) {
      final habit = HabitEntity(
        title: h['title'],
        description: h['description'],
        createdAtMillis: h['created_at'],
      );

      final oldId = h['id'];
      final newId = await habitDataSource.addHabit(habit);

      // 2. Import Habit Logs for this habit
      final allLogs = (data['habit_logs'] as List).cast<Map<String, dynamic>>();
      final logsForHabit = allLogs.where((l) => l['habit_id'] == oldId);

      for (var logData in logsForHabit) {
        await habitDataSource.addHabitLog(
          HabitLogEntity(habitId: newId, timestamp: logData['timestamp']),
        );
      }
    }

    // 3. Import Daily Logs
    if (data.containsKey('daily_logs')) {
      final dailyLogs = (data['daily_logs'] as List)
          .cast<Map<String, dynamic>>();
      for (var logData in dailyLogs) {
        final date = logData['date'];

        var existingLog = await database.dailyLogDao.getLogForDate(date);
        int logId;

        if (existingLog != null) {
          logId = existingLog.id!;
          if (logData['mit_title'] != null) {
            await database.dailyLogDao.updateLog(
              DailyLogEntity(
                id: logId,
                date: date,
                mitTitle: logData['mit_title'],
                mitCompleted: logData['mit_completed'] ?? false,
              ),
            );
          }
        } else {
          logId = await database.dailyLogDao.insertLog(
            DailyLogEntity(
              date: date,
              mitTitle: logData['mit_title'],
              mitCompleted: logData['mit_completed'] ?? false,
            ),
          );
        }

        // Import Notes
        if (logData['notes'] != null) {
          final notes = (logData['notes'] as List).cast<String>();
          for (var content in notes) {
            await database.dailyLogDao.insertNote(
              DailyNoteEntity(dailyLogId: logId, content: content),
            );
          }
        }
      }
    }
  }
}
