import 'package:flutter/material.dart';

/// Theme extensions for custom colors used throughout the app.
class GasColors extends ThemeExtension<GasColors> {
  final Color regular;
  final Color premium;
  final Color diesel;

  const GasColors({
    required this.regular,
    required this.premium,
    required this.diesel,
  });

  @override
  GasColors copyWith({Color? regular, Color? premium, Color? diesel}) {
    return GasColors(
      regular: regular ?? this.regular,
      premium: premium ?? this.premium,
      diesel: diesel ?? this.diesel,
    );
  }

  @override
  GasColors lerp(ThemeExtension<GasColors>? other, double t) {
    if (other is! GasColors) return this;
    return GasColors(
      regular: Color.lerp(regular, other.regular, t) ?? regular,
      premium: Color.lerp(premium, other.premium, t) ?? premium,
      diesel: Color.lerp(diesel, other.diesel, t) ?? diesel,
    );
  }
}

/// Theme extension for colors used specifically in the StationInfoCard widget.
class StationInfoCardColors extends ThemeExtension<StationInfoCardColors> {
  final Color titleText;
  final Color subtitleText;
  final Color borderRegular;
  final Color borderPremium;
  final Color borderDiesel;

  const StationInfoCardColors({
    required this.titleText,
    required this.subtitleText,
    required this.borderRegular,
    required this.borderPremium,
    required this.borderDiesel,
  });

  @override
  StationInfoCardColors copyWith({
    Color? titleText,
    Color? subtitleText,
    Color? borderRegular,
    Color? borderPremium,
    Color? borderDiesel,
  }) {
    return StationInfoCardColors(
      titleText: titleText ?? this.titleText,
      subtitleText: subtitleText ?? this.subtitleText,
      borderRegular: borderRegular ?? this.borderRegular,
      borderPremium: borderPremium ?? this.borderPremium,
      borderDiesel: borderDiesel ?? this.borderDiesel,
    );
  }

  @override
  StationInfoCardColors lerp(ThemeExtension<StationInfoCardColors>? other, double t) {
    if (other is! StationInfoCardColors) return this;
    return StationInfoCardColors(
      titleText: Color.lerp(titleText, other.titleText, t) ?? titleText,
      subtitleText: Color.lerp(subtitleText, other.subtitleText, t) ?? subtitleText,
      borderRegular: Color.lerp(borderRegular, other.borderRegular, t) ?? borderRegular,
      borderPremium: Color.lerp(borderPremium, other.borderPremium, t) ?? borderPremium,
      borderDiesel: Color.lerp(borderDiesel, other.borderDiesel, t) ?? borderDiesel,
    );
  }
}

/// Centralized light and dark themes for the application.
class AppTheme {
  static final ThemeData lightTheme = ThemeData.light().copyWith(
    // Example customizations – you can adjust as needed.
    colorScheme: ThemeData.light().colorScheme.copyWith(
      primary: const Color.fromARGB(255, 238, 238, 238),
      secondary: Colors.limeAccent,
      error: Colors.red,
    ),
    // Define the default FloatingActionButton background color for the light theme
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color.fromARGB(225, 149, 226, 218),
    ),
    // Define a consistent AppBar background color for the light theme
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.teal,
    ),
    extensions: <ThemeExtension<dynamic>>[
      const GasColors(
        regular: Color(0xFF1B5E20), // dark green
        premium: Color.fromARGB(255, 166, 28, 28), // dark red
        diesel: Color(0xDD000000), // semi‑transparent black
      ),
      const StationInfoCardColors(
        titleText: Colors.black,
        subtitleText: Colors.grey,
        borderRegular: Color.fromARGB(255, 84, 135, 87),
        borderPremium: Color.fromARGB(255, 207, 115, 115),
        borderDiesel: Color.fromARGB(255, 75, 75, 75),
      ),
    ],
  );

  static final ThemeData darkTheme = ThemeData.dark().copyWith(
    colorScheme: ThemeData.dark().colorScheme.copyWith(
      primary: const Color.fromARGB(255, 238, 238, 238),
      secondary: Colors.limeAccent,
      error: Colors.redAccent,
    ),
    // Use the same default FAB color for dark theme (or adjust as needed)
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color.fromARGB(255, 27, 35, 80),
    ),
    // Use the default AppBar background color for the dark theme (no explicit color)
    appBarTheme: const AppBarTheme(),
    extensions: <ThemeExtension<dynamic>>[
      const GasColors(
        regular: Color.fromARGB(255, 97, 149, 100), // lighter green for dark background
        premium: Color.fromARGB(255, 146, 37, 31), // brighter red
        diesel: Color.fromARGB(255, 55, 55, 55), // light grey
      ),
      const StationInfoCardColors(
        // In dark mode we typically want light text on dark background.
        titleText: Colors.white,
        subtitleText: Colors.grey,
        borderRegular: Color.fromARGB(255, 84, 135, 87),
        borderPremium: Color.fromARGB(255, 207, 115, 115),
        borderDiesel: Color.fromARGB(255, 75, 75, 75),
      ),
    ],
  );
}
