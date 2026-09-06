import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math';

import 'package:gasonera/features/gas_stations/domain/entities/gas_type.dart';
import 'package:gasonera/features/gas_stations/providers/visible_stations_provider.dart';
import 'package:gasonera/features/gas_stations/providers/selected_gas_type_provider.dart';

/// Provider that calculates the lowest price for the selected gas type among all visible stations.
final lowestPriceProvider = Provider<double?>((ref) {
  final gasType = ref.watch(gasTypeProvider);
  final stationsAsync = ref.watch(visibleStationsProvider);

  final stations = stationsAsync.value ?? [];
  if (stations.isEmpty) return null;

  final prices = stations.map((s) {
    return switch (gasType) {
      GasType.regular => s.regularPrice,
      GasType.premium => s.premiumPrice,
      GasType.diesel => s.dieselPrice,
    };
  }).whereType<double>().toList();

  if (prices.isEmpty) return null;

  return prices.reduce(min);
});
