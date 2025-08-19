

// import 'package:bloc/bloc.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'cart_event.dart';
// import 'cart_state.dart';
// import '../../models/product.dart';


// class CartBloc extends Bloc<CartEvent, CartState> {
//   final FirebaseFirestore firestore = FirebaseFirestore.instance;

//   CartBloc() : super(const CartState()) {
   
//     on<LoadCart>((event, emit) async {
//       final snapshot = await firestore
//           .collection("carts")
//           .doc(event.userId)
//           .collection("items")
//           .get();

//       final items = snapshot.docs.map((doc) {
//         final data = doc.data();
//         return CartItem(
//           product: Product(
//             id: data["productId"],
//             name: data["name"],
//             image: data["image"],
//             price: (data["price"] as num).toDouble(),
//           ),
//           quantity: data["quantity"],
//         );
//       }).toList();

//       emit(CartState(items: items));
//     });

//     on<AddToCart>((event, emit) async {
//       final items = List<CartItem>.from(state.items);
//       final index = items.indexWhere((i) => i.product.id == event.product.id);

//       if (index == -1) {
//         items.add(CartItem(product: event.product, quantity: 1));
//       } else {
//         final item = items[index];
//         items[index] = item.copyWith(quantity: item.quantity + 1);
//       }

//       emit(state.copyWith(items: items));
//       await _saveCartToFirestore(event.userId, items);
//     });


//     on<RemoveFromCart>((event, emit) async {
//       final items =
//           state.items.where((i) => i.product.id != event.product.id).toList();
//       emit(state.copyWith(items: items));
//       await _saveCartToFirestore(event.userId, items);
//     });
    
//     on<IncreaseQuantity>((event, emit) async {
//       final items = List<CartItem>.from(state.items);
//       final index = items.indexWhere((i) => i.product.id == event.product.id);
//       if (index != -1) {
//         final item = items[index];
//         items[index] = item.copyWith(quantity: item.quantity + 1);
//         emit(state.copyWith(items: items));
//         await _saveCartToFirestore(event.userId, items);
//       }
//     });
//     on<DecreaseQuantity>((event, emit) async {
//       final items = List<CartItem>.from(state.items);
//       final index = items.indexWhere((i) => i.product.id == event.product.id);
//       if (index != -1) {
//         final item = items[index];
//         if (item.quantity > 1) {
//           items[index] = item.copyWith(quantity: item.quantity - 1);
//         } else {
//           items.removeAt(index);
//         }
//         emit(state.copyWith(items: items));
//         await _saveCartToFirestore(event.userId, items);
//       }
//     });
//   }

//   Future<void> _saveCartToFirestore(String userId, List<CartItem> items) async {
//     final cartRef = firestore.collection("carts").doc(userId).collection("items");
//     final oldDocs = await cartRef.get();
//     for (var doc in oldDocs.docs) {
//       await doc.reference.delete();
//     }
//     for (var item in items) {
//       await cartRef.doc(item.product.id).set(item.toMap());
//     }
//   }
// }

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'cart_event.dart';
import 'cart_state.dart';
import '../../models/product.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  CartBloc() : super(const CartState()) {
    // ✅ LoadCart with real-time updates
    on<LoadCart>((event, emit) async {
      firestore
          .collection("carts")
          .doc(event.userId)
          .collection("items")
          .snapshots()
          .listen((snapshot) {
        final items = snapshot.docs.map((doc) {
          final data = doc.data();
          return CartItem(
            product: Product(
              id: data["productId"],
              name: data["name"],
              image: data["image"],
              price: (data["price"] as num).toDouble(),
            ),
            quantity: data["quantity"],
          );
        }).toList();

        emit(CartState(items: items));
      });
    });

    // ✅ AddToCart
    on<AddToCart>((event, emit) async {
      final items = List<CartItem>.from(state.items);
      final index = items.indexWhere((i) => i.product.id == event.product.id);

      if (index == -1) {
        items.add(CartItem(product: event.product, quantity: 1));
      } else {
        final item = items[index];
        items[index] = item.copyWith(quantity: item.quantity + 1);
      }

      emit(state.copyWith(items: items));
      await _saveCartToFirestore(event.userId, items);
    });

    // ✅ RemoveFromCart
    on<RemoveFromCart>((event, emit) async {
      final items =
          state.items.where((i) => i.product.id != event.product.id).toList();
      emit(state.copyWith(items: items));
      await _saveCartToFirestore(event.userId, items);
    });

    // ✅ IncreaseQuantity
    on<IncreaseQuantity>((event, emit) async {
      final items = List<CartItem>.from(state.items);
      final index = items.indexWhere((i) => i.product.id == event.product.id);
      if (index != -1) {
        final item = items[index];
        items[index] = item.copyWith(quantity: item.quantity + 1);
        emit(state.copyWith(items: items));
        await _saveCartToFirestore(event.userId, items);
      }
    });

    // ✅ DecreaseQuantity
    on<DecreaseQuantity>((event, emit) async {
      final items = List<CartItem>.from(state.items);
      final index = items.indexWhere((i) => i.product.id == event.product.id);
      if (index != -1) {
        final item = items[index];
        if (item.quantity > 1) {
          items[index] = item.copyWith(quantity: item.quantity - 1);
        } else {
          items.removeAt(index);
        }
        emit(state.copyWith(items: items));
        await _saveCartToFirestore(event.userId, items);
      }
    });
  }

  // ✅ تحديث العناصر بشكل انتقائى بدلاً من مسح الكارت كله
  Future<void> _saveCartToFirestore(String userId, List<CartItem> items) async {
    final cartRef =
        firestore.collection("carts").doc(userId).collection("items");

    // امسح المنتجات اللى اتشالت من اللستة
    final snapshot = await cartRef.get();
    for (var doc in snapshot.docs) {
      final exists = items.any((item) => item.product.id == doc.id);
      if (!exists) {
        await doc.reference.delete();
      }
    }

    // حدّث أو أضف المنتجات الموجودة
    for (var item in items) {
      await cartRef.doc(item.product.id).set(item.toMap());
    }
  }
}
