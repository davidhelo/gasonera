import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'layers/layers.dart';

import 'package:gasonera/features/gas_stations/presentation/providers/visible_stations_provider.dart';
import 'package:gasonera/features/map/presentation/providers/map_controller_provider.dart';
import 'package:gasonera/core/location/user_location_stream_provider.dart';
import 'package:gasonera/core/location/user_position_model.dart';
import 'package:gasonera/features/map/domain/initial_map_config.dart';
import 'package:gasonera/features/gas_stations/domain/entities/map_bounds.dart';

class MapCanvas extends ConsumerStatefulWidget {
  const MapCanvas({super.key});

  @override
  ConsumerState<MapCanvas> createState() => _MapCanvasState();
}

class _MapCanvasState extends ConsumerState<MapCanvas> {
  bool _initialLocationSet = false;

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
          // Update visible stations provider with current viewport coordinates
          ref
              .read(visibleStationsProvider.notifier)
              .updateBounds(MapBounds(
                minLat: bounds.south,
                maxLat: bounds.north,
                minLng: bounds.west,
                maxLng: bounds.east,
              )
              );
        },
      ),
      children: const [
        BaseTileLayer(),
        UserLocationLayer(),
        StationsMarkerLayer(),
      ],
    );
  }
}
