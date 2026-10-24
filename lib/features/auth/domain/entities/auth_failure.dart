enum AuthFailureType {
  invalidCredentials,
  emailAlreadyInUse,
  weakPassword,
  network,
  unknown,
}

class AuthFailure implements Exception {
  final AuthFailureType type;

  const AuthFailure(this.type);
}