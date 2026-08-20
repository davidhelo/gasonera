import 'package:gasonera/core/database/app_database.dart';
import 'package:gasonera/features/gas_stations/data/models/gas_station_model.dart';

class StationsRepository {
  final AppDatabase _appDb;

  StationsRepository({required AppDatabase localDb})  : _appDb = localDb;

  Future<List<GasStationModel>> getStationsInBounds({
    required double minLat,
    required double maxLat,
    required double minLng,
    required double maxLng,
  }) async {
    final db = await _appDb.database;
    
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
        SELECT place_id, name, cre_id, latitude, longitude, regular_price, premium_price, diesel_price, price_date
        FROM daily_gas_stations
        WHERE (latitude BETWEEN ? AND ?)
          AND (longitude BETWEEN ? AND ?);
      ''',
      [minLat, maxLat, minLng, maxLng]
    );
    
    return maps.map((map) => GasStationModel.fromSqfliteMap(map)).toList();
  }
}