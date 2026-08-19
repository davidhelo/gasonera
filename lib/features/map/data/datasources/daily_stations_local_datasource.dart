import 'package:sqflite/sqflite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gasonera/core/database/app_database.dart';
import 'package:gasonera/core/database/sqlite_provider.dart';
import 'package:gasonera/features/map/data/models/gas_station_model.dart';

class DailyStationsLocalDataSource {
  final Ref _ref;

  DailyStationsLocalDataSource(this._ref);

  AppDatabase get _appDb => _ref.read(appDatabaseProvider);

  // Get all cached gas stations
  Future<List<GasStationModel>> getCachedStations() async {
    final db = await _appDb.database;
    final List<Map<String, dynamic>> stationsMaps = await db.query('daily_gas_stations');

    return stationsMaps.map((stationMap) => GasStationModel.fromSqfliteMap(stationMap)).toList();
  }

  // Replace cached gas stations in a single batch transaction
  Future<void> cacheStations(List<GasStationModel> stations) async {
    final db = await _appDb.database;
    final nowMs = DateTime.now().millisecondsSinceEpoch;

    final batch = db.batch();

    // Clear old data
    batch.delete('daily_gas_stations');

    // Insert updated records
    for (final station in stations) {
      batch.insert(
        'daily_gas_stations',
        station.toSqfliteMap(nowMs),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
  }

  // Get the timestamp of when the last cache update was executed
  Future<DateTime?> getLastCacheTime() async {
    final db = await _appDb.database;
    final List<Map<String, dynamic>> result = await db.query(
      'daily_gas_stations',
      columns: ['last_updated'],
      orderBy: 'last_updated DESC',
      limit: 1,
    );

    if (result.isNotEmpty) {
      final lastMs = result.first['last_updated'] as int;
      return DateTime.fromMillisecondsSinceEpoch(lastMs);
    }
    return null;
  }
}