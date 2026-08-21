import 'package:geolocator/geolocator.dart';

/// Raw position model decoupled from specific packages
class UserPosition {
  final double latitude;
  final double longitude;
  final double heading;
  final double accuracy;
  final double headingAccuracy;

  const UserPosition({
    required this.latitude,
    required this.longitude,
    required this.heading,
    required this.accuracy,
    required this.headingAccuracy
    
  });

  factory UserPosition.fromPosition(Position position) {
    return UserPosition(
      latitude: position.latitude,
      longitude: position.longitude,
      heading: position.heading,
      accuracy: position.accuracy,
      headingAccuracy: position.headingAccuracy
    );
  }
}