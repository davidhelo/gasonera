import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gasonera/features/gas_stations/domain/repositories/gas_stations_repository.dart';
import 'package:gasonera/features/gas_stations/data/repositories/stations_repository.dart';

import 'package:gasonera/core/database/sqlite_provider.dart';

// StationsRepository provider
final gasStationsRepositoryProvider = Provider<GasStationsRepository>((ref) {
  final appDb = ref.watch(appDatabaseProvider);
  return StationsRepository(localDb: appDb);
});
