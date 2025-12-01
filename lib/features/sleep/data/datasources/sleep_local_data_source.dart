import '../../../../core/database/app_database.dart';
import '../models/sleep_record_entity.dart';

abstract class SleepLocalDataSource {
  Future<SleepRecordEntity?> getSleepForDate(String date);
  Future<void> insertOrUpdateSleep(SleepRecordEntity entity);
  Future<void> deleteSleepForDate(String date);
  Future<List<SleepRecordEntity>> getSleepHistory(int limit);
}

class SleepLocalDataSourceImpl implements SleepLocalDataSource {
  final AppDatabase database;

  SleepLocalDataSourceImpl(this.database);

  @override
  Future<SleepRecordEntity?> getSleepForDate(String date) {
    return database.sleepDao.getSleepForDate(date);
  }

  @override
  Future<void> insertOrUpdateSleep(SleepRecordEntity entity) {
    return database.sleepDao.insertSleep(entity);
  }

  @override
  Future<void> deleteSleepForDate(String date) {
    return database.sleepDao.deleteSleepForDate(date);
  }

  @override
  Future<List<SleepRecordEntity>> getSleepHistory(int limit) {
    return database.sleepDao.getSleepHistory(limit);
  }
}
