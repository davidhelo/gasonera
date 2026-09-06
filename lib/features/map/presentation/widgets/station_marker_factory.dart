import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'package:gasonera/features/gas_stations/domain/entities/gas_station.dart';
import 'package:gasonera/features/map/presentation/widgets/station_marker_pin.dart';

Marker buildStationMarker({
  required GasStation station,
  void Function(GasStation station)? onStationSelected,
}) {
  return Marker(
    point: LatLng(station.latitude, station.longitude),
    width: 80,
    height: 55,
    alignment: Alignment.topCenter,
    child: StationMarkerPin(
      station: station,
      onTap: onStationSelected != null ? () => onStationSelected(station) : null,
    ),
  );
}
