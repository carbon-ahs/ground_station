import '../entities/sleep_record.dart';

abstract class SleepRepository {
  Future<SleepRecord?> getSleepForDate(DateTime date);
  Future<void> updateSleepHours(DateTime date, double hours);
  Future<List<SleepRecord>> getSleepHistory(int daysBack);
}
