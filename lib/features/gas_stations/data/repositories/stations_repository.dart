import 'package:gasonera/core/database/app_database.dart';
import 'package:gasonera/features/gas_stations/data/models/gas_station_model.dart';
import 'package:gasonera/features/gas_stations/domain/entities/gas_station.dart';
import 'package:gasonera/features/gas_stations/domain/repositories/gas_stations_repository.dart';


class StationsRepository implements GasStationsRepository {
  final AppDatabase _appDb;

  StationsRepository({
    required AppDatabase localDb
    })  : _appDb = localDb;

  @override
  Future<List<GasStation>> getStationsInBounds({
    required double minLat,
    required double maxLat,
    required double minLng,
    required double maxLng,
  }) async {
    final db = await _appDb.database;
    
    final List<Map<String, dynamic>> stationsInBounds = await db.query(
      'daily_gas_stations',
      where: '''
        latitude BETWEEN ? AND ?
        AND longitude BETWEEN ? AND ?
      ''',
      whereArgs: [
        minLat,
        maxLat,
        minLng,
        maxLng,
      ],
    );
    
    return stationsInBounds.map((map) => GasStationModel.fromSqfliteMap(map)).toList();
  }
}