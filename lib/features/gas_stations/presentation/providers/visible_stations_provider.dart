import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gasonera/features/gas_stations/data/repositories/stations_repository_provider.dart';
import 'package:gasonera/features/gas_stations/domain/entities/gas_station.dart';

class VisibleStationsNotifier extends AsyncNotifier<List<GasStation>> {
  @override
  Future<List<GasStation>> build() async {
    // Initial state: empty list before map camera moves/initializes
    return [];
  }

  // Called by the map widget whenever camera pan or zoom gesture ends
  Future<void> updateBounds({
    required double minLat,
    required double maxLat,
    required double minLng,
    required double maxLng,
  }) async {
    final repository = ref.read(gasStationsRepositoryProvider);

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
