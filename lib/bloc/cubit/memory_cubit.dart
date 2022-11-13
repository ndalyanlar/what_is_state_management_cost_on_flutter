import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:what_is_state_management_cost_on_flutter/data/memory_repository.dart';

part 'memory_state.dart';

class MemoryCubit extends Cubit<MemoryState> {
  MemoryCubit(MemoryRepository repo) : super(MemoryInitial(repo));
}
