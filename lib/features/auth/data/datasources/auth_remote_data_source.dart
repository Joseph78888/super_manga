import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthRemoteDataSource {
  Future<User> signUp({required String email, required String password, required String username});
  Future<User> signIn({required String email, required String password});
  Future<void> signInWithGoogle();
  Future<void> signOut();
  User? getCurrentUser();
}

class SupabaseAuthRemoteDataSource implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;

  SupabaseAuthRemoteDataSource({required this.supabaseClient});

  @override
  Future<User> signUp({required String email, required String password, required String username}) async {
    final response = await supabaseClient.auth.signUp(
      email: email,
      password: password,
      data: {'username': username},
    );
    if (response.user == null) {
      throw const AuthException('Failed to create user');
    }
    return response.user!;
  }

  @override
  Future<User> signIn({required String email, required String password}) async {
    final response = await supabaseClient.auth.signInWithPassword(
      email: email,
      password: password,
    );
    if (response.user == null) {
      throw const AuthException('Invalid credentials');
    }
    return response.user!;
  }

  @override
  Future<void> signInWithGoogle() async {
    await supabaseClient.auth.signInWithOAuth(OAuthProvider.google);
  }

  @override
  Future<void> signOut() async {
    await supabaseClient.auth.signOut();
  }

  @override
  User? getCurrentUser() {
    return supabaseClient.auth.currentUser;
  }
}
