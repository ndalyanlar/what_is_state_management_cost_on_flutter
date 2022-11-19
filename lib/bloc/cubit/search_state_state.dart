part of 'search_state_cubit.dart';

abstract class SearchStateState extends Equatable {
  const SearchStateState();

  @override
  List<Object> get props => [];
}

class SearchStateInitial extends SearchStateState {
  final SearchStateNotifier searchStateNotifier;
  const SearchStateInitial(this.searchStateNotifier);
}
