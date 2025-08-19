// import 'package:equatable/equatable.dart';
// import '../../models/product.dart';

// class CartItem extends Equatable {
//   final Product product;
//   final int quantity;

//   const CartItem({required this.product, this.quantity = 1});

//   CartItem copyWith({int? quantity}) {
//     return CartItem(product: product, quantity: quantity ?? this.quantity);
//   }

//   @override
//   List<Object> get props => [product, quantity];
// }

// class CartState extends Equatable {
//   final List<CartItem> items;

//   const CartState({this.items = const []});

//   CartState copyWith({List<CartItem>? items}) {
//     return CartState(items: items ?? this.items);
//   }

//   @override
//   List<Object> get props => [items];
// }

import 'package:equatable/equatable.dart';
import '../../models/product.dart';

class CartItem extends Equatable {
  final Product product;
  final int quantity;

  const CartItem({required this.product, this.quantity = 1});

  CartItem copyWith({int? quantity}) {
    return CartItem(product: product, quantity: quantity ?? this.quantity);
  }

  Map<String, dynamic> toMap() {
    return {
      "productId": product.id,
      "name": product.name,
      "image": product.image,
      "price": product.price,
      "quantity": quantity,
    };
  }

  @override
  List<Object?> get props => [product, quantity];
}

class CartState extends Equatable {
  final List<CartItem> items;

  const CartState({this.items = const []});

  CartState copyWith({List<CartItem>? items}) {
    return CartState(items: items ?? this.items);
  }

  @override
  List<Object?> get props => [items];
}
