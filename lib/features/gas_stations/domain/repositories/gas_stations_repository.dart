import 'package:gasonera/features/gas_stations/domain/entities/gas_station.dart';

abstract interface class GasStationsRepository {
  Future<List<GasStation>> getStationsInBounds({
    required double minLat,
    required double maxLat,
    required double minLng,
    required double maxLng,
  });
}