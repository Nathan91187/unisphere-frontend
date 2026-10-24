
import 'package:firebase_auth/firebase_auth.dart';

class AuthRemoteDataSource {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Stream<User?> get authStateChanges => auth.userChanges();

  Future<void> registerWithEmailAndPassword(String email, String password, String displayName) async {
    final credential = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await credential.user?.updateDisplayName(displayName);
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
