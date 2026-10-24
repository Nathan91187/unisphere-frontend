import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uni_sphere/features/auth/domain/repositories/auth_repository.dart';
import 'package:uni_sphere/features/auth/presentation/bloc/auth_event.dart';
import 'package:uni_sphere/features/auth/presentation/bloc/auth_state.dart';

import '../../domain/entities/auth_failure.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState>{
  final AuthRepository repository;
  late final StreamSubscription _authSubscription;
  final unexpectedError = 'Something went wrong. Please try again.';
  static const Map<AuthFailureType, String> _errorMessages = {
    AuthFailureType.invalidCredentials: 'Incorrect email or password.',
    AuthFailureType.emailAlreadyInUse:
    'An account with this email already exists.',
    AuthFailureType.weakPassword: 'Please choose a stronger password.',
    AuthFailureType.network:
    'Check your internet connection and try again.',
    AuthFailureType.unknown: 'Something went wrong. Please try again.',
  };
  @override
  Future<void> close() async{
    _authSubscription.cancel();
    super.close();
  }
  String _getAuthErrorMessage(AuthFailureType type) {
    return _errorMessages[type]!;
  }
  AuthBloc({required this.repository}):super(AuthInitial()){
    _authSubscription = repository.authStateChanges.listen((user){
      add(AuthStateChangeDetected(user: user));
    });
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
      } on AuthFailure catch (e){
        emit(AuthError(errorMsg: _getAuthErrorMessage(e.type)));
      }
      catch (e){
        emit( AuthError(errorMsg: unexpectedError));
      }
    });
    on<RegisterRequested>((event, emit) async{
      try {
        emit(AuthLoading());
        await repository.registerWithEmailAndPassword(email: event.email, password: event.password, displayName: event.displayName);
      }
      on AuthFailure catch (e){
        emit(AuthError(errorMsg: _getAuthErrorMessage(e.type)));
      }
      catch (e){
        emit(AuthError(errorMsg: unexpectedError));
      }
    });
    on<SignOutRequested>((event,emit)async{

      try {
        emit(AuthLoading());
        await repository.signOut();
      }
      on AuthFailure catch (e){
        emit(AuthError(errorMsg: _getAuthErrorMessage(e.type)));
      }
      catch (e){
        emit(AuthError(errorMsg: unexpectedError));
      }
    });
  }

}