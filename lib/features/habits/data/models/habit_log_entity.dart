import 'package:floor/floor.dart';
import 'habit_entity.dart';

@Entity(
  tableName: 'habit_logs',
  foreignKeys: [
    ForeignKey(
      childColumns: ['habitId'],
      parentColumns: ['id'],
      entity: HabitEntity,
      onDelete: ForeignKeyAction.cascade,
    )
  ],
)
class HabitLogEntity {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final int habitId;
  final int timestamp; // Completion time

  HabitLogEntity({
    this.id,
    required this.habitId,
    required this.timestamp,
  });
}
