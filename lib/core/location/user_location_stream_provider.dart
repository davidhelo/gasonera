import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gasonera/core/location/user_position_model.dart';

// Define location settings
const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );

// Stream provider
final userLocationStreamProvider = StreamProvider<UserPosition>((ref) => userLocationStream());

/// Stream that listens to continuous device GPS updates
Stream<UserPosition> userLocationStream() async* {
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
    yield UserPosition.fromPosition(lastPosition);
  }

  // 3. Stream position updates
  yield* Geolocator.getPositionStream(
    locationSettings: locationSettings,
  ).map((pos) => UserPosition.fromPosition(pos));
}


