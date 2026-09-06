import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'layers/layers.dart';

import 'package:gasonera/features/map/providers/map_controller_provider.dart';
import 'package:gasonera/features/map/providers/map_viewport_provider.dart';
import 'package:gasonera/core/location/user_location_stream_provider.dart';
import 'package:gasonera/core/location/user_position_model.dart';
import 'package:gasonera/features/map/domain/initial_map_config.dart';
import 'package:gasonera/features/gas_stations/domain/entities/map_bounds.dart';
import 'package:gasonera/features/gas_stations/domain/entities/gas_station.dart';
import 'package:gasonera/features/map/providers/selected_station_provider.dart';

class MapCanvas extends ConsumerStatefulWidget {
  const MapCanvas({super.key});

  @override
  ConsumerState<MapCanvas> createState() => _MapCanvasState();
}

class _MapCanvasState extends ConsumerState<MapCanvas> {
  bool _initialLocationSet = false;

  void _handleStationSelected(GasStation station) {
    ref.read(selectedStationProvider.notifier).setStation(station);

    final mapController = ref.read(mapControllerProvider);
    // We shift the map center slightly south (subtract latitude) to move the marker
    // upwards, centering it in the visible area above the StationInfoCard.
    // Approx 0.004 degrees is ~90-110 pixels at zoom 15.
    mapController.move(
      LatLng(station.latitude - 0.002, station.longitude),
      15.0,
    );
  }

  @override
  void initState() {
    super.initState();

    ref.listenManual<AsyncValue<UserPosition>>(userLocationStreamProvider, (
      previous,
      next,
    ) {
      next.whenData((position) {
        if (_initialLocationSet) {
          return;
        }

        _initialLocationSet = true;

        final mapController = ref.read(mapControllerProvider);

        mapController.move(LatLng(position.latitude, position.longitude), 15.0);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final mapController = ref.watch(mapControllerProvider);

    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        initialCenter: LatLng(
          initialMapConfig.latitude,
          initialMapConfig.longitude,
        ),
        initialZoom: initialMapConfig.zoom,
        onPositionChanged: (position, hasGesture) {
          final bounds = position.visibleBounds;
          // Emit viewport updates through the dedicated map viewport state provider
          ref.read(mapViewportProvider.notifier).updateViewport(
                bounds: MapBounds(
                  minLat: bounds.south,
                  maxLat: bounds.north,
                  minLng: bounds.west,
                  maxLng: bounds.east,
                ),
                zoom: position.zoom,
                center: position.center,
              );
        },
      ),
      children: [
        const BaseTileLayer(),
        const UserLocationLayer(),
        StationsMarkerClusterLayer(
          onStationSelected: _handleStationSelected,
        ),
      ],
    );
  }
}
