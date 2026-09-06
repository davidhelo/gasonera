import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gasonera/features/gas_stations/domain/entities/gas_station.dart';

class SelectedStationNotifier extends Notifier<GasStation?> {
  @override
  GasStation? build() => null;

  void setStation(GasStation? station) {
    state = station;
  }
}

final selectedStationProvider = NotifierProvider<SelectedStationNotifier, GasStation?>(
  SelectedStationNotifier.new,
);
