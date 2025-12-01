import 'package:floor/floor.dart';
import '../../features/water_intake/data/models/water_intake_entity.dart';

@dao
abstract class WaterIntakeDao {
  @Query('SELECT * FROM WaterIntakeEntity WHERE date = :date')
  Future<WaterIntakeEntity?> getWaterIntakeForDate(String date);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertWaterIntake(WaterIntakeEntity entity);

  @Update()
  Future<void> updateWaterIntake(WaterIntakeEntity entity);

  @Query('DELETE FROM WaterIntakeEntity WHERE date = :date')
  Future<void> deleteWaterIntakeForDate(String date);

  @Query('SELECT * FROM WaterIntakeEntity ORDER BY date DESC LIMIT :limit')
  Future<List<WaterIntakeEntity>> getWaterIntakeHistory(int limit);
}
