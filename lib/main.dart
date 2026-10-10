import 'package:flutter/material.dart';
import 'package:gasonera/theme/app_theme.dart';
import 'package:gasonera/theme/theme_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'features/map/map.dart';
import 'package:gasonera/core/startup/app_startup_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://zpkmlihxxugqbcegbggc.supabase.co',
    publishableKey: 'sb_publishable_Ju2QCZu8E1OEY_UNjh4mEA_iL2DAlVs',
  );

  await initializeDateFormatting('es', null);

  runApp(ProviderScope(
      child: GasoneraMainApp(),
    ));
}

class GasoneraMainApp extends ConsumerWidget {
  const GasoneraMainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Tgigger startup initialization
    ref.read(appStartupProvider);

    // Use centralized light and dark themes with system theme mode
    return MaterialApp(
      home: const MapScreen(),
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
       // Use the theme mode from the provider, defaulting to system if not set.
        themeMode: ref.watch(themeModeProvider),
    );
  }
}
