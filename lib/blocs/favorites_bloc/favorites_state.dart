import 'package:equatable/equatable.dart';
import '../../models/product.dart';

class FavoritesState extends Equatable {
  final List<Product> favorites;

  const FavoritesState({this.favorites = const []});

  FavoritesState copyWith({List<Product>? favorites}) {
    return FavoritesState(favorites: favorites ?? this.favorites);
  }

  @override
  List<Object> get props => [favorites];
}
