import 'dart:developer' as developer;
import 'package:flutter_bloc/flutter_bloc.dart';
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
    } catch (e, s) {
      // AuthRepositoryImpl could be throwing AuthException or other custom exceptions.
      // We can check e.toString() or rely on the repository to throw specific Exception types if we strictly separated them.
      developer.log('Error during auth', name: 'auth_cubit', level: 1000, error: e, stackTrace: s);
      // Try to parse out the message if it's an AuthException
      String errorMsg = e.toString();
      if (errorMsg.contains('AuthApiException')) {
         // rough parsing to get the message part
         errorMsg = 'Authentication failed. Please check your credentials or rate limits.';
      }
      emit(state.copyWith(isLoading: false, errorMessage: errorMsg));
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
    } catch (e, s) {
      developer.log('Error during Google OAuth', name: 'auth_cubit', level: 1000, error: e, stackTrace: s);
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }
}
