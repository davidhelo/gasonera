import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// A [Notifier] that holds the current [ThemeMode] and persists it using [SharedPreferences].
class ThemeNotifier extends Notifier<ThemeMode> {
  static const _prefKey = 'selectedThemeMode';
  @override
  ThemeMode build() {
    // Start with the system default and then load any persisted value.
    _loadFromPrefs();
    return ThemeMode.system;
  }

  // Loads the persisted [ThemeMode] from [SharedPreferences] and updates the
  // notifier's state. This is called once during [build] but runs
  // asynchronously, updating the UI when the value becomes available.
  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final int? index = prefs.getInt(_prefKey);
    if (index != null && index >= 0 && index < ThemeMode.values.length) {
      // Updating `state` notifies listeners.
      state = ThemeMode.values[index];
    }
  }

  // Persists the chosen [mode] and updates the notifier's state.
  Future<void> setMode(ThemeMode mode) async {
    state = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_prefKey, mode.index);
  }
}

// Exposes the [ThemeNotifier] so widgets can suscribe to it.
final themeNotifierProvider = NotifierProvider<ThemeNotifier, ThemeMode>(
  ThemeNotifier.new,
);

// Exposes only the current [ThemeMode]
final themeModeProvider = Provider<ThemeMode>((ref) {
  return ref.watch(themeNotifierProvider);
});
