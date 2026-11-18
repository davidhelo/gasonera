import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gasonera/core/supabase/supabase_client_provider.dart';
import 'package:gasonera/core/database/app_database.dart';
import 'package:gasonera/features/gas_stations/data/models/gas_station_model.dart';

final dailyStationsSyncServiceProvider = Provider<DailyStationsSyncService>((ref) {
  final appDb = ref.watch(appDatabaseProvider);
  final client = ref.watch(supabaseClientProvider);
  return DailyStationsSyncService(localDb: appDb, apiClient: client);
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
      debugPrint('Daily price_date sync started...');

      // Get the latest price_date in local cache
      final String? latestLocalPriceDate = await _getLatestLocalPriceDate();

      List<GasStationModel> remoteStations;

      if (latestLocalPriceDate == null) {
        debugPrint('Local database is empty. Fetching all stations...');
        remoteStations = await fetchAllStations();
      } else {
        // Fetch stations with a price_date newer than local records
        debugPrint('Local latest price_date is $latestLocalPriceDate. Fetching newer prices...');
        remoteStations = await fetchStationsNewerThan(latestLocalPriceDate);
      }

      if (remoteStations.isNotEmpty) {
        // Upsert into SQLite
        await cacheStations(remoteStations);
        debugPrint('Sync completed successfully. Processed ${remoteStations.length} stations.');
      } else {
        debugPrint('Local prices are already up to date!');
      }
    } catch (e) {
      debugPrint('Sync failed: $e');
    }
  }

  // Query the maximum price_date string from local cache
  Future<String?> _getLatestLocalPriceDate() async {
    final db = await _appDb.database;
    final result = await db.query(
      'daily_gas_stations',
      columns: ['price_date'],
      where: 'price_date IS NOT NULL',
      orderBy: 'price_date DESC',
      limit: 1,
    );

    if (result.isNotEmpty) {
      return result.first['price_date'] as String?;
    }
    return null;
  }

  Future<List<GasStationModel>> fetchAllStations() async {
    final response = await _client.from('daily_app_stations_info').select();
    return (response as List<dynamic>)
        .map((json) => GasStationModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  // Fetch records newer than the local max price_date
  Future<List<GasStationModel>> fetchStationsNewerThan(String localPriceDate) async {
    final response = await _client
        .from('daily_app_stations_info')
        .select()
        .gt('price_date', localPriceDate);

    return (response as List<dynamic>)
        .map((json) => GasStationModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<void> cacheStations(List<GasStationModel> stations) async {
    final db = await _appDb.database;
    final nowMs = DateTime.now().millisecondsSinceEpoch;
    final batch = db.batch();

    for (final station in stations) {
      batch.insert(
        'daily_gas_stations',
        station.toSqfliteMap(nowMs),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
  }
}