import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';
import 'package:gasonera/features/map/providers/selected_station_provider.dart';

import 'package:gasonera/features/gas_stations/domain/entities/gas_station.dart';
import 'package:gasonera/theme/app_theme.dart';

class StationInfoCard extends ConsumerWidget {
  const StationInfoCard({super.key});

Future<void> _openMaps(GasStation station) async {
  final lat = station.latitude;
  final lng = station.longitude;

  final Uri uri;

  if (Platform.isAndroid) {
    // Android: Setting mode=d shows the driving route directions overview on screen
    uri = Uri.parse('https://www.google.com/maps/dir/?api=1&destination=$lat,$lng&travelmode=driving');
  } else if (Platform.isIOS) {
    // iOS: Displays the route overview in Apple Maps without starting turn-by-turn
    uri = Uri.parse('https://maps.apple.com/?daddr=$lat,$lng&dirflg=d');
  } else {
    // Web fallback
    uri = Uri.parse('https://www.google.com/maps/dir/?api=1&destination=$lat,$lng&travelmode=driving');
  }

  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } else {
    // Fallback if launchUrl fails
    final fallbackUri = Uri.parse('https://www.google.com/maps/dir/?api=1&destination=$lat,$lng');
    await launchUrl(fallbackUri, mode: LaunchMode.externalApplication);
  }
}

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedStation = ref.watch(selectedStationProvider);

    if (selectedStation == null) {
      return const SizedBox.shrink();
    }

    final name = selectedStation.name;
    final nameRegex = RegExp(r'(([,]?[\s]+S\.?\s?A\.?)|(S\.? DE R\.?\s?L\.?)|(S\.?A\.?B\.?))([\s]+DE C\.?\s?V\.?)$'); // Regex pattern for organization suffix
    final match = nameRegex.firstMatch(name);

    String mainPart = name;
    String suffixPart = '';

    if (match != null) {
      mainPart = name.substring(0, match.start);
      suffixPart = name.substring(match.start);
    }

    // Obtain custom colors from the theme extension (non-null)
    final cardColors = Theme.of(context).extension<StationInfoCardColors>()!;

    return Card(
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
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: cardColors.titleText,
                            ),
                          ),
                          TextSpan(
                            text: suffixPart,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: cardColors.subtitleText,
                            ),
                          ),
                        ],
                      ),
                      overflow: TextOverflow.visible,
                    ),
                    Text(
                      'CRE ID: ${selectedStation.creId}',
                      style: TextStyle(
                        fontSize: 12,
                        color: cardColors.subtitleText,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                    _pricesRow(selectedStation, cardColors),
                if (selectedStation.priceDate != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Row(
                      children: [
                          Text(
                          'Ultimo cambio de precios el ${DateFormat('dd/MMMM/yyyy', 'es').format(selectedStation.priceDate!.toLocal())}',
                          style: TextStyle(fontSize: 12, color: cardColors.subtitleText),
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: () => _showPriceInfoDialog(context),
                          child: Icon(
                            Icons.info_outline_rounded,
                            size: 14,
                            color: cardColors.subtitleText,
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _openMaps(selectedStation),
                    icon: const Icon(Icons.directions_outlined),
                    label: const Text('Cómo llegar'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
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

  Widget _pricesRow(GasStation station, StationInfoCardColors cardColors) {
    return Row(
      children: [
        if (station.regularPrice != null)
          Expanded(child: _buildPriceItem('Regular', station.regularPrice, cardColors.borderRegular)),
        if (station.premiumPrice != null)
          Expanded(child: _buildPriceItem('Premium', station.premiumPrice, cardColors.borderPremium)),
        if (station.dieselPrice != null)
          Expanded(child: _buildPriceItem('Diesel', station.dieselPrice, cardColors.borderDiesel)),
      ],
    );
  }

  Widget _buildPriceItem(String label, double? price, Color color) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
      decoration: BoxDecoration(
        border: Border.all(color: color, width: 0.75),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14),
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