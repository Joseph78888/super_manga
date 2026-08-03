import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthRemoteDataSource {
  Future<User> signUp({
    required String email,
    required String password,
    required String username,
  });
  Future<User> signIn({required String email, required String password});
  Future<void> signInWithGoogle();
  Future<void> signInAnonymously();
  Future<void> signOut();
  User? getCurrentUser();
}

class SupabaseAuthRemoteDataSource implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;

  SupabaseAuthRemoteDataSource({required this.supabaseClient});

  @override
  Future<User> signUp({
    required String email,
    required String password,
    required String username,
  }) async {
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
    // Note: For Android, you MUST provide the webClientId (from Google Cloud Console)
    // for Supabase to be able to verify the idToken.
    // For iOS, it's usually handled by the GoogleService-Info.plist.

    final webClientId = dotenv.env['GOOGLE_WEB_CLIENT_ID'];
    // Usually it looks like: [PROJECT_ID].apps.googleusercontent.com
    // Since I don't have it, I'm using a placeholder logic or assuming it's configured in the dashboard.

    await GoogleSignIn.instance.initialize(serverClientId: webClientId);

    try {
      final googleUser = await GoogleSignIn.instance.authenticate();

      final googleAuth = googleUser.authentication;
      final idToken = googleAuth.idToken;

      if (idToken == null) {
        throw const AuthException('No ID Token found from Google sign-in.');
      }

      await supabaseClient.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
      );
    } catch (e) {
      // If native fails or we want to fallback to browser
      rethrow;
    }
  }

  @override
  Future<void> signInAnonymously() async {
    await supabaseClient.auth.signInAnonymously();
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
