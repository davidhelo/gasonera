import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math' as math;
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';

import 'package:gasonera/features/gas_stations/domain/entities/gas_station.dart';
import 'package:gasonera/features/gas_stations/domain/entities/gas_type.dart';
import 'package:gasonera/features/gas_stations/providers/selected_gas_type_provider.dart';
import 'package:gasonera/features/gas_stations/providers/visible_stations_provider.dart';
import 'package:gasonera/features/gas_stations/providers/lowest_price_provider.dart';
import 'package:gasonera/features/map/providers/selected_station_provider.dart';
import 'package:gasonera/features/map/presentation/widgets/station_marker_factory.dart';

class StationsMarkerClusterLayer extends ConsumerWidget {
  const StationsMarkerClusterLayer({super.key, this.onStationSelected});
  final void Function(GasStation station)? onStationSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stationsAsync = ref.watch(visibleStationsProvider);
    final selectedStation = ref.watch(selectedStationProvider);
    final gasType = ref.watch(gasTypeProvider);
    final lowestPrice = ref.watch(lowestPriceProvider);

    final stations = stationsAsync.value ?? [];

    // Sort stations so the selected one is rendered last (on top)
    final sortedStations = List<GasStation>.from(stations)
      ..sort((a, b) {
        if (a.placeId == selectedStation?.placeId) return 1;
        if (b.placeId == selectedStation?.placeId) return -1;
        return 0;
      });

    // Map markers to their stations to retrieve price data in the cluster builder
    final markerToStation = <Marker, GasStation>{};
    final markers = sortedStations
        .map((station) {
          final marker = buildStationMarker(
                station: station,
                onStationSelected: onStationSelected,
              );
          markerToStation[marker] = station;
          return marker;
        })
        .toList();

    return MarkerClusterLayerWidget(
      options: MarkerClusterLayerOptions(
        maxClusterRadius: 60,
        size: const Size(65, 65),
        alignment: Alignment.topCenter,
        markers: markers,
        builder: (context, cluster) {
          // Extract stations belonging to this cluster
          final clusterStations = cluster
              .map((m) => markerToStation[m])
              .whereType<GasStation>()
              .toList();

          // Find the price range for the current gas type
          final prices = clusterStations.map((s) {
            return switch (gasType) {
              GasType.regular => s.regularPrice,
              GasType.premium => s.premiumPrice,
              GasType.diesel => s.dieselPrice,
            };
          }).whereType<double>().toList();

          String label = cluster.length.toString();
          if (prices.isNotEmpty) {
            final minPrice = prices.reduce(math.min);
            final maxPrice = prices.reduce(math.max);

            if (minPrice == maxPrice) {
              label = '\$${minPrice.toStringAsFixed(2)}';
            } else {
              label = '\$${minPrice.toStringAsFixed(2)} - \$${maxPrice.toStringAsFixed(2)}';
            }
          }

          final bool hasLowestPrice = prices.isNotEmpty &&
                                     lowestPrice != null &&
                                     prices.contains(lowestPrice);

          return Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: gasType.color.withValues(alpha: 0.75),
              border: hasLowestPrice
                  ? Border.all(color: Colors.limeAccent, width: 3)
                  : null,
            ),
            child: Center(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  height: 1.1,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

}
