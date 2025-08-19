

import 'package:equatable/equatable.dart';
import '../../models/product.dart';

abstract class CartEvent extends Equatable {
  @override
  List<Object?> get props => [];
}


class LoadCart extends CartEvent {
  final String userId;
  LoadCart(this.userId);

  @override
  List<Object?> get props => [userId];
}

class AddToCart extends CartEvent {
  final String userId;
  final Product product;

  AddToCart(this.userId, this.product);

  @override
  List<Object?> get props => [userId, product];
}

class RemoveFromCart extends CartEvent {
  final String userId;
  final Product product;

  RemoveFromCart(this.userId, this.product);

  @override
  List<Object?> get props => [userId, product];
}

class IncreaseQuantity extends CartEvent {
  final String userId;
  final Product product;

  IncreaseQuantity(this.userId, this.product);

  @override
  List<Object?> get props => [userId, product];
}

class DecreaseQuantity extends CartEvent {
  final String userId;
  final Product product;
  DecreaseQuantity(this.userId, this.product);
  @override
  List<Object?> get props => [userId, product];
}
