import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/auth_bloc/auth_bloc.dart';
import '../../blocs/auth_bloc/auth_state.dart';
import '../../blocs/auth_bloc/auth_event.dart';
import '../../blocs/theme_bloc/theme_bloc.dart';
import '../../blocs/theme_bloc/theme_event.dart';
import '../../blocs/theme_bloc/theme_state.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  Future<String?> getUserName(String userId) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      return doc.data()?['name'] ?? 'No Name';
    } catch (e) {
      return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: Colors.amber,
        centerTitle: true,
        
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is Authenticated) {
            return FutureBuilder<String?>(
              future: getUserName(state.userId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final name = snapshot.data ?? 'No Name';

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundImage:
                          AssetImage('assets/avatar_placeholder.png'),
                    ),
                    const SizedBox(height: 20),
                    Text(name, style: const TextStyle(fontSize: 20)),
                    const SizedBox(height: 10),
                    Text(state.userEmail),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        context.read<AuthBloc>().add(LoggedOut());
                      },
                      child: const Text('Log Out'),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: () {
                        context.read<ThemeBloc>().add(ToggleTheme());
                      },
                      icon: BlocBuilder<ThemeBloc, ThemeState>(
                        builder: (context, themeState) {
                          return Icon(themeState.isDark
                              ? Icons.light_mode
                              : Icons.dark_mode);
                        },
                      ),
                      label: BlocBuilder<ThemeBloc, ThemeState>(
                        builder: (context, themeState) {
                          return Text(themeState.isDark
                              ? 'Light Mode'
                              : 'Dark Mode');
                        },
                      ),
                    ),
                  ],
                );
              },
            );
          } else if (state is AuthError) {
            return Center(child: Text(state.message));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
