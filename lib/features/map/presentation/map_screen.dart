import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gasonera/features/map/presentation/widgets/map_canvas.dart';
import 'package:gasonera/features/map/presentation/widgets/move_to_user_location_button.dart';
import 'package:gasonera/features/gas_stations/presentation/widgets/station_info_card.dart';
import 'package:gasonera/features/gas_stations/presentation/widgets/gas_type_selector.dart';

class MapScreen extends ConsumerWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GASONERA', style: TextStyle(fontSize: 16)),
      ),
      body: Stack(
        children: [
          const MapCanvas(),
          Positioned(
            bottom: 24,
            left: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: MoveToUserLocationButton()
                ),
                const SizedBox(height: 8),
                const GasTypeSelector(),
                const SizedBox(height: 4),
                const StationInfoCard(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
