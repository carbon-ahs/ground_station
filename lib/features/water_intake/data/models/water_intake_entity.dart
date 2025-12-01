import 'package:floor/floor.dart';

@entity
class WaterIntakeEntity {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String date; // YYYY-MM-DD format
  final int glassCount;

  WaterIntakeEntity({this.id, required this.date, required this.glassCount});
}
