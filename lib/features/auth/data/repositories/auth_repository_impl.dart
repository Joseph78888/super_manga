import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<UserEntity> signUp({required String email, required String password, required String username}) async {
    final user = await remoteDataSource.signUp(email: email, password: password, username: username);
    return _mapUserToEntity(user);
  }

  @override
  Future<UserEntity> signIn({required String email, required String password}) async {
    final user = await remoteDataSource.signIn(email: email, password: password);
    return _mapUserToEntity(user);
  }

  @override
  Future<void> signInWithGoogle() async {
    await remoteDataSource.signInWithGoogle();
  }

  @override
  Future<void> signInAnonymously() async {
    await remoteDataSource.signInAnonymously();
  }

  @override
  Future<void> signOut() async {
    await remoteDataSource.signOut();
  }

  @override
  UserEntity? getCurrentUser() {
    final user = remoteDataSource.getCurrentUser();
    if (user != null) {
      return _mapUserToEntity(user);
    }
    return null;
  }

  UserEntity _mapUserToEntity(User supabaseUser) {
    return UserEntity(
      id: supabaseUser.id,
      email: supabaseUser.email ?? '',
      username: supabaseUser.userMetadata?['username'] as String?,
      isAnonymous: supabaseUser.isAnonymous,
    );
  }
}
