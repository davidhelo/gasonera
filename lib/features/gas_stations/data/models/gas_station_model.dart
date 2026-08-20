import '../../domain/entities/gas_station.dart';

class GasStationModel extends GasStation {
  GasStationModel({
    required super.placeId,
    required super.name,
    required super.creId,
    required super.latitude,
    required super.longitude,
    super.regularPrice,
    super.premiumPrice,
    super.dieselPrice,
    super.priceDate,
  });

  // Map from SQLite query result to GasStationModel
  factory GasStationModel.fromSqfliteMap(Map<String, dynamic> sqfliteMap) {
    return GasStationModel(
      placeId: sqfliteMap['place_id'] as int,
      name: sqfliteMap['name'] as String,
      creId: sqfliteMap['cre_id'] as String,
      latitude: (sqfliteMap['latitude'] as num).toDouble(),
      longitude: (sqfliteMap['longitude'] as num).toDouble(),
      regularPrice: sqfliteMap['regular_price'] != null
          ? (sqfliteMap['regular_price'] as num).toDouble()
          : null,
      premiumPrice: sqfliteMap['premium_price'] != null
          ? (sqfliteMap['premium_price'] as num).toDouble()
          : null,
      dieselPrice: sqfliteMap['diesel_price'] != null
          ? (sqfliteMap['diesel_price'] as num).toDouble()
          : null,
      priceDate: sqfliteMap['price_date'] != null
          ? DateTime.tryParse(sqfliteMap['price_date'] as String)
          : null,
    );
  }

  factory GasStationModel.fromJson(Map<String, dynamic> json) {
    return GasStationModel(
      placeId: json['place_id'] as int,
      name: json['name'] as String,
      creId: json['cre_id'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      regularPrice: (json['regular_price'] as num?)?.toDouble(),
      premiumPrice: (json['premium_price'] as num?)?.toDouble(),
      dieselPrice: (json['diesel_price'] as num?)?.toDouble(),
      priceDate: json['price_date'] != null 
          ? DateTime.parse(json['price_date']) 
          : null,
    );
  }

  // Convert to SQLite insertion map
  Map<String, dynamic> toSqfliteMap(int timestampMs) {
    return {
      'place_id': placeId,
      'name': name,
      'cre_id': creId,
      'latitude': latitude,
      'longitude': longitude,
      'regular_price': regularPrice,
      'premium_price': premiumPrice,
      'diesel_price': dieselPrice,
      'price_date': priceDate?.toIso8601String(),
      'last_updated': timestampMs,
    };
  }

}