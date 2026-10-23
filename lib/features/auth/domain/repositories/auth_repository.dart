import 'package:uni_sphere/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  Future<void> signInWithEmailAndPassword({required String email, required String password});
  Future<void> registerWithEmailAndPassword({required String email, required String password});
  Future<void> signOut();
  Stream<User?> get authStateChanges;
}