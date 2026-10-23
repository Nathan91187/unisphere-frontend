

import '../../domain/entities/user.dart';

abstract class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState{
  const AuthInitial();
}
class AuthLoading extends AuthState{
  const AuthLoading();
}
class AuthError extends AuthState{
  final String errorMsg;
  const AuthError({required this.errorMsg});
}
class Authenticated extends AuthState{
  final User user;
  const Authenticated({required this.user});
}
class Unauthenticated extends AuthState{
  const Unauthenticated();
}