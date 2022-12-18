import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/search_provider.dart';
import '../colors.dart';
import 'custom_dropdown.dart';

class SearchCard extends StatefulWidget {
  const SearchCard({
    Key? key,
  }) : super(key: key);

  @override
  State<SearchCard> createState() => _SearchCardState();
}

class _SearchCardState extends State<SearchCard> {
  @override
  Widget build(BuildContext context) {
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
                      onSubmitted:
                          context.read<SearchStateNotifier>().onSubmitted,
                      controller: context
                          .read<SearchStateNotifier>()
                          .searchTextController,
                    ),
                  ),
                  PopupMenuButton<String>(
                    enableFeedback: true,
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: lightGrey,
                    ),
                    onSelected: context.read<SearchStateNotifier>().onSelected,
                    itemBuilder: (BuildContext context) {
                      return context
                          .read<SearchStateNotifier>()
                          .previousSearches
                          .map<CustomDropdownMenuItem<String>>((String value) {
                        return CustomDropdownMenuItem<String>(
                          text: value,
                          value: value,
                          callback: () {
                            context.read<SearchStateNotifier>().remove(value);
                            Navigator.pop(context);
                          },
                        );
                      }).toList();
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      final searchText = context
                          .read<SearchStateNotifier>()
                          .searchTextController
                          .text;
                      context
                          .read<SearchStateNotifier>()
                          .startSearch(searchText);
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
