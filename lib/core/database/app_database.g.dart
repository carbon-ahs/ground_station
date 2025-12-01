// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  HabitDao? _habitDaoInstance;

  HabitLogDao? _habitLogDaoInstance;

  WaterIntakeDao? _waterIntakeDaoInstance;

  SleepDao? _sleepDaoInstance;

  DailyLogDao? _dailyLogDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 4,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `HabitEntity` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `title` TEXT NOT NULL, `description` TEXT NOT NULL, `createdAtMillis` INTEGER NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `habit_logs` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `habitId` INTEGER NOT NULL, `timestamp` INTEGER NOT NULL, FOREIGN KEY (`habitId`) REFERENCES `HabitEntity` (`id`) ON UPDATE NO ACTION ON DELETE CASCADE)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `WaterIntakeEntity` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `date` TEXT NOT NULL, `glassCount` INTEGER NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `sleep_records` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `date` TEXT NOT NULL, `hours` REAL NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `daily_logs` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `date` TEXT NOT NULL, `mit_title` TEXT, `mit_completed` INTEGER NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `daily_notes` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `daily_log_id` INTEGER NOT NULL, `content` TEXT NOT NULL, FOREIGN KEY (`daily_log_id`) REFERENCES `daily_logs` (`id`) ON UPDATE NO ACTION ON DELETE CASCADE)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  HabitDao get habitDao {
    return _habitDaoInstance ??= _$HabitDao(database, changeListener);
  }

  @override
  HabitLogDao get habitLogDao {
    return _habitLogDaoInstance ??= _$HabitLogDao(database, changeListener);
  }

  @override
  WaterIntakeDao get waterIntakeDao {
    return _waterIntakeDaoInstance ??=
        _$WaterIntakeDao(database, changeListener);
  }

  @override
  SleepDao get sleepDao {
    return _sleepDaoInstance ??= _$SleepDao(database, changeListener);
  }

  @override
  DailyLogDao get dailyLogDao {
    return _dailyLogDaoInstance ??= _$DailyLogDao(database, changeListener);
  }
}

