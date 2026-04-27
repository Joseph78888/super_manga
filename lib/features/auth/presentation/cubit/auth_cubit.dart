import 'dart:developer' as developer;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;
import '../../domain/repositories/auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;

  AuthCubit({required this.authRepository}) : super(const AuthState());

  void toggleMode() {
    emit(state.copyWith(
      mode: state.isLoginMode ? AuthMode.signup : AuthMode.login,
      errorMessage: null, // Clear errors when switching modes
    ));
  }

  void togglePasswordVisibility() {
    emit(state.copyWith(isPasswordObscured: !state.isPasswordObscured));
  }

  void toggleConfirmPasswordVisibility() {
    emit(state.copyWith(isConfirmPasswordObscured: !state.isConfirmPasswordObscured));
  }

  Future<bool> authenticate({
    required String email, 
    required String password, 
    String? username,
    String? confirmPassword,
  }) async {
    developer.log('Starting authentication process. Mode: ${state.mode.name}', name: 'auth_cubit');
    emit(state.copyWith(isLoading: true, errorMessage: null));
    
    try {
      if (email.isEmpty || password.isEmpty) {
        developer.log('Validation failed: Empty fields', name: 'auth_cubit', level: 800);
        emit(state.copyWith(isLoading: false, errorMessage: 'Fields cannot be empty'));
        return false;
      }
      
      if (state.isLoginMode) {
        // Sign In
        developer.log('Attempting sign in for user: $email', name: 'auth_cubit');
        final user = await authRepository.signIn(
          email: email,
          password: password,
        );
        developer.log('Sign in successful. User ID: ${user.id}', name: 'auth_cubit');
      } else {
        // Sign Up
        developer.log('Attempting sign up for user: $email', name: 'auth_cubit');
        if (username == null || username.isEmpty) {
          developer.log('Validation failed: Username required for signup', name: 'auth_cubit', level: 800);
          emit(state.copyWith(isLoading: false, errorMessage: 'Username is required'));
          return false;
        }
        if (password != confirmPassword) {
          developer.log('Validation failed: Passwords do not match', name: 'auth_cubit', level: 800);
          emit(state.copyWith(isLoading: false, errorMessage: 'Passwords do not match'));
          return false;
        }
        
        final user = await authRepository.signUp(
          email: email,
          password: password,
          username: username,
        );
        developer.log('Sign up successful. User ID: ${user.id}', name: 'auth_cubit');
      }

      emit(state.copyWith(isLoading: false));
      return true; // Success
    } on AuthException catch (e, s) {
      developer.log('Supabase Auth Exception', name: 'auth_cubit', level: 1000, error: e, stackTrace: s);
      
      String message = e.message;
      
      // Map specific error codes to user-friendly messages
      switch (e.code) {
        case 'user_already_exists':
          message = 'This email is already registered. Try signing in instead.';
          break;
        case 'invalid_credentials':
          message = 'Invalid email or password.';
          break;
        case 'over_email_send_rate_limit':
          message = 'Too many requests. Please wait a bit before trying again.';
          break;
        case 'email_not_confirmed':
          message = 'Please confirm your email address before signing in.';
          break;
        case 'network_error':
          message = 'Network error. Please check your internet connection.';
          break;
      }
      
      emit(state.copyWith(isLoading: false, errorMessage: message));
      return false;
    } catch (e, s) {
      developer.log('Unexpected error during auth', name: 'auth_cubit', level: 1000, error: e, stackTrace: s);
      emit(state.copyWith(isLoading: false, errorMessage: 'An unexpected error occurred. Please try again.'));
      return false;
    }
  }

  Future<void> signInWithGoogle() async {
    developer.log('Attempting Google OAuth sign in', name: 'auth_cubit');
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      await authRepository.signInWithGoogle();
      developer.log('Google OAuth flow started successfully', name: 'auth_cubit');
      emit(state.copyWith(isLoading: false));
    } on AuthException catch (e, s) {
      developer.log('Google Auth Exception', name: 'auth_cubit', level: 1000, error: e, stackTrace: s);
      emit(state.copyWith(isLoading: false, errorMessage: e.message));
    } catch (e, s) {
      developer.log('Error during Google OAuth', name: 'auth_cubit', level: 1000, error: e, stackTrace: s);
      emit(state.copyWith(isLoading: false, errorMessage: 'Google sign-in failed.'));
    }
  }

  Future<bool> signInAsGuest() async {
    developer.log('Attempting Guest sign in', name: 'auth_cubit');
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      await authRepository.signInAnonymously();
      developer.log('Guest sign in successful', name: 'auth_cubit');
      emit(state.copyWith(isLoading: false));
      return true;
    } catch (e, s) {
      developer.log('Error during Guest sign in', name: 'auth_cubit', level: 1000, error: e, stackTrace: s);
      emit(state.copyWith(isLoading: false, errorMessage: 'Failed to sign in as guest. Ensure anonymous sign-ins are enabled.'));
      return false;
    }
  }
}
