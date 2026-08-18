import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initial map coordinates (e.g., Mazatlan)
    final LatLng centerPoint = const LatLng(23.249415, -106.411142);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Map Example'),
        backgroundColor: Colors.teal,
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: centerPoint,
          initialZoom: 13.0,
        ),
        children: [
          // OpenStreetMap Tile Layer
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.gasonera',
          ),
          // Custom Marker Layer
          MarkerLayer(
            markers: [
              Marker(
                point: centerPoint,
                width: 50.0,
                height: 50.0,
                child: const Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 40.0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}