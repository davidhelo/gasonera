import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gasonera/features/gas_stations/domain/entities/gas_station.dart';
import 'package:gasonera/features/gas_stations/providers/selected_gas_type_provider.dart';
import 'package:gasonera/features/gas_stations/domain/entities/gas_type.dart';

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

    final double? price = switch (gasType) {
      GasType.regular => station.regularPrice,
      GasType.premium => station.premiumPrice,
      GasType.diesel => station.dieselPrice,
    };

    return price == null 
    ? SizedBox.shrink() 
    : GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Price Badge Bubble
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: gasType.color,
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
              '\$${price.toStringAsFixed(2)}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
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
