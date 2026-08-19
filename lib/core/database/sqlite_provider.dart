import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_database.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final appDb = AppDatabase();
  ref.onDispose(() => appDb.close());
  return appDb;
});