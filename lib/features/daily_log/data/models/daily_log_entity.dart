import 'package:floor/floor.dart';

@Entity(tableName: 'daily_logs')
class DailyLogEntity {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  @ColumnInfo(name: 'date')
  final String date; // YYYY-MM-DD

  @ColumnInfo(name: 'mit_title')
  final String? mitTitle;

  @ColumnInfo(name: 'mit_completed')
  final bool mitCompleted;

  DailyLogEntity({
    this.id,
    required this.date,
    this.mitTitle,
    this.mitCompleted = false,
  });
}
