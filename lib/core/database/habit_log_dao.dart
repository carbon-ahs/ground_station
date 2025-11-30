import 'package:floor/floor.dart';
import '../../features/habits/data/models/habit_log_entity.dart';

@dao
abstract class HabitLogDao {
  @Query('SELECT * FROM habit_logs WHERE habitId = :habitId')
  Future<List<HabitLogEntity>> findLogsByHabitId(int habitId);

  @insert
  Future<void> insertLog(HabitLogEntity log);

  @delete
  Future<void> deleteLog(HabitLogEntity log);

  @Query('DELETE FROM habit_logs WHERE habitId = :habitId')
  Future<void> deleteLogsByHabitId(int habitId);
}
