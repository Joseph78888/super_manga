import 'package:equatable/equatable.dart';

enum AuthMode { login, signup }

class AuthState extends Equatable {
  final AuthMode mode;
  final bool isPasswordObscured;
  final bool isConfirmPasswordObscured;
  final bool isLoading;
  final String? errorMessage;

  const AuthState({
    this.mode = AuthMode.login,
    this.isPasswordObscured = true,
    this.isConfirmPasswordObscured = true,
    this.isLoading = false,
    this.errorMessage,
  });

  bool get isLoginMode => mode == AuthMode.login;

  AuthState copyWith({
    AuthMode? mode,
    bool? isPasswordObscured,
    bool? isConfirmPasswordObscured,
    bool? isLoading,
    String? errorMessage,
  }) {
    return AuthState(
      mode: mode ?? this.mode,
      isPasswordObscured: isPasswordObscured ?? this.isPasswordObscured,
      isConfirmPasswordObscured: isConfirmPasswordObscured ?? this.isConfirmPasswordObscured,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [mode, isPasswordObscured, isConfirmPasswordObscured, isLoading, errorMessage];
}
