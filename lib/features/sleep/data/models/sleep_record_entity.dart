import 'package:floor/floor.dart';

@Entity(tableName: 'sleep_records')
class SleepRecordEntity {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final String date; // Format: YYYY-MM-DD
  final double hours;

  SleepRecordEntity({this.id, required this.date, required this.hours});
}
