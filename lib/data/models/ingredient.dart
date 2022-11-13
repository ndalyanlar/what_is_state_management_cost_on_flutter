import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class Ingredient extends Equatable {
  int? id;
  int? foodId;
  final String? name;
  final double? weight;

  Ingredient({this.id, this.foodId, this.name, this.weight});

  @override
  List<Object?> get props => [foodId, name, weight];
}
