import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import 'layers/layers.dart';

class MapCanvas extends StatelessWidget {
  final Map<String, dynamic> initialMapConfig;

  const MapCanvas({super.key, required this.initialMapConfig});

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
            options: MapOptions(
              initialCenter: initialMapConfig['initialUserLocation'],
              initialZoom: initialMapConfig['initialZoom'],
            ),
            children: [
              BaseTileLayer(),
              CurrentPositionLayer(),
            ],
          );
  }

}