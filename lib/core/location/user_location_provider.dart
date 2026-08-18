import 'package:flutter_riverpod/flutter_riverpod.dart';
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
}

/// StreamProvider that listens to continuous device GPS updates
final userLocationStreamProvider = StreamProvider<UserPosition>((ref) async* {
  // 1. Check & request GPS permissions
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    throw Exception('La ubicación está desactivada.');
  }

  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      throw Exception('Se ha negado el acceso a la ubicación.');
    }
  } if (permission == LocationPermission.deniedForever) {
      throw Exception(
        'La app no tiene permisos para acceder a la ubicación, cambie los permisos en la cofiguración de la app.');
    }

    // 2. Emit last known position immediately if available
  final lastPosition = await Geolocator.getLastKnownPosition();
  if (lastPosition != null) {
    yield UserPosition(
      latitude: lastPosition.latitude,
      longitude: lastPosition.longitude,
      heading: lastPosition.heading,
    );
  }

  // 3. Stream position updates
  yield* Geolocator.getPositionStream(
    locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10, // Update every 10 meters
    ),
  ).map((pos) => UserPosition(
        latitude: pos.latitude,
        longitude: pos.longitude,
        heading: pos.heading,
      ));
});