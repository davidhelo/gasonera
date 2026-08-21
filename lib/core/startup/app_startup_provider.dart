import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gasonera/features/gas_stations/data/services/daily_stations_sync_service_provider.dart';


final appStartupProvider = FutureProvider<void>((ref) async {
  // Run startup tasks sequentially
  await ref.read(dailyStationsSyncServiceProvider).syncDailyStations();
  // Add more Future startup tasks here
});