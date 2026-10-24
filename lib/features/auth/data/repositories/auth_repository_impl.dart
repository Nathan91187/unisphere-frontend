import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:uni_sphere/features/auth/data/datasource/auth_remote_data_source.dart';
import 'package:uni_sphere/features/auth/domain/entities/user.dart';
import 'package:uni_sphere/features/auth/domain/repositories/auth_repository.dart';

import '../../domain/entities/auth_failure.dart';

class AuthRepositoryImpl implements AuthRepository{
  final AuthRemoteDataSource authRemoteDataSource;
  const AuthRepositoryImpl({required this.authRemoteDataSource});
  @override
  Stream<User?> get authStateChanges {
    return authRemoteDataSource.authStateChanges.map((user){
      if(user == null){
        return null;
      }
      return User(
          uid: user.uid,
          displayName: user.displayName,
          email: user.email,
          profileImageUrl: user.photoURL
      );
    });
  }

  @override
  Future<void> registerWithEmailAndPassword({required String email, required String password, required displayName}) async{
    try {
      await authRemoteDataSource.registerWithEmailAndPassword(email, password, displayName);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthFailure(_mapFirebaseError(e.code));
    }
  }

  @override
  Future<void> signInWithEmailAndPassword({required String email, required String password}) async{
    try {
      await authRemoteDataSource.signInWithEmailAndPassword(email, password);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthFailure(_mapFirebaseError(e.code));
    }
  }

  @override
  Future<void> signOut() async{
    try {
      await authRemoteDataSource.signOut();
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthFailure(_mapFirebaseError(e.code));
    }
  }
  static const Map<String, AuthFailureType> _firebaseErrorMap = {
    'invalid-credential': AuthFailureType.invalidCredentials,
    'email-already-in-use': AuthFailureType.emailAlreadyInUse,
    'weak-password': AuthFailureType.weakPassword,
    'network-request-failed': AuthFailureType.network,
  };

  AuthFailureType _mapFirebaseError(String code) {
    return _firebaseErrorMap[code] ?? AuthFailureType.unknown;
  }
}