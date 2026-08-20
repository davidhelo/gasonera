import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gasonera/core/database/sqlite_provider.dart';
import 'package:gasonera/features/map/data/repositories/stations_repository.dart';
import 'package:gasonera/features/map/domain/entities/gas_station.dart';


/// StationsRepository provider
final stationsRepositoryProvider = Provider<StationsRepository>((ref) {
  final appDb = ref.watch(appDatabaseProvider);
  return StationsRepository(localDb: appDb);
});

/// Notifier managing spatial queries and visible gas stations based on camera position
class VisibleStationsNotifier extends AsyncNotifier<List<GasStation>> {
  @override
  Future<List<GasStation>> build() async {
    // Initial state: empty list before map camera moves/initializes
    return [];
  }

  /// Called by the map widget whenever camera pan or zoom gesture ends
  Future<void> updateBounds({
    required double minLat,
    required double maxLat,
    required double minLng,
    required double maxLng,
  }) async {
    final repository = ref.read(stationsRepositoryProvider);

    final updatedList = await repository.getStationsInBounds(
      minLat: minLat,
      maxLat: maxLat,
      minLng: minLng,
      maxLng: maxLng,
    );

    state = AsyncValue.data(updatedList);
  }
}

// Primary Riverpod provider for visible stations
final visibleStationsProvider =
    AsyncNotifierProvider<VisibleStationsNotifier, List<GasStation>>(
  VisibleStationsNotifier.new,
);
