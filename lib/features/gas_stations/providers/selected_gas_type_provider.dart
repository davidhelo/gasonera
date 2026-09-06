import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gasonera/features/gas_stations/domain/entities/gas_type.dart';

class SelectedGasTypeNotifier extends Notifier<GasType> {
  @override
  GasType build() => GasType.regular;

  void setType(GasType type) {
    state = type;
  }
}

final gasTypeProvider = NotifierProvider<SelectedGasTypeNotifier, GasType>(
  SelectedGasTypeNotifier.new,
);
