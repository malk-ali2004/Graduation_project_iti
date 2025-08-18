import 'package:equatable/equatable.dart';
import '../../models/product.dart';

abstract class FavoritesEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ToggleFavorite extends FavoritesEvent {
  final Product product;

  ToggleFavorite(this.product);

  @override
  List<Object> get props => [product];
}
