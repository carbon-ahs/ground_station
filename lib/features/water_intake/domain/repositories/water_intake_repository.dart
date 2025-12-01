import '../entities/water_intake.dart';

abstract class WaterIntakeRepository {
  Future<WaterIntake?> getWaterIntakeForDate(DateTime date);
  Future<void> incrementWaterIntake(DateTime date);
  Future<void> decrementWaterIntake(DateTime date);
  Future<void> resetWaterIntake(DateTime date);
  Future<List<WaterIntake>> getWaterIntakeHistory(int daysBack);
}
