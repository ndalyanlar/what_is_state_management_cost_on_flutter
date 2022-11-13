import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:what_is_state_management_cost_on_flutter/data/search_provider.dart';

part 'search_state_state.dart';

class SearchStateCubit extends Cubit<SearchStateState> {
  SearchStateCubit(SearchStateNotifier searchStateNotifier)
      : super(SearchStateInitial(searchStateNotifier));
}
