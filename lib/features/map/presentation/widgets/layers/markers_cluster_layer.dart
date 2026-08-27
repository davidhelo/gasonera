import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';

import 'package:gasonera/features/gas_stations/domain/entities/gas_station.dart';
import 'package:gasonera/features/gas_stations/providers/visible_stations_provider.dart';
import 'package:gasonera/features/map/presentation/widgets/station_marker_factory.dart';

class StationsMarkerClusterLayer extends ConsumerWidget {
  const StationsMarkerClusterLayer({super.key, this.onStationSelected});
  final void Function(GasStation station)? onStationSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stationsAsync = ref.watch(visibleStationsProvider);

    final stations = stationsAsync.value ?? [];

    final markers = stations
        .map((station) => buildStationMarker(
              station: station,
              onStationSelected: onStationSelected,
            ))
        .toList();

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
}
