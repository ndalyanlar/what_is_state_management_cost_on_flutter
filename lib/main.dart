import 'package:flutter/material.dart';
import 'package:logging/logging.dart' as provider_logger;

import 'provider/ui/main_screen.dart';

Future<void> main() async {
  _setupLogging();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderApp(),
    //  const RiverpodApp(),
    // const BlocApp(),
  );
}

void _setupLogging() {
  provider_logger.Logger.root.level = provider_logger.Level.ALL;
  provider_logger.Logger.root.onRecord.listen((rec) {
    debugPrint('${rec.level.name}: ${rec.time}: ${rec.message}');
  });
}
