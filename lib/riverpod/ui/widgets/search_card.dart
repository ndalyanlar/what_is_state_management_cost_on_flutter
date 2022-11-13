import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:what_is_state_management_cost_on_flutter/riverpod/providers/providers.dart';

import '../../../data/search_provider.dart';
import '../colors.dart';
import 'custom_dropdown.dart';

class SearchCard extends ConsumerWidget {
  const SearchCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 4,
      color: Colors.grey.shade50,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(8.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          children: [
            const SizedBox(
              width: 16.0,
            ),
            Expanded(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Search',
                      ),
                      autofocus: false,
                      textInputAction: TextInputAction.done,
                      onSubmitted: ref
                          .read<SearchStateNotifier>(searchProvider)
                          .onSubmitted,
                      controller: ref
                          .read<SearchStateNotifier>(searchProvider)
                          .searchTextController,
                    ),
                  ),
                  PopupMenuButton<String>(
                    enableFeedback: true,
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: lightGrey,
                    ),
                    onSelected: ref
                        .read<SearchStateNotifier>(searchProvider)
                        .onSelected,
                    itemBuilder: (BuildContext context) {
                      return ref
                          .read<SearchStateNotifier>(searchProvider)
                          .previousSearches
                          .map<CustomDropdownMenuItem<String>>((String value) {
                        return CustomDropdownMenuItem<String>(
                          text: value,
                          value: value,
                          callback: () {
                            ref
                                .read<SearchStateNotifier>(searchProvider)
                                .remove(value);
                            Navigator.pop(context);
                          },
                        );
                      }).toList();
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      final searchController = ref
                          .read<SearchStateNotifier>(searchProvider)
                          .searchTextController;
                      ref
                          .read<SearchStateNotifier>(searchProvider)
                          .startSearch(searchController.text);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
