import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import 'package:gasonera/features/gas_stations/domain/entities/map_bounds.dart';

/// Represents the current state of the map's viewport.
class MapViewportState {
  final MapBounds? bounds;
  final double zoom;
  final LatLng center;

  const MapViewportState({
    this.bounds,
    this.zoom = 15.0,
    this.center = const LatLng(0, 0),
  });

  MapViewportState copyWith({
    MapBounds? bounds,
    double? zoom,
    LatLng? center,
  }) {
    return MapViewportState(
      bounds: bounds ?? this.bounds,
      zoom: zoom ?? this.zoom,
      center: center ?? this.center,
    );
  }
}

class MapViewportNotifier extends Notifier<MapViewportState> {
  @override
  MapViewportState build() {
    return const MapViewportState();
  }

  /// Updates the current viewport parameters.
  void updateViewport({
    required MapBounds bounds,
    required double zoom,
    required LatLng center,
  }) {
    state = state.copyWith(
      bounds: bounds,
      zoom: zoom,
      center: center,
    );
  }
}

/// Provider exposing the current map viewport state.
final mapViewportProvider =
    NotifierProvider<MapViewportNotifier, MapViewportState>(
  MapViewportNotifier.new,
);