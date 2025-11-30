import 'package:equatable/equatable.dart';

class Habit extends Equatable {
  final int? id;
  final String title;
  final String description;
  final DateTime createdAt;
  final bool isCompletedToday;
  final int currentStreak; // Consecutive days of completion

  const Habit({
    this.id,
    required this.title,
    this.description = '',
    required this.createdAt,
    this.isCompletedToday = false,
    this.currentStreak = 0,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    createdAt,
    isCompletedToday,
    currentStreak,
  ];
}
