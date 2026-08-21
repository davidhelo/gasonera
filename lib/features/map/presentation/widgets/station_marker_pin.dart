import 'package:flutter/material.dart';

import 'package:gasonera/features/gas_stations/domain/entities/gas_station.dart';

/// Custom Pin Widget displaying Regular Gas Price
class StationMarkerPin extends StatelessWidget {
  final GasStation station;
  final VoidCallback? onTap;

  const StationMarkerPin({
    super.key,
    required this.station,
    this.onTap,
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