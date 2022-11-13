import 'package:flutter/material.dart';

import '../../../data/memory_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShoppingList extends StatefulWidget {
  const ShoppingList({Key? key}) : super(key: key);

  @override
  State<ShoppingList> createState() => _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList> {
  final checkBoxValues = <int, bool>{};

  @override
  Widget build(BuildContext context) {
    final ingredients = context.watch<MemoryRepository>().findAllIngredients();
    return ListView.builder(
        itemCount: ingredients.length,
        itemBuilder: (BuildContext context, int index) {
          return CheckboxListTile(
            value: checkBoxValues.containsKey(index) && checkBoxValues[index]!,
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
  }
}
