import '../../data/datasources/habit_local_data_source.dart';
import '../../data/models/habit_entity.dart';
import '../../data/models/habit_log_entity.dart';
import '../../domain/entities/habit.dart';
import '../../domain/repositories/habit_repository.dart';

class HabitRepositoryImpl implements HabitRepository {
  final HabitLocalDataSource localDataSource;

  HabitRepositoryImpl(this.localDataSource);

  @override
  Future<List<Habit>> getHabits() async {
    final entities = await localDataSource.getHabits();
    final habits = <Habit>[];

    final now = DateTime.now();
    final startOfDay = DateTime(
      now.year,
      now.month,
      now.day,
    ).millisecondsSinceEpoch;
    final endOfDay = DateTime(
      now.year,
      now.month,
      now.day,
      23,
      59,
      59,
    ).millisecondsSinceEpoch;

    for (var e in entities) {
      final logs = await localDataSource.getHabitLogs(e.id!);
      final isCompletedToday = logs.any(
        (log) => log.timestamp >= startOfDay && log.timestamp <= endOfDay,
      );

      // Calculate current streak
      final streak = _calculateStreak(logs, now);

      habits.add(
        Habit(
          id: e.id,
          title: e.title,
          description: e.description,
          createdAt: DateTime.fromMillisecondsSinceEpoch(e.createdAtMillis),
          isCompletedToday: isCompletedToday,
          currentStreak: streak,
        ),
      );
    }
    return habits;
  }

  int _calculateStreak(List<HabitLogEntity> logs, DateTime referenceDate) {
    if (logs.isEmpty) return 0;

    // Sort logs by date (most recent first)
    final sortedLogs = logs.toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));

    // Group logs by day
    final logsByDay = <String, bool>{};
    for (var log in sortedLogs) {
      final date = DateTime.fromMillisecondsSinceEpoch(log.timestamp);
      final dayKey = '${date.year}-${date.month}-${date.day}';
      logsByDay[dayKey] = true;
    }

    // Calculate streak starting from reference date
    int streak = 0;
    DateTime checkDate = DateTime(
      referenceDate.year,
      referenceDate.month,
      referenceDate.day,
    );

    // Check if today is completed, if not start from yesterday
    final todayKey = '${checkDate.year}-${checkDate.month}-${checkDate.day}';
    if (!logsByDay.containsKey(todayKey)) {
      checkDate = checkDate.subtract(const Duration(days: 1));
    }

    // Count consecutive days backwards
    while (true) {
      final dayKey = '${checkDate.year}-${checkDate.month}-${checkDate.day}';
      if (logsByDay.containsKey(dayKey)) {
        streak++;
        checkDate = checkDate.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }

    return streak;
  }

  @override
  Future<void> addHabit(Habit habit) async {
    final entity = HabitEntity(
      title: habit.title,
      description: habit.description,
      createdAtMillis: habit.createdAt.millisecondsSinceEpoch,
    );
    await localDataSource.addHabit(entity);
  }

  @override
  Future<void> updateHabit(Habit habit) async {
    if (habit.id == null) return;
    final entity = HabitEntity(
      id: habit.id,
      title: habit.title,
      description: habit.description,
      createdAtMillis: habit.createdAt.millisecondsSinceEpoch,
    );
    await localDataSource.updateHabit(entity);
  }

  @override
  Future<void> deleteHabit(int id) async {
    await localDataSource.deleteHabit(id);
  }

  @override
  Future<void> toggleCompletion(int habitId, DateTime date) async {
    final startOfDay = DateTime(
      date.year,
      date.month,
      date.day,
    ).millisecondsSinceEpoch;
    final endOfDay = DateTime(
      date.year,
      date.month,
      date.day,
      23,
      59,
      59,
    ).millisecondsSinceEpoch;

    final logs = await localDataSource.getHabitLogs(habitId);
    final todayLog = logs
        .where(
          (log) => log.timestamp >= startOfDay && log.timestamp <= endOfDay,
        )
        .firstOrNull;

    if (todayLog != null) {
      await localDataSource.deleteHabitLog(todayLog);
    } else {
      await localDataSource.addHabitLog(
        HabitLogEntity(
          habitId: habitId,
          timestamp: date.millisecondsSinceEpoch,
        ),
      );
    }
  }
}
