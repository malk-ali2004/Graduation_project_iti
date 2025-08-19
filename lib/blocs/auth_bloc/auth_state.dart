import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class Authenticated extends AuthState {
  final String userEmail;
  final String userId;

  Authenticated({required this.userEmail, required this.userId});

  @override
  List<Object?> get props => [userEmail, userId];
}
class Unauthenticated extends AuthState {}
class AuthError extends AuthState {
  final String message;

  AuthError(this.message);


  @override
  List<Object?> get props => [message];
}

