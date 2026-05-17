import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> signUp({
    required String email,
    required String password,
    required String username,
  });

  Future<UserEntity> signIn({required String email, required String password});

  Future<void> signInWithGoogle();
  Future<void> signInAnonymously();
  Future<void> signOut();

  UserEntity? getCurrentUser();
}
