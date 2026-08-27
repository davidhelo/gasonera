import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gasonera/features/gas_stations/domain/entities/gas_station.dart';
import 'package:gasonera/features/gas_stations/providers/visible_stations_provider.dart';
import 'package:gasonera/features/map/presentation/widgets/station_marker_factory.dart';

class StationsMarkerLayer extends ConsumerWidget {
  final void Function(GasStation station)? onStationSelected;

  const StationsMarkerLayer({super.key, this.onStationSelected});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stationsAsync = ref.watch(visibleStationsProvider);

    return stationsAsync.when(
      data: (stations) {
        if (stations.isEmpty) {
          return const SizedBox.shrink();
        }
        
        return MarkerLayer(
          markers: stations
              .map(
                (station) => buildStationMarker(
                  station: station,
                  onStationSelected: onStationSelected,
                ),
              )
              .toList(),
        );
      },
      // Keep existing pins on map while brief SQLite re-query occurs
      loading: () => const SizedBox.shrink(),
      error: (error, stack) {
        debugPrint('Error rendering map markers: $error');
        return const SizedBox.shrink();
      },
    );
  }
}
