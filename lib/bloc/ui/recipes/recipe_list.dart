import 'dart:collection';
import 'dart:developer';
import 'dart:math';

import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:what_is_state_management_cost_on_flutter/network/recipe_service.dart';
import '../../../data/search_provider.dart';
import '../widgets/custom_dropdown.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/models/models.dart';
import '../../../mock_service/mock_service.dart';
import '../../../network/model_response.dart';
import '../../../network/recipe_model.dart';
import '../colors.dart';
import '../recipe_card.dart';
import '../recipes/recipe_details.dart';
import '../widgets/search_card.dart';

class RecipeList extends StatefulWidget {
  const RecipeList({Key? key}) : super(key: key);

  @override
  State<RecipeList> createState() => _RecipeListState();
}

class _RecipeListState extends State<RecipeList> {
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
    context.read<SearchStateNotifier>().getPreviousSearches();
    // _scrollController = ScrollController();
    // // getPreviousSearches();

    // searchTextController = TextEditingController(text: '');
    // _scrollController.addListener(() {
    //   final triggerFetchMoreSize =
    //       0.7 * _scrollController.position.maxScrollExtent;

    //   if (_scrollController.position.pixels > triggerFetchMoreSize) {
    //     if (hasMore &&
    //         currentEndPosition < currentCount &&
    //         !loading &&
    //         !inErrorState) {
    //       setState(() {
    //         loading = true;
    //         currentStartPosition = currentEndPosition;
    //         currentEndPosition =
    //             min(currentStartPosition + pageCount, currentCount);
    //       });
    //     }
    //   }
    // });
  }

  @override
  void dispose() {
    context.read<SearchStateNotifier>().dispose();
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
          children: <Widget>[
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

class BuildRecipeLoader extends StatelessWidget {
  const BuildRecipeLoader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (context.watch<SearchStateNotifier>().searchTextController.text.length <
        3) {
      return Container();
    }
    return FutureBuilder<Response<Result<APIRecipeQuery>>>(
      // TODO: replace with new interface

      // future: Provider.of<RecipeService>(context).queryRecipes(
      //     searchTextController.text.trim(),
      //     currentStartPosition,
      //     currentEndPosition),
      future: context.read<MockService>().queryRecipes(
          context.read<SearchStateNotifier>().searchTextController.text.trim(),
          context.read<SearchStateNotifier>().currentStartPosition,
          context.read<SearchStateNotifier>().currentEndPosition),
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
            context.read<SearchStateNotifier>().inErrorState = true;

            return const ReceiptList();
          }

          context.read<SearchStateNotifier>().inErrorState = false;
          context.read<SearchStateNotifier>().checkError(result);

          return const ReceiptList();
        } else {
          if (context.watch<SearchStateNotifier>().currentCount == 0) {
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

class ReceiptList extends StatelessWidget {
  const ReceiptList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    const itemHeight = 310;
    final itemWidth = size.width / 2;
    return Flexible(
      child: GridView.builder(
        controller: context.read<SearchStateNotifier>().scrollController,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: (itemWidth / itemHeight),
        ),
        itemCount:
            context.watch<SearchStateNotifier>().currentSearchList.length,
        itemBuilder: (BuildContext context, int index) {
          final recipe = context
              .watch<SearchStateNotifier>()
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
