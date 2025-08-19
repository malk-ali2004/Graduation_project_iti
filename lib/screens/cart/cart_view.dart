




import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/cart_bloc/cart_bloc.dart';
import '../../blocs/cart_bloc/cart_state.dart';
import '../../blocs/cart_bloc/cart_event.dart';
import '../../blocs/auth_bloc/auth_bloc.dart';
import '../../blocs/auth_bloc/auth_state.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) {
      context.read<CartBloc>().add(LoadCart(authState.userId));
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;

    if (authState is! Authenticated) {
      return const Scaffold(
        body: Center(child: Text("Please login to view your cart.")),
      );
    }

    final userId = authState.userId;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state.items.isEmpty) {
            return const Center(child: Text('Your cart is empty.'));
          }

          return ListView.builder(
            itemCount: state.items.length,
            itemBuilder: (context, index) {
              final item = state.items[index];

              final imageProvider = item.product.image.startsWith('http')
                  ? NetworkImage(item.product.image)
                  : AssetImage(item.product.image) as ImageProvider;

              return ListTile(
                leading: Image(
                  image: imageProvider,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.broken_image),
                ),
                title: Text(item.product.name),
                subtitle: Text('Quantity: ${item.quantity}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () {
                        context
                            .read<CartBloc>()
                            .add(DecreaseQuantity(userId, item.product));
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        context
                            .read<CartBloc>()
                            .add(IncreaseQuantity(userId, item.product));
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        context
                            .read<CartBloc>()
                            .add(RemoveFromCart(userId, item.product));
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
