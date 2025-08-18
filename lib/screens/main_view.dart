
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../blocs/auth_bloc/auth_bloc.dart';
import '../blocs/auth_bloc/auth_state.dart';
import '../screens/cart/cart_view.dart';
import '../screens/profile/profile_view.dart';
import '../screens/favorites/favorites_view.dart';
import '../widgets/product_card.dart';
import '../models/product.dart';
import 'auth/login_view.dart';

class MainView extends StatefulWidget {
  final String userEmail;

  const MainView({super.key, required this.userEmail});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int _currentIndex = 0;
  String? userName;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _fetchUserName();
    _screens = [
      MainHomeView(userName: userName ?? widget.userEmail),
      const FavoritesView(),
      const CartView(),
      const ProfileView(),
    ];
  }

  Future<void> _fetchUserName() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userEmail)
          .get();
      if (doc.exists && doc.data() != null) {
        setState(() {
          userName = doc['name'];
          _screens[0] = MainHomeView(userName: userName ?? widget.userEmail);
        });
      }
    } catch (e) {
      debugPrint("Error fetching user name: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Unauthenticated) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const LoginView()),
            (route) => false,
          );
        }
      },
      child: Scaffold(
        body: _screens[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          selectedItemColor: Colors.yellow[800],
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.chair_alt),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border),
              label: 'Favorites',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_outlined),
              label: 'Cart',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

class MainHomeView extends StatelessWidget {
  final String userName;

  const MainHomeView({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[100],
      drawer: Drawer(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.transparent,
                    backgroundImage:
                        AssetImage('assets/avatar_placeholder.png'),
                  ),
                 
                ],
              ),
              const SizedBox(height: 20),
              Text('Hello, $userName',
                  style: const TextStyle(
                      fontSize: 26, fontWeight: FontWeight.bold)),
              const Text('What do you want to buy?',
                  style: TextStyle(fontSize: 16)),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    icon: Icon(Icons.search),
                    hintText: 'Search',
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  CategoryItem(icon: Icons.chair, label: 'Sofas'),
                  CategoryItem(icon: Icons.bed, label: 'Wardrobe'),
                  CategoryItem(icon: Icons.table_bar, label: 'Desk'),
                  CategoryItem(icon: FontAwesomeIcons.chair, label: 'Dresser'),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView(
                  children: [
                    ProductCard(
                      product: Product(
                        id: '1',
                        name: 'FinnNavian',
                        price: 248,
                        image: 'assets/1.png',
                      ),
                    ),
                    ProductCard(
                      product: Product(
                        id: '2',
                        name: 'Modern Chair',
                        price: 120,
                        image: 'assets/2.jpeg',
                      ),
                    ),
                    ProductCard(
                      product: Product(
                        id: '3',
                        name: 'FinnNavian',
                        price: 248,
                        image: 'assets/3.jpeg',
                      ),
                    ),
                    ProductCard(
                      product: Product(
                        id: '4',
                        name: 'FinnNavian',
                        price: 248,
                        image: 'assets/4.jpeg',
                      ),
                    ),
                    ProductCard(
                      product: Product(
                        id: '5',
                        name: 'FinnNavian',
                        price: 248,
                        image: 'assets/5.jpeg',
                      ),
                    ),
                    ProductCard(
                      product: Product(
                        id: '6',
                        name: 'FinnNavian',
                        price: 248,
                        image: 'assets/6.jpeg',
                      ),
                    ),
                    ProductCard(
                      product: Product(
                        id: '7',
                        name: 'FinnNavian',
                        price: 248,
                        image: 'assets/7.jpeg',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const CategoryItem({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 30),
        const SizedBox(height: 4),
        Text(label),
      ],
    );
  }
}

