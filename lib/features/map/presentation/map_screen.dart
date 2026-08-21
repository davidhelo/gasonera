import 'package:flutter/material.dart';

import 'package:gasonera/features/map/presentation/widgets/map_canvas.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('GASONERA',
          style: const TextStyle(fontSize: 16),
        ),
        backgroundColor: Colors.teal,
      ),
      body: MapCanvas(),
    );
  }
}