import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gasonera/features/gas_stations/providers/selected_gas_type_provider.dart';
import 'package:gasonera/features/gas_stations/domain/entities/gas_type.dart';

class GasTypeSelector extends ConsumerWidget {
  const GasTypeSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedGasType = ref.watch(gasTypeProvider);

    return SegmentedButton<GasType>(
      style: ButtonStyle(
      backgroundColor: WidgetStateProperty.all(Theme.of(context).colorScheme.surface),
      padding: WidgetStateProperty.all(EdgeInsets.symmetric(horizontal: 0, vertical: 8)),
    ),
      segments: GasType.values.map((GasType type) {
          final Color iconColor = type.color(context);
        return ButtonSegment<GasType>(
          value: type,
          label: Text(_gasTypeLabel(type)),
          icon: Icon(Icons.gas_meter, color: iconColor),
        );
      }).toList(),
      selected: {selectedGasType},
      onSelectionChanged: (Set<GasType> newValue) {
        ref.read(gasTypeProvider.notifier).setType(newValue.first);
      },
    );
  }

  String _gasTypeLabel(GasType type) {
    switch (type) {
      case GasType.regular:
        return 'Regular';
      case GasType.premium:
        return 'Premium';
      case GasType.diesel:
        return 'Diesel';
    }
  }
}
