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

}