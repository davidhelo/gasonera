class GasStation {
  final int placeId;
  final String name;
  final String creId;
  final double latitude;
  final double longitude;
  final double? regularPrice;
  final double? premiumPrice;
  final double? dieselPrice;
  final DateTime? priceDate;

  GasStation({
    required this.placeId,
    required this.name,
    required this.creId,
    required this.latitude,
    required this.longitude,
    this.regularPrice,
    this.premiumPrice,
    this.dieselPrice,
    this.priceDate,
  });

}