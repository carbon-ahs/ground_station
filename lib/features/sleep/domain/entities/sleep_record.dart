import 'package:equatable/equatable.dart';

class SleepRecord extends Equatable {
  final int? id;
  final DateTime date;
  final double hours;

  const SleepRecord({this.id, required this.date, required this.hours});

  @override
  List<Object?> get props => [id, date, hours];
}
