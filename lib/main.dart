import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:logging/logging.dart' as ProviderLogger;

import 'package:provider/provider.dart';
import 'data/memory_repository.dart';
import 'data/search_provider.dart';
import 'mock_service/mock_service.dart';
import 'network/model_response.dart';
import 'network/recipe_model.dart';
import 'network/recipe_service.dart';
import 'provider/ui/main_screen.dart';
import 'riverpod/ui/main_screen.dart';

Future<void> main() async {
  _setupLogging();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const RiverpodApp());
}

void _setupLogging() {
  ProviderLogger.Logger.root.level = ProviderLogger.Level.ALL;
  ProviderLogger.Logger.root.onRecord.listen((rec) {
    debugPrint('${rec.level.name}: ${rec.time}: ${rec.message}');
  });
}
