import 'package:equatable/equatable.dart';
import '../../models/product.dart';

abstract class CartEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AddToCart extends CartEvent {
  final Product product;

  AddToCart(this.product);

  @override
  List<Object> get props => [product];
}

class RemoveFromCart extends CartEvent {
  final Product product;

  RemoveFromCart(this.product);

  @override
  List<Object> get props => [product];
}

class IncreaseQuantity extends CartEvent {
  final Product product;

  IncreaseQuantity(this.product);

  @override
  List<Object> get props => [product];
}

class DecreaseQuantity extends CartEvent {
  final Product product;

  DecreaseQuantity(this.product);

  @override
  List<Object> get props => [product];
}
