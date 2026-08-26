import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import 'package:gasonera/features/gas_stations/domain/entities/gas_station.dart';
import 'package:gasonera/features/gas_stations/providers/visible_stations_provider.dart';
import 'package:gasonera/features/map/presentation/widgets/station_marker_pin.dart';

class StationsMarkerLayer extends ConsumerWidget {
  final void Function(GasStation station)? onStationSelected;

  const StationsMarkerLayer({
    super.key,
    this.onStationSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stationsAsync = ref.watch(visibleStationsProvider);

    return stationsAsync.when(
      data: (stations) {
        if (stations.isEmpty) {
          return const SizedBox.shrink();
        }
        //print(stations.length);
        return MarkerLayer(
          markers: stations.map((station) {
            return Marker(
              point: LatLng(station.latitude, station.longitude),
              width: 80,
              height: 55,
              alignment: Alignment.topCenter,
              child: StationMarkerPin(
                station: station,
                onTap: () {
                  if (onStationSelected != null) {
                    onStationSelected!(station);
                  }
                },
              ),
            );
          }).toList(),
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