class _$HabitDao extends HabitDao {
  _$HabitDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _habitEntityInsertionAdapter = InsertionAdapter(
            database,
            'HabitEntity',
            (HabitEntity item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'description': item.description,
                  'createdAtMillis': item.createdAtMillis
                }),
        _habitEntityUpdateAdapter = UpdateAdapter(
            database,
            'HabitEntity',
            ['id'],
            (HabitEntity item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'description': item.description,
                  'createdAtMillis': item.createdAtMillis
                }),
        _habitEntityDeletionAdapter = DeletionAdapter(
            database,
            'HabitEntity',
            ['id'],
            (HabitEntity item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'description': item.description,
                  'createdAtMillis': item.createdAtMillis
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<HabitEntity> _habitEntityInsertionAdapter;

  final UpdateAdapter<HabitEntity> _habitEntityUpdateAdapter;

  final DeletionAdapter<HabitEntity> _habitEntityDeletionAdapter;

  @override
  Future<List<HabitEntity>> findAllHabits() async {
    return _queryAdapter.queryList('SELECT * FROM HabitEntity',
        mapper: (Map<String, Object?> row) => HabitEntity(
            id: row['id'] as int?,
            title: row['title'] as String,
            description: row['description'] as String,
            createdAtMillis: row['createdAtMillis'] as int));
  }

  @override
  Future<HabitEntity?> findHabitById(int id) async {
    return _queryAdapter.query('SELECT * FROM HabitEntity WHERE id = ?1',
        mapper: (Map<String, Object?> row) => HabitEntity(
            id: row['id'] as int?,
            title: row['title'] as String,
            description: row['description'] as String,
            createdAtMillis: row['createdAtMillis'] as int),
        arguments: [id]);
  }

  @override
  Future<int> insertHabit(HabitEntity habit) {
    return _habitEntityInsertionAdapter.insertAndReturnId(
        habit, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateHabit(HabitEntity habit) async {
    await _habitEntityUpdateAdapter.update(habit, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteHabit(HabitEntity habit) async {
    await _habitEntityDeletionAdapter.delete(habit);
  }
}

class _$HabitLogDao extends HabitLogDao {
  _$HabitLogDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _habitLogEntityInsertionAdapter = InsertionAdapter(
            database,
            'habit_logs',
            (HabitLogEntity item) => <String, Object?>{
                  'id': item.id,
                  'habitId': item.habitId,
                  'timestamp': item.timestamp
                }),
        _habitLogEntityDeletionAdapter = DeletionAdapter(
            database,
            'habit_logs',
            ['id'],
            (HabitLogEntity item) => <String, Object?>{
                  'id': item.id,
                  'habitId': item.habitId,
                  'timestamp': item.timestamp
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<HabitLogEntity> _habitLogEntityInsertionAdapter;

  final DeletionAdapter<HabitLogEntity> _habitLogEntityDeletionAdapter;

  @override
  Future<List<HabitLogEntity>> findLogsByHabitId(int habitId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM habit_logs WHERE habitId = ?1',
        mapper: (Map<String, Object?> row) => HabitLogEntity(
            id: row['id'] as int?,
            habitId: row['habitId'] as int,
            timestamp: row['timestamp'] as int),
        arguments: [habitId]);
  }

  @override
  Future<void> deleteLogsByHabitId(int habitId) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM habit_logs WHERE habitId = ?1',
        arguments: [habitId]);
  }

  @override
  Future<void> insertLog(HabitLogEntity log) async {
    await _habitLogEntityInsertionAdapter.insert(log, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteLog(HabitLogEntity log) async {
    await _habitLogEntityDeletionAdapter.delete(log);
  }
}

class _$WaterIntakeDao extends WaterIntakeDao {
  _$WaterIntakeDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _waterIntakeEntityInsertionAdapter = InsertionAdapter(
            database,
            'WaterIntakeEntity',
            (WaterIntakeEntity item) => <String, Object?>{
                  'id': item.id,
                  'date': item.date,
                  'glassCount': item.glassCount
                }),
        _waterIntakeEntityUpdateAdapter = UpdateAdapter(
            database,
            'WaterIntakeEntity',
            ['id'],
            (WaterIntakeEntity item) => <String, Object?>{
                  'id': item.id,
                  'date': item.date,
                  'glassCount': item.glassCount
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<WaterIntakeEntity> _waterIntakeEntityInsertionAdapter;

  final UpdateAdapter<WaterIntakeEntity> _waterIntakeEntityUpdateAdapter;

  @override
  Future<WaterIntakeEntity?> getWaterIntakeForDate(String date) async {
    return _queryAdapter.query(
        'SELECT * FROM WaterIntakeEntity WHERE date = ?1',
        mapper: (Map<String, Object?> row) => WaterIntakeEntity(
            id: row['id'] as int?,
            date: row['date'] as String,
            glassCount: row['glassCount'] as int),
        arguments: [date]);
  }

  @override
  Future<void> deleteWaterIntakeForDate(String date) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM WaterIntakeEntity WHERE date = ?1',
        arguments: [date]);
  }

  @override
  Future<List<WaterIntakeEntity>> getWaterIntakeHistory(int limit) async {
    return _queryAdapter.queryList(
        'SELECT * FROM WaterIntakeEntity ORDER BY date DESC LIMIT ?1',
        mapper: (Map<String, Object?> row) => WaterIntakeEntity(
            id: row['id'] as int?,
            date: row['date'] as String,
            glassCount: row['glassCount'] as int),
        arguments: [limit]);
  }

  @override
  Future<void> insertWaterIntake(WaterIntakeEntity entity) async {
    await _waterIntakeEntityInsertionAdapter.insert(
        entity, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateWaterIntake(WaterIntakeEntity entity) async {
    await _waterIntakeEntityUpdateAdapter.update(
        entity, OnConflictStrategy.abort);
  }
}

class _$SleepDao extends SleepDao {
  _$SleepDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _sleepRecordEntityInsertionAdapter = InsertionAdapter(
            database,
            'sleep_records',
            (SleepRecordEntity item) => <String, Object?>{
                  'id': item.id,
                  'date': item.date,
                  'hours': item.hours
                }),
        _sleepRecordEntityUpdateAdapter = UpdateAdapter(
            database,
            'sleep_records',
            ['id'],
            (SleepRecordEntity item) => <String, Object?>{
                  'id': item.id,
                  'date': item.date,
                  'hours': item.hours
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<SleepRecordEntity> _sleepRecordEntityInsertionAdapter;

  final UpdateAdapter<SleepRecordEntity> _sleepRecordEntityUpdateAdapter;

  @override
  Future<SleepRecordEntity?> getSleepForDate(String date) async {
    return _queryAdapter.query('SELECT * FROM sleep_records WHERE date = ?1',
        mapper: (Map<String, Object?> row) => SleepRecordEntity(
            id: row['id'] as int?,
            date: row['date'] as String,
            hours: row['hours'] as double),
        arguments: [date]);
  }

  @override
  Future<void> deleteSleepForDate(String date) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM sleep_records WHERE date = ?1',
        arguments: [date]);
  }

  @override
  Future<List<SleepRecordEntity>> getSleepHistory(int limit) async {
    return _queryAdapter.queryList(
        'SELECT * FROM sleep_records ORDER BY date DESC LIMIT ?1',
        mapper: (Map<String, Object?> row) => SleepRecordEntity(
            id: row['id'] as int?,
            date: row['date'] as String,
            hours: row['hours'] as double),
        arguments: [limit]);
  }

  @override
  Future<void> insertSleep(SleepRecordEntity entity) async {
    await _sleepRecordEntityInsertionAdapter.insert(
        entity, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateSleep(SleepRecordEntity entity) async {
    await _sleepRecordEntityUpdateAdapter.update(
        entity, OnConflictStrategy.abort);
  }
}

class _$DailyLogDao extends DailyLogDao {
  _$DailyLogDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _dailyLogEntityInsertionAdapter = InsertionAdapter(
            database,
            'daily_logs',
            (DailyLogEntity item) => <String, Object?>{
                  'id': item.id,
                  'date': item.date,
                  'mit_title': item.mitTitle,
                  'mit_completed': item.mitCompleted ? 1 : 0
                }),
        _dailyNoteEntityInsertionAdapter = InsertionAdapter(
            database,
            'daily_notes',
            (DailyNoteEntity item) => <String, Object?>{
                  'id': item.id,
                  'daily_log_id': item.dailyLogId,
                  'content': item.content
                }),
        _dailyLogEntityUpdateAdapter = UpdateAdapter(
            database,
            'daily_logs',
            ['id'],
            (DailyLogEntity item) => <String, Object?>{
                  'id': item.id,
                  'date': item.date,
                  'mit_title': item.mitTitle,
                  'mit_completed': item.mitCompleted ? 1 : 0
                }),
        _dailyNoteEntityDeletionAdapter = DeletionAdapter(
            database,
            'daily_notes',
            ['id'],
            (DailyNoteEntity item) => <String, Object?>{
                  'id': item.id,
                  'daily_log_id': item.dailyLogId,
                  'content': item.content
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<DailyLogEntity> _dailyLogEntityInsertionAdapter;

  final InsertionAdapter<DailyNoteEntity> _dailyNoteEntityInsertionAdapter;

  final UpdateAdapter<DailyLogEntity> _dailyLogEntityUpdateAdapter;

  final DeletionAdapter<DailyNoteEntity> _dailyNoteEntityDeletionAdapter;

  @override
  Future<List<DailyLogEntity>> getAllLogs() async {
    return _queryAdapter.queryList('SELECT * FROM daily_logs',
        mapper: (Map<String, Object?> row) => DailyLogEntity(
            id: row['id'] as int?,
            date: row['date'] as String,
            mitTitle: row['mit_title'] as String?,
            mitCompleted: (row['mit_completed'] as int) != 0));
  }

  @override
  Future<DailyLogEntity?> getLogForDate(String date) async {
    return _queryAdapter.query('SELECT * FROM daily_logs WHERE date = ?1',
        mapper: (Map<String, Object?> row) => DailyLogEntity(
            id: row['id'] as int?,
            date: row['date'] as String,
            mitTitle: row['mit_title'] as String?,
            mitCompleted: (row['mit_completed'] as int) != 0),
        arguments: [date]);
  }

  @override
  Future<List<DailyNoteEntity>> getNotesForLog(int logId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM daily_notes WHERE daily_log_id = ?1',
        mapper: (Map<String, Object?> row) => DailyNoteEntity(
            id: row['id'] as int?,
            dailyLogId: row['daily_log_id'] as int,
            content: row['content'] as String),
        arguments: [logId]);
  }

  @override
  Future<void> deleteNoteById(int id) async {
    await _queryAdapter.queryNoReturn('DELETE FROM daily_notes WHERE id = ?1',
        arguments: [id]);
  }

  @override
  Future<int> insertLog(DailyLogEntity log) {
    return _dailyLogEntityInsertionAdapter.insertAndReturnId(
        log, OnConflictStrategy.replace);
  }

  @override
  Future<int> insertNote(DailyNoteEntity note) {
    return _dailyNoteEntityInsertionAdapter.insertAndReturnId(
        note, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateLog(DailyLogEntity log) async {
    await _dailyLogEntityUpdateAdapter.update(log, OnConflictStrategy.replace);
  }

  @override
  Future<void> deleteNote(DailyNoteEntity note) async {
    await _dailyNoteEntityDeletionAdapter.delete(note);
  }
}
