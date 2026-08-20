import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gasonera/core/location/user_location_provider.dart';
import 'package:gasonera/features/map/presentation/widgets/map_canvas.dart';
import 'package:gasonera/features/gas_stations/data/services/daily_stations_sync_service_provider.dart';

class MapScreen extends ConsumerWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationAsync = ref.watch(userLocationStreamProvider);
    // Read DailyStationsSyncService provider to instantly fire the background sync execution loop
    ref.read(backgroundSyncTriggerProvider);

    return locationAsync.when(
      // 1. Data state: Use coordinates for title AND initial map center
      data: (position) {
        final initialMapConfig = {
          'initialUserLocation': LatLng(position.latitude, position.longitude),
          'initialZoom': 13.0
        };

        return Scaffold(
          appBar: AppBar(
            title: Text(
              '${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}',
              style: const TextStyle(fontSize: 16),
            ),
            backgroundColor: Colors.teal,
          ),
          body: MapCanvas(initialMapConfig: initialMapConfig),
        );
      },

      // 2. Loading state: Show fallback map or spinner
      loading: () => Scaffold(
        appBar: AppBar(
          title: const Text('Obteniendo ubicación...'),
          centerTitle: true,
          backgroundColor: Colors.teal,
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      ),

      // 3. Error state: Fallback to a default center (e.g., Mexico City)
      error: (err, stack) {
        const initialMapConfig = {
          'initialUserLocation': LatLng(19.4326, -99.1332),
          'initialZoom': 5.0
        };

        return Scaffold(
          appBar: AppBar(
            title: const Text('La ubicación no está disponible'),
            centerTitle: true,
            backgroundColor: Colors.teal,
          ),
          body: MapCanvas(initialMapConfig: initialMapConfig),
        );
      },
    );
  }
}