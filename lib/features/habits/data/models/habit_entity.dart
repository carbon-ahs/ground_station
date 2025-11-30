import 'package:floor/floor.dart';

@entity
class HabitEntity {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String title;
  final String description;
  final int createdAtMillis;

  HabitEntity({
    this.id,
    required this.title,
    this.description = '',
    required this.createdAtMillis,
  });
}
