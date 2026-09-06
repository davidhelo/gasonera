import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math' as math;
import 'package:flutter_map_animations/flutter_map_animations.dart';

import 'layers/layers.dart';

import 'package:gasonera/features/map/providers/map_controller_provider.dart';
import 'package:gasonera/features/map/providers/map_viewport_provider.dart';
import 'package:gasonera/core/location/user_location_stream_provider.dart';
import 'package:gasonera/core/location/user_position_model.dart';
import 'package:gasonera/features/map/domain/initial_map_config.dart';
import 'package:gasonera/features/gas_stations/domain/entities/map_bounds.dart';
import 'package:gasonera/features/gas_stations/domain/entities/gas_station.dart';
import 'package:gasonera/features/map/providers/selected_station_provider.dart';
import 'package:gasonera/features/map/providers/map_animation_provider.dart';

class MapCanvas extends ConsumerStatefulWidget {
  const MapCanvas({super.key});

  @override
  ConsumerState<MapCanvas> createState() => _MapCanvasState();
}

class _MapCanvasState extends ConsumerState<MapCanvas> with TickerProviderStateMixin {
  bool _initialLocationSet = false;
  late AnimatedMapController _animatedController;

  void _handleStationSelected(GasStation station) {
    ref.read(selectedStationProvider.notifier).setStation(station);

    final zoom = _animatedController.mapController.camera.zoom;

    // We shift the map center slightly south to move the marker upwards,
    // centering it in the visible area above the StationInfoCard.
    // We scale the offset by 2^(15 - zoom) to maintain a consistent pixel offset across zoom levels.
    // 0.004 degrees is ~90-110 pixels at zoom 15.
    final double offset = 0.004 * math.pow(2, 15 - zoom).toDouble();

    _animatedController.animateTo(
      dest: LatLng(station.latitude - offset, station.longitude),
      zoom: zoom,
    );
  }

  @override
  void initState() {
    super.initState();

    final mapController = ref.read(mapControllerProvider);
    _animatedController = AnimatedMapController(
      mapController: mapController,
      vsync: this,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOutCubic,
    );

    Future.microtask(() {
      ref.read(mapAnimationProvider.notifier).setController(_animatedController);
    });

    ref.listenManual<AsyncValue<UserPosition>>(userLocationStreamProvider, (
      previous,
      next,
    ) {
      next.whenData((position) {
        if (_initialLocationSet) {
          return;
        }

        _initialLocationSet = true;

        _animatedController.animateTo(
          dest: LatLng(position.latitude, position.longitude),
          zoom: 15.0,
        );
      });
    });
  }

  @override
  void dispose() {
    Future.microtask(() {
      ref.read(mapAnimationProvider.notifier).setController(null);
    });
    _animatedController.dispose();
    super.dispose();
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
        initialRotation: 0,
        interactionOptions: InteractionOptions(
          flags: ~InteractiveFlag.rotate,
          cursorKeyboardRotationOptions: CursorKeyboardRotationOptions.disabled(),
        ),
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
