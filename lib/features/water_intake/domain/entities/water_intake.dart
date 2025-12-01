import 'package:equatable/equatable.dart';

class WaterIntake extends Equatable {
  final int? id;
  final DateTime date;
  final int glassCount;

  const WaterIntake({this.id, required this.date, required this.glassCount});

  @override
  List<Object?> get props => [id, date, glassCount];
}
