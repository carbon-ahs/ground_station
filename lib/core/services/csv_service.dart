import 'dart:io';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import '../../features/habits/data/models/habit_entity.dart';
import '../../features/habits/data/models/habit_log_entity.dart';
import '../../features/habits/data/datasources/habit_local_data_source.dart';

class CSVService {
  final HabitLocalDataSource localDataSource;

  CSVService(this.localDataSource);

  Future<String> exportHabitsToCSV() async {
    final habits = await localDataSource.getHabits();
    final List<List<dynamic>> rows = [];

    // Header
    rows.add(['habit_id', 'title', 'description', 'created_at', 'log_date']);

    // Data
    for (var habit in habits) {
      final logs = await localDataSource.getHabitLogs(habit.id!);

      if (logs.isEmpty) {
        // Add habit without logs
        rows.add([
          habit.id,
          habit.title,
          habit.description,
          DateTime.fromMillisecondsSinceEpoch(
            habit.createdAtMillis,
          ).toIso8601String(),
          '',
        ]);
      } else {
        // Add habit with each log
        for (var log in logs) {
          rows.add([
            habit.id,
            habit.title,
            habit.description,
            DateTime.fromMillisecondsSinceEpoch(
              habit.createdAtMillis,
            ).toIso8601String(),
            DateTime.fromMillisecondsSinceEpoch(
              log.timestamp,
            ).toIso8601String(),
          ]);
        }
      }
    }

    final csv = const ListToCsvConverter().convert(rows);

    // Save to file
    final directory = await getApplicationDocumentsDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final file = File('${directory.path}/habits_export_$timestamp.csv');
    await file.writeAsString(csv);

    return file.path;
  }

  Future<void> importHabitsFromCSV(String filePath) async {
    final file = File(filePath);
    final csvString = await file.readAsString();
    final rows = const CsvToListConverter().convert(csvString);

    if (rows.isEmpty || rows.length == 1) return; // No data or only header

    final Map<int, HabitEntity> habitsMap = {};
    final Map<int, List<HabitLogEntity>> logsMap = {};

    // Skip header row
    for (int i = 1; i < rows.length; i++) {
      final row = rows[i];
      if (row.length < 5) continue;

      final habitId = row[0] as int;
      final title = row[1] as String;
      final description = row[2] as String;
      final createdAt = DateTime.parse(row[3] as String);
      final logDateStr = row[4] as String;

      // Create or update habit
      if (!habitsMap.containsKey(habitId)) {
        habitsMap[habitId] = HabitEntity(
          title: title,
          description: description,
          createdAtMillis: createdAt.millisecondsSinceEpoch,
        );
        logsMap[habitId] = [];
      }

      // Add log if exists
      if (logDateStr.isNotEmpty) {
        final logDate = DateTime.parse(logDateStr);
        logsMap[habitId]!.add(
          HabitLogEntity(
            habitId: habitId,
            timestamp: logDate.millisecondsSinceEpoch,
          ),
        );
      }
    }

    // Import habits and logs
    for (var entry in habitsMap.entries) {
      await localDataSource.addHabit(entry.value);

      // Get all habits to find the newly added one
      final allHabits = await localDataSource.getHabits();
      final newHabit = allHabits.firstWhere(
        (h) =>
            h.title == entry.value.title &&
            h.description == entry.value.description,
      );

      // Add logs for this habit
      for (var log in logsMap[entry.key]!) {
        await localDataSource.addHabitLog(
          HabitLogEntity(habitId: newHabit.id!, timestamp: log.timestamp),
        );
      }
    }
  }
}
