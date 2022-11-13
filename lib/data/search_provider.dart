import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../network/model_response.dart';
import '../network/recipe_model.dart';

class SearchStateNotifier extends ChangeNotifier {
  SearchStateNotifier() {
    getPreviousSearches();
    scrollController = ScrollController();
    searchTextController = TextEditingController(text: '');
    scrollController.addListener(() {
      final triggerFetchMoreSize =
          0.7 * scrollController.position.maxScrollExtent;

      if (scrollController.position.pixels > triggerFetchMoreSize) {
        if (hasMore &&
            currentEndPosition < currentCount &&
            !loading &&
            !inErrorState) {
          loading = true;
          currentStartPosition = currentEndPosition;
          currentEndPosition =
              min(currentStartPosition + pageCount, currentCount);
          notifyListeners();
        }
      }
    });
  }

  late TextEditingController searchTextController;
  late final ScrollController scrollController;
  List<APIHits> currentSearchList = [];
  int currentCount = 0;
  int currentStartPosition = 0;
  int currentEndPosition = 20;
  int pageCount = 20;
  bool hasMore = false;
  bool loading = false;
  bool inErrorState = false;
  List<String> previousSearches = <String>[];
  static const String prefSearchKey = 'previousSearches';

  void getPreviousSearches() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(prefSearchKey)) {
      final searches = prefs.getStringList(prefSearchKey);
      if (searches != null) {
        previousSearches = searches;
      } else {
        previousSearches = <String>[];
      }
      notifyListeners();
    }
  }

  void checkError(result) {
    final query = (result as Success).value;
    inErrorState = false;
    if (query != null) {
      currentCount = query.count;
      // hasMore = query.more;
      currentSearchList.addAll(query.hits);
      if (query.to < currentEndPosition) {
        currentEndPosition = query.to;
      }
    }
  }

  void savePreviousSearches() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList(prefSearchKey, previousSearches);
  }

  void onSelected(String? value) {
    searchTextController.text = value!;
    startSearch(searchTextController.text);
  }

  void onSubmitted(String value) {
    if (!previousSearches.contains(value)) {
      previousSearches.add(value);
      savePreviousSearches();
    }

    notifyListeners();
  }

  void remove(String value) {
    previousSearches.remove(value);
    notifyListeners();
  }

  @override
  void dispose() {
    searchTextController.dispose();
    super.dispose();
  }

  void startSearch(String value) {
    currentSearchList.clear();
    currentCount = 0;
    currentEndPosition = pageCount;
    currentStartPosition = 0;
    hasMore = true;
    value = value.trim();
    onSubmitted(value);
    notifyListeners();
  }
}
