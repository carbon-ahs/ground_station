import 'package:floor/floor.dart';
import '../../features/habits/data/models/habit_entity.dart';

@dao
abstract class HabitDao {
  @Query('SELECT * FROM HabitEntity')
  Future<List<HabitEntity>> findAllHabits();

  @Query('SELECT * FROM HabitEntity WHERE id = :id')
  Future<HabitEntity?> findHabitById(int id);

  @insert
  Future<int> insertHabit(HabitEntity habit);

  @update
  Future<void> updateHabit(HabitEntity habit);

  @delete
  Future<void> deleteHabit(HabitEntity habit);
}
