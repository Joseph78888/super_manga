import 'dart:developer' as developer;
import '../../domain/entities/profile_entity.dart';
import '../datasources/profile_remote_data_source.dart';

class ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;

  ProfileRepository({required ProfileRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  Future<ProfileEntity?> getProfile(String userId) async {
    try {
      return await _remoteDataSource.getProfile(userId);
    } catch (e, s) {
      developer.log(
        'Failed to fetch profile',
        name: 'ProfileRepository',
        error: e,
        stackTrace: s,
      );
      return null;
    }
  }
}
