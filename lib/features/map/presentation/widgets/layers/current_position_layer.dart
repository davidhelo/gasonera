import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'dart:math' show pi;

import 'package:gasonera/core/location/user_location_stream_provider.dart';

class UserLocationLayer extends ConsumerWidget {
  const UserLocationLayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationAsync = ref.watch(userLocationStreamProvider);

    return locationAsync.when(
      data: (p) {
      return AnimatedLocationMarkerLayer(
        position: LocationMarkerPosition(
          latitude: p.latitude,
          longitude: p.longitude,
          accuracy: p.accuracy,
        ),
        heading: LocationMarkerHeading(
          // Convert from degrees to radians (values heading and headingAccuracy from Geolocator.Position are in degrees)
          heading: p.heading * (pi / 180), 
          accuracy: (p.headingAccuracy <= 0)? double.nan : p.headingAccuracy * (pi / 180),
        ),
      );
    },
    // Fallback layers for when data isn't ready or fails
      error: (err, stack) => const SizedBox.shrink(),
      loading: () => const SizedBox.shrink(),
    );
  }
}
