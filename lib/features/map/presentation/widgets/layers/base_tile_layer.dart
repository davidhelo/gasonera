import 'package:flutter/material.dart';
import 'package:flutter_map_vector_tiles/flutter_map_vector_tiles.dart' as vt;

class BaseTileLayer extends StatelessWidget {
  const BaseTileLayer({super.key});

  // Define the asynchronous style fetching method
  Future<vt.Style> _loadStyle() async {
    return await vt.StyleReader(
      // uri: 'https://tiles.openfreemap.org/styles/positron', // default openfreemap style JSON
      uri: 'asset://assets/custom_ofm_bright_style_based_on_protomaps_light.json',
    ).read();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<vt.Style>(
      future: _loadStyle(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error loading map style: ${snapshot.error}'));
        }

        if (snapshot.hasData) {
          final style = snapshot.data!;
          return vt.VectorTileLayer(
            theme: style.theme,
            tileProviders: style.providers,
            rasterSources: style.rasterSources,
            sprites: style.sprites,
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}