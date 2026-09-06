import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';

class MapAnimationNotifier extends Notifier<AnimatedMapController?> {
  @override
  AnimatedMapController? build() => null;

  void setController(AnimatedMapController? controller) {
    state = controller;
  }
}

final mapAnimationProvider = NotifierProvider<MapAnimationNotifier, AnimatedMapController?>(
  MapAnimationNotifier.new,
);
