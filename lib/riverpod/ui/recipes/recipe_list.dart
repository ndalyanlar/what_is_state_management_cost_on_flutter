import 'dart:collection';
import 'dart:developer';

import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/models.dart';
import '../../../data/search_provider.dart';
import '../../../mock_service/mock_service.dart';
import '../../../network/model_response.dart';
import '../../../network/recipe_model.dart';
import '../../providers/providers.dart';
import '../recipe_card.dart';
import '../recipes/recipe_details.dart';
import '../widgets/search_card.dart';

class RecipeList extends ConsumerStatefulWidget {
  const RecipeList({Key? key}) : super(key: key);

  @override
  ConsumerState<RecipeList> createState() => _RecipeListState();
}

class _RecipeListState extends ConsumerState<RecipeList> {
  // static const String prefSearchKey = 'previousSearches';

  // late TextEditingController searchTextController;
  // late final ScrollController _scrollController;
  // List<APIHits> currentSearchList = [];
  // int currentCount = 0;
  // int currentStartPosition = 0;
  // int currentEndPosition = 20;
  // int pageCount = 20;
  // bool hasMore = false;
  // bool loading = false;
  // bool inErrorState = false;
  // List<String> previousSearches = <String>[];

  @override
  void initState() {
    super.initState();
    ref.read<SearchStateNotifier>(searchProvider).getPreviousSearches();
    ref.read<MockService>(serviceProvider).create();
  }

  @override
  void dispose() {
    ref.read<SearchStateNotifier>(searchProvider).dispose();
    // searchTextController.dispose();
    super.dispose();
  }

  // void savePreviousSearches() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   prefs.setStringList(prefSearchKey, previousSearches);
  // }

  // void getPreviousSearches() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   if (prefs.containsKey(prefSearchKey)) {
  //     final searches = prefs.getStringList(prefSearchKey);
  //     if (searches != null) {
  //       previousSearches = searches;
  //     } else {
  //       previousSearches = <String>[];
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: const <Widget>[
            SearchCard(),
            BuildRecipeLoader(),
          ],
        ),
      ),
    );
  }

  // Widget _buildSearchCard() {

  //   return SearchCard();
  // }

  // void startSearch(String value) {
  //   setState(() {
  //     currentSearchList.clear();
  //     currentCount = 0;
  //     currentEndPosition = pageCount;
  //     currentStartPosition = 0;
  //     hasMore = true;
  //     value = value.trim();
  //     // if (!previousSearches.contains(value)) {
  //     //   previousSearches.add(value);
  //     //   savePreviousSearches();
  //     // }
  //   });
  // }

  // Widget _buildRecipeLoader(BuildContext context) {
  //   return BuildRecipeLoader();
  // }

  // Widget _buildRecipeList(BuildContext recipeListContext, List<APIHits> hits) {
  //   final size = MediaQuery.of(context).size;
  //   const itemHeight = 310;
  //   final itemWidth = size.width / 2;
  //   return Flexible(
  //     child: GridView.builder(
  //       controller: context.read<SearchStateNotifier>().scrollController,
  //       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //         crossAxisCount: 2,
  //         childAspectRatio: (itemWidth / itemHeight),
  //       ),
  //       itemCount: hits.length,
  //       itemBuilder: (BuildContext context, int index) {
  //         return _buildRecipeCard(recipeListContext, hits, index);
  //       },
  //     ),
  //   );
  // }

  // Widget _buildRecipeCard(
  //     BuildContext topLevelContext, List<APIHits> hits, int index) {
  //   final recipe = hits[index].recipe;
  //   return GestureDetector(
  //     onTap: () {
  //       Navigator.push(topLevelContext, MaterialPageRoute(
  //         builder: (context) {
  //           final detailRecipe = Recipe(
  //               label: recipe.label,
  //               image: recipe.image,
  //               url: recipe.url,
  //               calories: recipe.calories,
  //               totalTime: recipe.totalTime,
  //               totalWeight: recipe.totalWeight);
  //           detailRecipe.ingredients = convertIngredients(recipe.ingredients);
  //           return RecipeDetails(recipe: detailRecipe);
  //         },
  //       ));
  //     },
  //     child: recipeCard(recipe),
  //   );
  // }
}

class BuildRecipeLoader extends ConsumerWidget {
  const BuildRecipeLoader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (ref
            .watch<SearchStateNotifier>(searchProvider)
            .searchTextController
            .text
            .length <
        3) {
      return Container();
    }
    return FutureBuilder<Response<Result<APIRecipeQuery>>>(
      // TODO: replace with new interface

      // future: Provider.of<RecipeService>(context).queryRecipes(
      //     searchTextController.text.trim(),
      //     currentStartPosition,
      //     currentEndPosition),
      future: ref.watch<MockService>(serviceProvider).queryRecipes(
          ref
              .read<SearchStateNotifier>(searchProvider)
              .searchTextController
              .text
              .trim(),
          ref.read<SearchStateNotifier>(searchProvider).currentStartPosition,
          ref.read<SearchStateNotifier>(searchProvider).currentEndPosition),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          inspect(snapshot.data);
          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
                textAlign: TextAlign.center,
                textScaleFactor: 1.3,
              ),
            );
          }

          // loading = false;
          // Hit an error
          if (false == snapshot.data?.isSuccessful) {
            var errorMessage = 'Problems getting data';
            if (snapshot.data?.error != null &&
                snapshot.data?.error is LinkedHashMap) {
              final map = snapshot.data?.error as LinkedHashMap;
              errorMessage = map['message'];
            }
            return Center(
              child: Text(
                errorMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18.0),
              ),
            );
          }
          final result = snapshot.data?.body;

          if (result == null || result is Error) {
            ref.read<SearchStateNotifier>(searchProvider).inErrorState = true;

            return const ReceiptList();
          }

          ref.read<SearchStateNotifier>(searchProvider).inErrorState = false;
          ref.read<SearchStateNotifier>(searchProvider).checkError(result);

          return const ReceiptList();
        } else {
          if (ref.watch<SearchStateNotifier>(searchProvider).currentCount ==
              0) {
            // Show a loading indicator while waiting for the movies
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return const ReceiptList();
          }
        }
      },
    );
  }
}

class ReceiptList extends ConsumerWidget {
  const ReceiptList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    const itemHeight = 310;
    final itemWidth = size.width / 2;
    return Flexible(
      child: GridView.builder(
        controller:
            ref.read<SearchStateNotifier>(searchProvider).scrollController,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: (itemWidth / itemHeight),
        ),
        itemCount: ref
            .watch<SearchStateNotifier>(searchProvider)
            .currentSearchList
            .length,
        itemBuilder: (BuildContext context, int index) {
          final recipe = ref
              .watch<SearchStateNotifier>(searchProvider)
              .currentSearchList[index]
              .recipe;

          return GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  final detailRecipe = Recipe(
                      label: recipe.label,
                      image: recipe.image,
                      url: recipe.url,
                      calories: recipe.calories,
                      totalTime: recipe.totalTime,
                      totalWeight: recipe.totalWeight);
                  detailRecipe.ingredients =
                      convertIngredients(recipe.ingredients);
                  return RecipeDetails(recipe: detailRecipe);
                },
              ));
            },
            child: recipeCard(recipe),
          );
        },
      ),
    );
  }
}
