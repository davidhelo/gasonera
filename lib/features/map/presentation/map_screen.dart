import 'package:flutter/material.dart';

import 'package:gasonera/features/map/presentation/widgets/map_canvas.dart';
import 'package:gasonera/features/map/presentation/widgets/move_to_user_location_button.dart';
import 'package:gasonera/features/gas_stations/presentation/widgets/station_info_card.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GASONERA', style: const TextStyle(fontSize: 16)),
        backgroundColor: Colors.teal,
      ),
      body: Stack(
        children: [
          const MapCanvas(),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      right: 16,
                      bottom: 14,
                    ),
                    child: const MoveToUserLocationButton(),
                  ),
                ),
                const StationInfoCard(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
