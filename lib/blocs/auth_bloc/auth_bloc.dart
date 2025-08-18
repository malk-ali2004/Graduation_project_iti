import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthBloc() : super(AuthInitial()) {
    on<AppStarted>((event, emit) async {
      final user = _auth.currentUser;
      if (user != null) {
        emit(Authenticated(userEmail: user.email ?? '', userId: user.uid));
      } else {
        emit(Unauthenticated());
      }
    });

    on<LoggedIn>((event, emit) async {
      try {
        final credential = await _auth.signInWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );
        final user = credential.user;
        if (user != null) {
          emit(Authenticated(userEmail: user.email ?? '', userId: user.uid));
        } else {
          emit(Unauthenticated());
        }
      } on FirebaseAuthException catch (e) {
        emit(AuthError(e.message ?? 'Login failed'));
        emit(Unauthenticated());
      }
    });

    on<SignUpRequested>((event, emit) async {
      try {
        final credential = await _auth.createUserWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );
        final user = credential.user;
        if (user != null) {
      
          emit(Authenticated(userEmail: user.email ?? '', userId: user.uid));
        } else {
          emit(Unauthenticated());
        }
      } on FirebaseAuthException catch (e) {
        emit(AuthError(e.message ?? 'Signup failed'));
        emit(Unauthenticated());
      }
    });

    on<LoggedOut>((event, emit) async {
      await _auth.signOut();
      emit(Unauthenticated());
    });
  }
}


