import '../../../../core/database/app_database.dart';
import '../models/water_intake_entity.dart';

abstract class WaterIntakeLocalDataSource {
  Future<WaterIntakeEntity?> getWaterIntakeForDate(String date);
  Future<void> insertOrUpdateWaterIntake(WaterIntakeEntity entity);
  Future<void> deleteWaterIntakeForDate(String date);
  Future<List<WaterIntakeEntity>> getWaterIntakeHistory(int limit);
}

class WaterIntakeLocalDataSourceImpl implements WaterIntakeLocalDataSource {
  final AppDatabase database;

  WaterIntakeLocalDataSourceImpl(this.database);

  @override
  Future<WaterIntakeEntity?> getWaterIntakeForDate(String date) {
    return database.waterIntakeDao.getWaterIntakeForDate(date);
  }

  @override
  Future<void> insertOrUpdateWaterIntake(WaterIntakeEntity entity) {
    return database.waterIntakeDao.insertWaterIntake(entity);
  }

  @override
  Future<void> deleteWaterIntakeForDate(String date) {
    return database.waterIntakeDao.deleteWaterIntakeForDate(date);
  }

  @override
  Future<List<WaterIntakeEntity>> getWaterIntakeHistory(int limit) {
    return database.waterIntakeDao.getWaterIntakeHistory(limit);
  }
}
