import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../data/memory_repository.dart';
import '../../data/search_provider.dart';
import '../../mock_service/mock_service.dart';
import 'colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'myrecipes/my_recipes_list.dart';
import 'recipes/recipe_list.dart';
import 'shopping/shopping_list.dart';
import 'package:flutter/material.dart';

class ProviderApp extends StatelessWidget {
  const ProviderApp({Key? key}) : super(key: key);

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
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  List<Widget> pageList = <Widget>[];
  static const String prefSelectedIndexKey = 'selectedIndex';
  late String title;
  @override
  void initState() {
    super.initState();
    pageList.add(const RecipeList());
    pageList.add(const MyRecipesList());
    pageList.add(const ShoppingList());

    title = 'Recipes';
    getCurrentIndex();
  }

  void saveCurrentIndex() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(prefSelectedIndexKey, _selectedIndex);
  }

  void getCurrentIndex() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(prefSelectedIndexKey)) {
      setState(() {
        final index = prefs.getInt(prefSelectedIndexKey);
        if (index != null) {
          _selectedIndex = index;
        }
      });
    }
  }

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        title = 'Recipes';
        break;
      case 1:
        title = 'Bookmarks';
        break;
      case 2:
        title = 'Groceries';
        break;
      default:
        title = 'Recipes';
        break;
    }
    setState(() {
      _selectedIndex = index;
    });
    saveCurrentIndex();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.food_bank),
            label: 'Recipes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_border_rounded),
            label: 'Bookmarks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_rounded),
            label: 'Groceries',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: green,
        onTap: _onItemTapped,
      ),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.amber,
        systemOverlayStyle: const SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.white,
          statusBarColor: Colors.white,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarDividerColor: Colors.white,
          //Navigation bar divider color
          systemNavigationBarIconBrightness:
              Brightness.light, //navigation bar icon
        ),
        title: Text(
          title,
          style: const TextStyle(
              fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),
        ),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: pageList,
      ),
    );
  }
}
