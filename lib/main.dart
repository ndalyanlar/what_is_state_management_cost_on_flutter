import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:logging/logging.dart';

import 'package:provider/provider.dart';
import 'data/memory_repository.dart';
import 'data/search_provider.dart';
import 'mock_service/mock_service.dart';
import 'network/model_response.dart';
import 'network/recipe_model.dart';
import 'network/recipe_service.dart';
import 'ui/main_screen.dart';

Future<void> main() async {
  _setupLogging();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

void _setupLogging() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((rec) {
    debugPrint('${rec.level.name}: ${rec.time}: ${rec.message}');
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MemoryRepository>(
          lazy: false,
          create: (_) => MemoryRepository(),
        ),
        Provider(
          lazy: false,
          create: (_) => MockService()..create(),
        ),
        ChangeNotifierProvider<SearchStateNotifier>(
          lazy: false,
          create: (_) => SearchStateNotifier()..getPreviousSearches(),
        ),
      ],
      builder: (context, child) {
        return MaterialApp(
          title: 'Recipes',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            brightness: Brightness.light,
            primaryColor: Colors.white,
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: const MainScreen(),
        );
      },
      // child: MaterialApp(
      //   title: 'Recipes',
      //   debugShowCheckedModeBanner: false,
      //   theme: ThemeData(
      //     brightness: Brightness.light,
      //     primaryColor: Colors.white,
      //     primarySwatch: Colors.blue,
      //     visualDensity: VisualDensity.adaptivePlatformDensity,
      //   ),
      //   home: const MainScreen(),
      // ),
    );
  }
}
