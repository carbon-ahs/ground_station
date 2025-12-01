import 'package:floor/floor.dart';
import 'daily_log_entity.dart';

@Entity(
  tableName: 'daily_notes',
  foreignKeys: [
    ForeignKey(
      childColumns: ['daily_log_id'],
      parentColumns: ['id'],
      entity: DailyLogEntity,
      onDelete: ForeignKeyAction.cascade,
    ),
  ],
)
class DailyNoteEntity {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  @ColumnInfo(name: 'daily_log_id')
  final int dailyLogId;

  @ColumnInfo(name: 'content')
  final String content;

  DailyNoteEntity({this.id, required this.dailyLogId, required this.content});
}
