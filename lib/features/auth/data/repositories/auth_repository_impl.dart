import 'package:uni_sphere/features/auth/data/datasource/auth_remote_data_source.dart';
import 'package:uni_sphere/features/auth/domain/entities/user.dart';
import 'package:uni_sphere/features/auth/domain/repositories/auth_repository.dart';

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
  Future<void> registerWithEmailAndPassword({required String email, required String password}) async{
    await authRemoteDataSource.registerWithEmailAndPassword(email, password);
  }

  @override
  Future<void> signInWithEmailAndPassword({required String email, required String password}) async{
    await authRemoteDataSource.signInWithEmailAndPassword(email, password);
  }

  @override
  Future<void> signOut() async{
   await authRemoteDataSource.signOut();
  }

}