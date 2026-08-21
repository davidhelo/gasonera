import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'layers/layers.dart';

import 'package:gasonera/features/map/presentation/providers/visible_stations_provider.dart';

class MapCanvas extends ConsumerWidget {
  final Map<String, dynamic> initialMapConfig; // Optional parameters for initial map configurations
  
  const MapCanvas({super.key, this.initialMapConfig = const {
        'initialUserLocation': LatLng(19.4326, -99.1332), // Default to Mexico City
        'initialZoom': 5.0
      }});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FlutterMap(
            options: MapOptions(
              initialCenter: initialMapConfig['initialUserLocation'],
              initialZoom: initialMapConfig['initialZoom'],
              // Triggered when camera moves or stops
              onPositionChanged: (position, hasGesture) {
                final bounds = position.visibleBounds;
                // Update visible stations provider with current viewport coordinates
                ref.read(visibleStationsProvider.notifier).updateBounds(
                  minLat: bounds.south,
                  maxLat: bounds.north,
                  minLng: bounds.west,
                  maxLng: bounds.east,
                );
              }
            ),
            children: [
              BaseTileLayer(),
              UserLocationLayer(),
              StationsMarkerLayer(),
            ],
          );
  }

}