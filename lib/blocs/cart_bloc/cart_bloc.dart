import 'package:bloc/bloc.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(const CartState()) {
    on<AddToCart>((event, emit) {
      final items = List<CartItem>.from(state.items);
      final index = items.indexWhere((item) => item.product == event.product);

      if (index == -1) {
        items.add(CartItem(product: event.product, quantity: 1));
      } else {
        final item = items[index];
        items[index] = item.copyWith(quantity: item.quantity + 1);
      }

      emit(state.copyWith(items: items));
    });

    on<RemoveFromCart>((event, emit) {
      final items = List<CartItem>.from(state.items);
      items.removeWhere((item) => item.product == event.product);
      emit(state.copyWith(items: items));
    });

    on<IncreaseQuantity>((event, emit) {
      final items = List<CartItem>.from(state.items);
      final index = items.indexWhere((item) => item.product == event.product);
      if (index != -1) {
        final item = items[index];
        items[index] = item.copyWith(quantity: item.quantity + 1);
        emit(state.copyWith(items: items));
      }
    });

    on<DecreaseQuantity>((event, emit) {
      final items = List<CartItem>.from(state.items);
      final index = items.indexWhere((item) => item.product == event.product);
      if (index != -1) {
        final item = items[index];
        if (item.quantity > 1) {
          items[index] = item.copyWith(quantity: item.quantity - 1);
          emit(state.copyWith(items: items));
        } else {
          items.removeAt(index);
          emit(state.copyWith(items: items));
        }
      }
    });
  }
}
