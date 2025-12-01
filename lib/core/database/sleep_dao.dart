import 'package:floor/floor.dart';
import '../../features/sleep/data/models/sleep_record_entity.dart';

@dao
abstract class SleepDao {
  @Query('SELECT * FROM sleep_records WHERE date = :date')
  Future<SleepRecordEntity?> getSleepForDate(String date);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertSleep(SleepRecordEntity entity);

  @Update()
  Future<void> updateSleep(SleepRecordEntity entity);

  @Query('DELETE FROM sleep_records WHERE date = :date')
  Future<void> deleteSleepForDate(String date);

  @Query('SELECT * FROM sleep_records ORDER BY date DESC LIMIT :limit')
  Future<List<SleepRecordEntity>> getSleepHistory(int limit);
}
