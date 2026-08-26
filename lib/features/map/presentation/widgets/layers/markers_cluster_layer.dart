import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';

import 'package:gasonera/features/gas_stations/domain/entities/gas_station.dart';
import 'package:gasonera/features/gas_stations/providers/visible_stations_provider.dart';
import 'package:gasonera/features/map/presentation/widgets/station_marker_pin.dart';

class StationsMarkerClusterLayer extends ConsumerWidget {
  const StationsMarkerClusterLayer({super.key, this.onStationSelected});
  final void Function(GasStation station)? onStationSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stationsAsync = ref.watch(visibleStationsProvider);

    final stations = stationsAsync.value ?? [];

    final markers = stations.map(_buildMarker).toList();

    return MarkerClusterLayerWidget(
      options: MarkerClusterLayerOptions(
        maxClusterRadius: 50,
        disableClusteringAtZoom: 14,
        size: const Size(40, 40),
        markers: markers,
        builder: (context, cluster) {
          return Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blueAccent.withOpacity(0.7),
            ),
            child: Center(
              child: Text(
                cluster.length.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Marker _buildMarker(GasStation station) {
    return Marker(
      point: LatLng(station.latitude, station.longitude),
      width: 80,
      height: 55,
      child: StationMarkerPin(
        station: station,
        // onTap: () {
        //   if (onStationSelected != null) {
        //     onStationSelected!(station);
        //   }
        // },
      ),
    );
  }
}
