part of 'memory_bloc_bloc.dart';

abstract class MemoryBlocState extends Equatable {
  const MemoryBlocState();

  @override
  List<Object> get props => [];
}

class MemoryBlocInitial extends MemoryBlocState {}
