import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'features/map/map.dart';

Future<void> main() async {
  await Supabase.initialize(
    url: 'https://zpkmlihxxugqbcegbggc.supabase.co',
    publishableKey: 'sb_publishable_Ju2QCZu8E1OEY_UNjh4mEA_iL2DAlVs',
  );

  runApp(ProviderScope(
      child: GasoneraMainApp(),
    ));
}


class GasoneraMainApp extends StatelessWidget {
  const GasoneraMainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MapScreen(),
    );
  }
}
