import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:what_is_state_management_cost_on_flutter/riverpod/providers/providers.dart';

import '../../../data/models/recipe.dart';
import '../../../data/memory_repository.dart';

class MyRecipesList extends StatefulWidget {
  const MyRecipesList({Key? key}) : super(key: key);

  @override
  State<MyRecipesList> createState() => _MyRecipesListState();
}

class _MyRecipesListState extends State<MyRecipesList> {
  List<Recipe> recipes = [];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: _buildRecipeList(context),
    );
  }

  Widget _buildRecipeList(BuildContext context) {
    return Consumer(builder: (context, repository, child) {
      recipes =
          repository.watch<MemoryRepository>(memoryProvider).findAllRecipes();
      return ListView.builder(
          itemCount: recipes.length,
          itemBuilder: (BuildContext context, int index) {
            final recipe = recipes[index];
            return SizedBox(
              height: 100,
              child: Slidable(
                actionPane: const SlidableDrawerActionPane(),
                actionExtentRatio: 0.25,
                actions: <Widget>[
                  IconSlideAction(
                      caption: 'Delete',
                      color: Colors.transparent,
                      foregroundColor: Colors.black,
                      iconWidget: const Icon(Icons.delete, color: Colors.red),
                      onTap: () => repository
                          .read<MemoryRepository>(memoryProvider)
                          .deleteRecipe(recipe)),
                ],
                secondaryActions: <Widget>[
                  IconSlideAction(
                      caption: 'Delete',
                      color: Colors.transparent,
                      foregroundColor: Colors.black,
                      iconWidget: const Icon(Icons.delete, color: Colors.red),
                      onTap: () => repository
                          .read<MemoryRepository>(memoryProvider)
                          .deleteRecipe(recipe)),
                ],
                child: Card(
                  elevation: 1.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  color: Colors.white,
                  child: Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        leading: CachedNetworkImage(
                            imageUrl: recipe.image ?? '',
                            height: 120,
                            width: 60,
                            fit: BoxFit.cover),
                        title: Text(recipe.label ?? ''),
                      ),
                    ),
                  ),
                ),
              ),
            );
          });
    });
  }

  // void deleteRecipe(MemoryRepository repository, Recipe recipe) async {
  //   if (recipe.label != null) {
  //     repository.deleteIngredients(recipe.ingredients ?? []);
  //     repository.deleteRecipe(recipe);
  //     setState(() {});
  //   } else {
  //     debugPrint('Recipe id is null');
  //   }
  // }
}
