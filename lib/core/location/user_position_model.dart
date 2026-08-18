import 'package:geolocator/geolocator.dart';

/// Raw position model decoupled from specific packages
class UserPosition {
  final double latitude;
  final double longitude;
  final double heading;

  const UserPosition({
    required this.latitude,
    required this.longitude,
    required this.heading,
  });

  factory UserPosition.fromPosition(Position position) {
    return UserPosition(
      latitude: position.latitude,
      longitude: position.longitude,
      heading: position.heading,
    );
  }
}