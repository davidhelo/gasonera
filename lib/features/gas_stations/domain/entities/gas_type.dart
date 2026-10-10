import 'package:flutter/material.dart';
import 'package:gasonera/theme/app_theme.dart';

enum GasType { regular, premium, diesel }

extension GasTypeX on GasType {
  /// Retrieve the appropriate gas type color from the current theme.
  Color color(BuildContext context) {
    final gasColors = Theme.of(context).extension<GasColors>();
    if (gasColors == null) {
      // Fallback to original hard‑coded values if the extension is missing.
      return switch (this) {
        GasType.regular => const Color(0xFF1B5E20),
        GasType.premium => const Color.fromARGB(255, 166, 28, 28),
        GasType.diesel => const Color(0xDD000000),
      };
    }
    return switch (this) {
      GasType.regular => gasColors.regular,
      GasType.premium => gasColors.premium,
      GasType.diesel => gasColors.diesel,
    };
  }
}
