import 'package:intl/intl.dart';
import '../../domain/entities/sleep_record.dart';
import '../../domain/repositories/sleep_repository.dart';
import '../datasources/sleep_local_data_source.dart';
import '../models/sleep_record_entity.dart';

class SleepRepositoryImpl implements SleepRepository {
  final SleepLocalDataSource dataSource;

  SleepRepositoryImpl(this.dataSource);

  String _formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  SleepRecord _toDomain(SleepRecordEntity entity) {
    return SleepRecord(
      id: entity.id,
      date: DateTime.parse(entity.date),
      hours: entity.hours,
    );
  }

  @override
  Future<SleepRecord?> getSleepForDate(DateTime date) async {
    final dateStr = _formatDate(date);
    final entity = await dataSource.getSleepForDate(dateStr);
    return entity != null ? _toDomain(entity) : null;
  }

  @override
  Future<void> updateSleepHours(DateTime date, double hours) async {
    final dateStr = _formatDate(date);
    final existing = await dataSource.getSleepForDate(dateStr);

    final entity = SleepRecordEntity(
      id: existing?.id,
      date: dateStr,
      hours: hours,
    );

    await dataSource.insertOrUpdateSleep(entity);
  }

  @override
  Future<List<SleepRecord>> getSleepHistory(int daysBack) async {
    final entities = await dataSource.getSleepHistory(daysBack);
    return entities.map((e) => _toDomain(e)).toList();
  }
}
