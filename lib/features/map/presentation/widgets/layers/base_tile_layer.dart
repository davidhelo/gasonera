import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

class BaseTileLayer extends StatelessWidget {
  const BaseTileLayer({super.key});

  @override
  Widget build(BuildContext context) {
    return TileLayer(
      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
      userAgentPackageName: 'com.example.app',
      // Tile caching and tile provider configs go here
    );
  }
}