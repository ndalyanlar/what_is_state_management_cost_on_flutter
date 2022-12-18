import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'memory_bloc_event.dart';
part 'memory_bloc_state.dart';

class MemoryBlocBloc extends Bloc<MemoryBlocEvent, MemoryBlocState> {
  MemoryBlocBloc() : super(MemoryBlocInitial()) {
    on<MemoryBlocEvent>((event, emit) async {});
  }
}
