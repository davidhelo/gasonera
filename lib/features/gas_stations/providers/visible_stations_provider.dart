import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gasonera/features/gas_stations/data/repositories/stations_repository_provider.dart';
import 'package:gasonera/features/gas_stations/domain/entities/gas_station.dart';
import 'package:gasonera/features/gas_stations/domain/entities/map_bounds.dart';

class VisibleStationsNotifier extends AsyncNotifier<List<GasStation>> {
  Timer? _timer;

  MapBounds? _pendingBounds;
  bool _queryRunning = false;

  @override
  Future<List<GasStation>> build() async {
    ref.onDispose(() {
      _timer?.cancel();
    });

    return [];
  }

  void updateBounds(MapBounds bounds) {
    _pendingBounds = bounds;

    if (_queryRunning) {
      return;
    }

    _scheduleQuery();
  }

  void _scheduleQuery() {
    if (_timer?.isActive ?? false) {
      return;
    }

    _timer = Timer(
      const Duration(milliseconds: 150),
      _query,
    );
  }

  Future<void> _query() async {
    final bounds = _pendingBounds;

    if (bounds == null || _queryRunning) {
      return;
    }

    _pendingBounds = null;
    _queryRunning = true;

    try {
      final repository = ref.read(gasStationsRepositoryProvider);

      final stationsInBounds = await repository.getStationsInBounds(
        minLat: bounds.minLat,
        maxLat: bounds.maxLat,
        minLng: bounds.minLng,
        maxLng: bounds.maxLng,
      );

      state = AsyncData(stationsInBounds);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    } finally {
      _queryRunning = false;

      // The user moved while the query was running.
      if (_pendingBounds != null) {
        _scheduleQuery();
      }
    }
  }
}

// Primary Riverpod provider for visible stations
final visibleStationsProvider =
    AsyncNotifierProvider<VisibleStationsNotifier, List<GasStation>>(
      VisibleStationsNotifier.new,
    );
