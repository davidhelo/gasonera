import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gasonera/features/gas_stations/domain/entities/gas_station.dart';
import 'package:gasonera/features/gas_stations/providers/selected_gas_type_provider.dart';
import 'package:gasonera/features/gas_stations/domain/entities/gas_type.dart';
import 'package:gasonera/features/gas_stations/providers/lowest_price_provider.dart';
import 'package:gasonera/features/map/providers/selected_station_provider.dart';

/// Custom Pin Widget displaying Gas Price based on selected type
class StationMarkerPin extends ConsumerWidget {
  final GasStation station;
  final VoidCallback? onTap;

  const StationMarkerPin({
    super.key,
    required this.station,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gasType = ref.watch(gasTypeProvider);
    final selectedStation = ref.watch(selectedStationProvider);
    final lowestPrice = ref.watch(lowestPriceProvider);
    final isSelected = selectedStation?.placeId == station.placeId;

    final double? price = switch (gasType) {
      GasType.regular => station.regularPrice,
      GasType.premium => station.premiumPrice,
      GasType.diesel => station.dieselPrice,
    };

    final bool isLowestPrice = price != null && lowestPrice != null && price == lowestPrice;

    return price == null
    ? SizedBox.shrink()
    : GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Price Badge Bubble
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
               // Use theme‑based gas type color
               color: gasType.color(context),
                borderRadius: BorderRadius.circular(12),
                   border: isLowestPrice
                     ? Border.all(color: Theme.of(context).colorScheme.secondary, width: 3)
                     : null,
                boxShadow: [
                  BoxShadow(
                     color: Theme.of(context).shadowColor.withOpacity(0.26),
                    blurRadius: isSelected ? 8 : 4,
                    offset: Offset(0, isSelected ? 4 : 2),
                  ),
                ],
              ),
              child: Text(
                '\$${price.toStringAsFixed(2)}',
                style: TextStyle(
                   color: Theme.of(context).colorScheme.surfaceDim,
                  fontWeight: FontWeight.bold,
                  fontSize: isSelected ? 16 : 14,
                ),
              ),
            ),
            // Pin Needle Icon
            Icon(
              Icons.location_on,
               color: isSelected ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.error.withValues(alpha: 0.7),
              size: isSelected ? 40 : 28,
            ),
          ],
        ),
      ),
    );
  }
}
