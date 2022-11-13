part of 'memory_cubit.dart';

abstract class MemoryState extends Equatable {
  const MemoryState();

  @override
  List<Object> get props => [];
}

class MemoryInitial extends MemoryState {
  final MemoryRepository repository;
  const MemoryInitial(this.repository);
}
