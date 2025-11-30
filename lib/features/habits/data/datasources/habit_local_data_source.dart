import '../../../../core/database/app_database.dart';
import '../../data/models/habit_entity.dart';
import '../../data/models/habit_log_entity.dart';

abstract class HabitLocalDataSource {
  Future<List<HabitEntity>> getHabits();
  Future<void> addHabit(HabitEntity habit);
  Future<void> updateHabit(HabitEntity habit);
  Future<void> deleteHabit(int id);
  Future<List<HabitLogEntity>> getHabitLogs(int habitId);
  Future<void> addHabitLog(HabitLogEntity log);
  Future<void> deleteHabitLog(HabitLogEntity log);
}

class HabitLocalDataSourceImpl implements HabitLocalDataSource {
  final AppDatabase database;

  HabitLocalDataSourceImpl(this.database);

  @override
  Future<List<HabitEntity>> getHabits() => database.habitDao.findAllHabits();

  @override
  Future<void> addHabit(HabitEntity habit) =>
      database.habitDao.insertHabit(habit);

  @override
  Future<void> updateHabit(HabitEntity habit) =>
      database.habitDao.updateHabit(habit);

  @override
  Future<void> deleteHabit(int id) async {
    final entity = await database.habitDao.findHabitById(id);
    if (entity != null) {
      await database.habitDao.deleteHabit(entity);
    }
  }

  @override
  Future<List<HabitLogEntity>> getHabitLogs(int habitId) =>
      database.habitLogDao.findLogsByHabitId(habitId);

  @override
  Future<void> addHabitLog(HabitLogEntity log) =>
      database.habitLogDao.insertLog(log);

  @override
  Future<void> deleteHabitLog(HabitLogEntity log) =>
      database.habitLogDao.deleteLog(log);
}
