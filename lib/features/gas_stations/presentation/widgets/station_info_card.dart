import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:gasonera/features/map/providers/selected_station_provider.dart';

import 'package:gasonera/features/gas_stations/domain/entities/gas_station.dart';

class StationInfoCard extends ConsumerWidget {
  const StationInfoCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedStation = ref.watch(selectedStationProvider);

    if (selectedStation == null) {
      return const SizedBox.shrink();
    }

    final name = selectedStation.name;
    final nameRegex = RegExp(r'[,]{0,1}[\s]+(S.A.)|(S. DE R.L.)|(S.A.B.)[\s]+(DE C.V.)'); // Regex pattern for organization suffix
    final match = nameRegex.firstMatch(name);

    String mainPart = name;
    String suffixPart = '';

    if (match != null) {
      mainPart = name.substring(0, match.start);
      suffixPart = name.substring(match.start);
    }

    return Card(
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 22),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: mainPart,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: suffixPart,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      overflow: TextOverflow.visible,
                    ),
                    Text(
                      'CRE ID: ${selectedStation.creId}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _pricesRow(selectedStation),
                if (selectedStation.priceDate != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Row(
                      children: [
                        Text(
                          'Actualizado el ${DateFormat('dd/MMMM/yyyy').format(selectedStation.priceDate!.toLocal())}',
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: () => _showPriceInfoDialog(context),
                          child: const Icon(
                            Icons.info_outline_rounded,
                            size: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              icon: const Icon(Icons.close_sharp),
              onPressed: () => ref.read(selectedStationProvider.notifier).setStation(null),
            ),
          ),
        ],
      ),
    );
  }

  Widget _pricesRow(GasStation station) {
    return Row(
      children: [
        if (station.regularPrice != null)
          Expanded(child: _buildPriceItem('Regular', station.regularPrice, const Color.fromARGB(255, 84, 135, 87))),
        if (station.premiumPrice != null)
          Expanded(child: _buildPriceItem('Premium', station.premiumPrice, const Color.fromARGB(255, 207, 115, 115))),
        if (station.dieselPrice != null)
          Expanded(child: _buildPriceItem('Diesel', station.dieselPrice, const Color.fromARGB(255, 75, 75, 75))),
      ],
    );
  }

  Widget _buildPriceItem(String label, double? price, Color color) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
      decoration: BoxDecoration(
        border: Border.all(color: color, width: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(
            '\$${price?.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showPriceInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Información de precios'),
        content: const Text(
'''La fecha de actualización corresponde a la última vez que la gasolinera cambió sus precios.

Fuente: Comisión Reguladora de Energía (CRE).

NOTA: Los precios se muestran tal como han sido reportados a la CRE y pueden variar al precio real. Verifique el precio final directamente en la estación de servicio.''',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }
}

