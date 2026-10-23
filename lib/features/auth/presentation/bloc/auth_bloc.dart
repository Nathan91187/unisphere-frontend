import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uni_sphere/features/auth/domain/repositories/auth_repository.dart';
import 'package:uni_sphere/features/auth/presentation/bloc/auth_event.dart';
import 'package:uni_sphere/features/auth/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState>{
  final AuthRepository repository;
  late final StreamSubscription _authSubscription;
  final unableToConnect = "Unable to connect. Please try again";
  AuthBloc({required this.repository}):super(AuthInitial()){
    _authSubscription = repository.authStateChanges.listen((user){
      add(AuthStateChangeDetected(user: user));
    });
    @override
    Future<void> close() async{
      _authSubscription.cancel();
      super.close();
    }
    on<AuthStateChangeDetected>((event, emit) {
      final user = event.user;
      if (user == null) {
        emit(const Unauthenticated());
      } else {
        emit(Authenticated(user: user));
      }
    });
    on<SignInRequested>((event,emit)async{
      try {
        emit(AuthLoading());
        await repository.signInWithEmailAndPassword(email: event.email, password: event.password);
      }  catch (e){
        emit(AuthError(errorMsg: unableToConnect));
      }
    });
    on<RegisterRequested>((event, emit) async{
      try {
        emit(AuthLoading());
        await repository.registerWithEmailAndPassword(email: event.email, password: event.password);
      }  catch (e){
        emit(AuthError(errorMsg: unableToConnect));
      }
    });
    on<SignOutRequested>((event,emit)async{

      try {
        emit(AuthLoading());
        await repository.signOut();
      }  catch (e){
        emit(AuthError(errorMsg: unableToConnect));
      }
    });
  }

}