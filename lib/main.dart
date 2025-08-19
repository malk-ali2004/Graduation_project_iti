import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'blocs/auth_bloc/auth_bloc.dart';
import 'blocs/theme_bloc/theme_bloc.dart';
import 'blocs/favorites_bloc/favorites_bloc.dart';
import 'blocs/cart_bloc/cart_bloc.dart';
import 'blocs/auth_bloc/auth_event.dart';
import 'blocs/theme_bloc/theme_state.dart';
import 'screens/splash/splash_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc()..add(AppStarted())),
        BlocProvider(create: (_) => ThemeBloc()),
        BlocProvider(create: (_) => FavoritesBloc()),
        BlocProvider(create: (_) => CartBloc()),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp(
            title: 'Furniture Shop',
            debugShowCheckedModeBanner: false,
            theme: themeState.themeData,
            home: const SplashView(),
          );
        },
      ),
    );
  }
}
