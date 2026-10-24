import 'package:uni_sphere/features/auth/domain/entities/user.dart';

abstract class AuthEvent {
  const AuthEvent();
}

class RegisterRequested extends AuthEvent{
  final String email;
  final String password;
  final String displayName;
  const RegisterRequested({
    required this.email,
    required this.password,
    required this.displayName
});
}
class SignInRequested extends AuthEvent{
  final String email;
  final String password;
  const SignInRequested({
    required this.email,
    required this.password
  });
}
class SignOutRequested extends AuthEvent{
  const SignOutRequested();
}
class AuthStateChangeDetected extends AuthEvent{
  final User? user;
  const AuthStateChangeDetected({required this.user});
}