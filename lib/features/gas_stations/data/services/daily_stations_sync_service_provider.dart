import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gasonera/core/supabase/supabase_client_provider.dart';
import 'package:gasonera/core/database/sqlite_provider.dart';
import 'package:gasonera/core/database/app_database.dart';

import 'package:gasonera/features/gas_stations/data/models/gas_station_model.dart';

// 1. Provide the SyncService instance
final dailyStationsSyncServiceProvider = Provider<DailyStationsSyncService>((ref) {
  // Retrieve app database and supabase client instances from their providers
  final appDb = ref.watch(appDatabaseProvider);
  final client = ref.watch(supabaseClientProvider);
  return DailyStationsSyncService(localDb: appDb, apiClient: client);
});

/// 2. Fires the background sync once when the provider is first read/initialized
final backgroundSyncTriggerProvider = Provider<void>((ref) {
  final syncService = ref.watch(dailyStationsSyncServiceProvider);
  
  // Execute asynchronously (fire-and-forget) so it doesn't block Riverpod initialization
  Future.microtask(() => syncService.syncDailyStations());
});

class DailyStationsSyncService {
  final AppDatabase _appDb;
  final SupabaseClient _client;

  DailyStationsSyncService({
    required AppDatabase localDb,
    required SupabaseClient apiClient,
  }) : _appDb = localDb,
        _client = apiClient;

  Future<void> syncDailyStations() async {
    try {
      print('Initial database sync started...');
      // 1. Check if local cache is from today
      final lastCacheTime = await getLastCacheTime();
      
      if (lastCacheTime ==  null || !_isToday(lastCacheTime)) {
        // 2. Cache is expired or missing -> Fetch fresh stations from Supabase
        final remoteStations = await fetchDailyStations();

        // 3. Persist fresh stations to SQLite in a batch operation
        await cacheStations(remoteStations);

        print('Initial database sync completed successfully.');
      } else {
        print('APP DATABASE IS UP TO DATE ALREADY!');
      }
    } catch (e) {
      print('Initial sync failed: $e');
    }
  }

  // Fetches daily gas stations from Supabase table
  Future<List<GasStationModel>> fetchDailyStations() async {
    try {
      final response = await _client
          .from('daily_app_stations_info')
          .select();

      final dataList = response as List<dynamic>;
      
      return dataList
          .map((json) => GasStationModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on PostgrestException catch (e) {
      throw Exception('Supabase fetch failed: ${e.message}');
    } catch (e) {
      throw Exception('Failed to connect to remote datasource: $e');
    }
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

  // Returns true if the provided DateTime matches today's calendar date
  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }
}