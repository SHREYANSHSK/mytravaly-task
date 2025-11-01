import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/services/google_auth_service.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final GoogleAuthService _authService;

  AuthBloc(this._authService) : super(AuthInitial()) {
    on<GoogleSignInRequested>(_onGoogleSignInRequested);
    on<SignOutRequested>(_onSignOutRequested);
  }

  Future<void> _onGoogleSignInRequested(
      GoogleSignInRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());
    try {
      final userData = await _authService.signInWithGoogle();
      if (userData != null) {
        emit(AuthSuccess(
          displayName: userData['displayName'] ?? '',
          email: userData['email'] ?? '',
          photoUrl: userData['photoUrl'] ?? '',
        ));
      } else {
        emit(const AuthFailure('Sign in cancelled'));
      }
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onSignOutRequested(
      SignOutRequested event,
      Emitter<AuthState> emit,
      ) async {
    try {
      await _authService.signOut();
      emit(AuthInitial());
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }
}