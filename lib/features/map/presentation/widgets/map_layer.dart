import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MapLayer extends ConsumerWidget {
  final Map<String, dynamic> initialMapConfig;

  const MapLayer({super.key, required this.initialMapConfig});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FlutterMap(
            options: MapOptions(
              initialCenter: initialMapConfig['initialUserLocation'],
              initialZoom: initialMapConfig['initialZoom'],
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.gasonera',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: initialMapConfig['initialUserLocation'],
                    width: 50.0,
                    height: 50.0,
                    child: const Icon(
                      Icons.my_location,
                      color: Colors.blue,
                      size: 30.0,
                    ),
                  ),
                ],
              ),
            ],
          );
  }

}