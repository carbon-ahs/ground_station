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

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 2,
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
  Future<void> insertHabit(HabitEntity habit) async {
    await _habitEntityInsertionAdapter.insert(habit, OnConflictStrategy.abort);
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
