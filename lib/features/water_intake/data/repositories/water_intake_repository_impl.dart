import '../../domain/entities/water_intake.dart';
import '../../domain/repositories/water_intake_repository.dart';
import '../datasources/water_intake_local_data_source.dart';
import '../models/water_intake_entity.dart';
import 'package:intl/intl.dart';

class WaterIntakeRepositoryImpl implements WaterIntakeRepository {
  final WaterIntakeLocalDataSource dataSource;

  WaterIntakeRepositoryImpl(this.dataSource);

  String _formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  WaterIntake _toEntity(WaterIntakeEntity entity) {
    return WaterIntake(
      id: entity.id,
      date: DateTime.parse(entity.date),
      glassCount: entity.glassCount,
    );
  }

  @override
  Future<WaterIntake?> getWaterIntakeForDate(DateTime date) async {
    final dateStr = _formatDate(date);
    final entity = await dataSource.getWaterIntakeForDate(dateStr);
    if (entity == null) return null;
    return _toEntity(entity);
  }

  @override
  Future<void> incrementWaterIntake(DateTime date) async {
    final dateStr = _formatDate(date);
    final existing = await dataSource.getWaterIntakeForDate(dateStr);

    if (existing == null) {
      await dataSource.insertOrUpdateWaterIntake(
        WaterIntakeEntity(date: dateStr, glassCount: 1),
      );
    } else {
      await dataSource.insertOrUpdateWaterIntake(
        WaterIntakeEntity(
          id: existing.id,
          date: dateStr,
          glassCount: existing.glassCount + 1,
        ),
      );
    }
  }

  @override
  Future<void> decrementWaterIntake(DateTime date) async {
    final dateStr = _formatDate(date);
    final existing = await dataSource.getWaterIntakeForDate(dateStr);

    if (existing != null && existing.glassCount > 0) {
      await dataSource.insertOrUpdateWaterIntake(
        WaterIntakeEntity(
          id: existing.id,
          date: dateStr,
          glassCount: existing.glassCount - 1,
        ),
      );
    }
  }

  @override
  Future<void> resetWaterIntake(DateTime date) async {
    final dateStr = _formatDate(date);
    await dataSource.deleteWaterIntakeForDate(dateStr);
  }

  @override
  Future<List<WaterIntake>> getWaterIntakeHistory(int daysBack) async {
    final entities = await dataSource.getWaterIntakeHistory(daysBack);
    return entities.map((entity) => _toEntity(entity)).toList();
  }
}
