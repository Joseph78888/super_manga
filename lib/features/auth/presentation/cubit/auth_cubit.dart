import 'dart:developer' as developer;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthState());

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
      
      final supabase = Supabase.instance.client;

      if (state.isLoginMode) {
        // Sign In
        developer.log('Attempting sign in for user: $email', name: 'auth_cubit');
        final response = await supabase.auth.signInWithPassword(
          email: email,
          password: password,
        );
        developer.log('Sign in successful. User ID: ${response.user?.id}', name: 'auth_cubit');
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
        
        final response = await supabase.auth.signUp(
          email: email,
          password: password,
          data: {'username': username},
        );
        developer.log('Sign up successful. User ID: ${response.user?.id}', name: 'auth_cubit');
      }

      emit(state.copyWith(isLoading: false));
      return true; // Success
    } on AuthException catch (e, s) {
      developer.log('Supabase Auth Exception', name: 'auth_cubit', level: 1000, error: e, stackTrace: s);
      emit(state.copyWith(isLoading: false, errorMessage: e.message));
      return false;
    } catch (e, s) {
      developer.log('Unexpected Error during auth', name: 'auth_cubit', level: 1000, error: e, stackTrace: s);
      emit(state.copyWith(isLoading: false, errorMessage: 'An unexpected error occurred.'));
      return false;
    }
  }

  Future<void> signInWithGoogle() async {
    developer.log('Attempting Google OAuth sign in', name: 'auth_cubit');
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      await Supabase.instance.client.auth.signInWithOAuth(OAuthProvider.google);
      developer.log('Google OAuth flow started successfully', name: 'auth_cubit');
      emit(state.copyWith(isLoading: false));
    } on AuthException catch (e, s) {
      developer.log('Google OAuth Supabase Exception', name: 'auth_cubit', level: 1000, error: e, stackTrace: s);
      emit(state.copyWith(isLoading: false, errorMessage: e.message));
    } catch (e, s) {
      developer.log('Unexpected Error during Google OAuth', name: 'auth_cubit', level: 1000, error: e, stackTrace: s);
      emit(state.copyWith(isLoading: false, errorMessage: 'An unexpected error occurred.'));
    }
  }
}
