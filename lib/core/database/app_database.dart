// lib/core/database/app_database.dart
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  static Database? _db;

  /// Access to the Sqflite Database
  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDatabase();
    return _db!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'app_database.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  /// Create tables on first app install
  Future<void> _onCreate(Database db, int version) async {
    // Create table daily_gas_stations
    await db.execute('''
      CREATE TABLE daily_gas_stations (
        place_id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        cre_id TEXT NOT NULL,
        latitude REAL NOT NULL,
        longitude REAL NOT NULL,
        regular_price REAL,
        premium_price REAL,
        diesel_price REAL,
        price_date TEXT,
        last_updated INTEGER NOT NULL
      )
    ''');
    // Create index for latitude and logitude for faster performance on spatial queries
    await db.execute('''
      CREATE INDEX idx_daily_gas_stations_coords ON daily_gas_stations(latitude, longitude);
    ''');
  }

  Future<void> close() async {
    if (_db != null && _db!.isOpen) {
      await _db!.close();
      _db = null;
    }
  }
}