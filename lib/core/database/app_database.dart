import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import '../../features/habits/data/models/habit_entity.dart';
import '../../features/habits/data/models/habit_log_entity.dart';
import 'habit_dao.dart';
import 'habit_log_dao.dart';

part 'app_database.g.dart';

@Database(version: 1, entities: [HabitEntity, HabitLogEntity])
abstract class AppDatabase extends FloorDatabase {
  HabitDao get habitDao;
  HabitLogDao get habitLogDao;
}
