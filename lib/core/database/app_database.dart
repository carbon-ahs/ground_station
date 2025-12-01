import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import '../../features/habits/data/models/habit_entity.dart';
import '../../features/habits/data/models/habit_log_entity.dart';
import '../../features/water_intake/data/models/water_intake_entity.dart';
import '../../features/sleep/data/models/sleep_record_entity.dart';
import '../../features/daily_log/data/models/daily_log_entity.dart';
import '../../features/daily_log/data/models/daily_note_entity.dart';

import 'habit_dao.dart';
import 'habit_log_dao.dart';
import 'water_intake_dao.dart';
import 'sleep_dao.dart';
import 'daily_log_dao.dart';

part 'app_database.g.dart';

@Database(
  version: 4,
  entities: [
    HabitEntity,
    HabitLogEntity,
    WaterIntakeEntity,
    SleepRecordEntity,
    DailyLogEntity,
    DailyNoteEntity,
  ],
)
abstract class AppDatabase extends FloorDatabase {
  HabitDao get habitDao;
  HabitLogDao get habitLogDao;
  WaterIntakeDao get waterIntakeDao;
  SleepDao get sleepDao;
  DailyLogDao get dailyLogDao;
}
