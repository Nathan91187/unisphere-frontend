
import 'package:firebase_auth/firebase_auth.dart';

class AuthRemoteDataSource {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Stream<User?> get authStateChanges => auth.authStateChanges();

  Future<void> registerWithEmailAndPassword(String email, String password) async {
    await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await auth.signOut();
  }
}
