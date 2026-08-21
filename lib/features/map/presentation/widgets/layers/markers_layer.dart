import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import 'package:gasonera/features/gas_stations/domain/entities/gas_station.dart';
import 'package:gasonera/features/gas_stations/presentation/providers/visible_stations_provider.dart';

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
              child: _StationMarkerPin(
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

/// Custom Pin Widget displaying Regular Gas Price
class _StationMarkerPin extends StatelessWidget {
  final GasStation station;
  final VoidCallback onTap;

  const _StationMarkerPin({
    required this.station,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final priceText = station.regularPrice != null
        ? '\$${station.regularPrice!.toStringAsFixed(2)}'
        : 'N/A';

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Price Badge Bubble
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.green.shade800,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              priceText,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
            ),
          ),
          // Pin Needle Icon
          const Icon(
            Icons.location_on,
            color: Colors.redAccent,
            size: 28,
          ),
        ],
      ),
    );
  }
}