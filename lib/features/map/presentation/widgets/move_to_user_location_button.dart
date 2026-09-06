import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gasonera/core/location/user_location_stream_provider.dart';
import 'package:gasonera/features/map/providers/map_controller_provider.dart';


class MoveToUserLocationButton extends ConsumerWidget {
  const MoveToUserLocationButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationAsync = ref.watch(userLocationStreamProvider);

    final position = switch (locationAsync) {
          AsyncData(:final value) => value,
          _ => null,
        };

    return FloatingActionButton(
      shape: CircleBorder(),
      backgroundColor: const Color.fromARGB(225, 149, 226, 218),
      onPressed: position == null 
      ? null 
      : () {
        ref.read(mapControllerProvider).move(
                LatLng(
                  position.latitude,
                  position.longitude,
                ),
                15,
              );
      },
      child: const Icon(Icons.my_location),
    );
  }
}