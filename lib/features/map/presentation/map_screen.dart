import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gasonera/theme/theme_notifier.dart';

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
          actions: [
            // Use a Builder to obtain a BuildContext that is a descendant of the Scaffold.
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu),
                tooltip: 'Abrir menu',
                onPressed: () {
                  // Open the end drawer (right side) when the hamburger icon is pressed.
                  Scaffold.of(context).openEndDrawer();
                },
              ),
            ),
          ],
       ),
        // End drawer that will appear from the right side. Contains theme selector.
        endDrawer: Drawer(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Consumer(
                    builder: (context, ref, _) {
                     final currentMode = ref.watch(themeNotifierProvider);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Estilo', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      DropdownButton<ThemeMode>(
                        isExpanded: true,
                        value: currentMode,
                        items: const [
                          DropdownMenuItem(value: ThemeMode.light, child: Text('Claro')),
                          DropdownMenuItem(value: ThemeMode.dark, child: Text('Oscuro')),
                          DropdownMenuItem(value: ThemeMode.system, child: Text('Default (Sistema)')),
                        ],
                        onChanged: (ThemeMode? mode) {
                          if (mode != null) {
                        ref.read(themeNotifierProvider.notifier).setMode(mode);
                          }
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
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
