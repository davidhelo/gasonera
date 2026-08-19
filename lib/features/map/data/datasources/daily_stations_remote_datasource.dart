import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gasonera/features/map/data/models/gas_station_model.dart';
import 'package:gasonera/features/map/domain/entities/gas_station.dart';
import 'package:gasonera/core/supabase_client_provider.dart';

class DailyStationsRemoteDataSource {
  final Ref _ref;

  DailyStationsRemoteDataSource(this._ref);

   // Access Supabase client via provider
  SupabaseClient get _client => _ref.read(supabaseClientProvider);

  /// Fetches daily gas stations from Supabase table
  Future<List<GasStation>> fetchDailyStations() async {
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
}