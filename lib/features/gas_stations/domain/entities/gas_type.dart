import 'package:flutter/material.dart';

enum GasType { regular, premium, diesel }

extension GasTypeX on GasType {
  Color get color {
    return switch (this) {
      GasType.regular => const Color(0xFF1B5E20),
      GasType.premium => const Color.fromARGB(255, 166, 28, 28),
      GasType.diesel => const Color(0xDD000000),
    };
  }
}
