import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:what_is_state_management_cost_on_flutter/riverpod/providers/providers.dart';

import '../../../data/memory_repository.dart';

class ShoppingList extends StatefulWidget {
  const ShoppingList({Key? key}) : super(key: key);

  @override
  State<ShoppingList> createState() => _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList> {
  final checkBoxValues = <int, bool>{};

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, repositoryRef, child) {
      final ingredients = repositoryRef
          .watch<MemoryRepository>(memoryProvider)
          .findAllIngredients();
      return ListView.builder(
          itemCount: ingredients.length,
          itemBuilder: (BuildContext context, int index) {
            return CheckboxListTile(
              value:
                  checkBoxValues.containsKey(index) && checkBoxValues[index]!,
              title: Text(ingredients[index].name ?? ''),
              onChanged: (newValue) {
                if (newValue != null) {
                  setState(() {
                    checkBoxValues[index] = newValue;
                  });
                }
              },
            );
          });
    });
  }
}
