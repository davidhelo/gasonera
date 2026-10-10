import 'package:flutter/material.dart';
import 'package:flutter_map_vector_tiles/flutter_map_vector_tiles.dart' as vt;

class BaseTileLayer extends StatelessWidget {
  const BaseTileLayer({super.key});

  // Load a map style from the provided URI.
  Future<vt.Style> _loadStyle(String uri) async {
    return await vt.StyleReader(
      uri: uri,
    ).read();
  }

  @override
  Widget build(BuildContext context) {
    // Choose style URI based on the current theme brightness.
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final String styleUri = isDark
        ? 'https://tiles.openfreemap.org/styles/fiord'
        : 'asset://assets/custom_ofm_bright_style_based_on_protomaps_light.json';

    return FutureBuilder<vt.Style>(
      future: _loadStyle(styleUri),
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