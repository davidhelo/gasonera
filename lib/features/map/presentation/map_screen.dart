import 'package:flutter/material.dart';

import 'package:gasonera/features/map/presentation/widgets/map_canvas.dart';
import 'package:gasonera/features/map/presentation/widgets/move_to_user_location_button.dart';

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
            right: 16,
            bottom: 24,
            child: const MoveToUserLocationButton(),
          ),
        ],
      ),
    );
  }
}
