import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/profile_entity.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileEntity?> getProfile(String userId);
}

class SupabaseProfileRemoteDataSource implements ProfileRemoteDataSource {
  final SupabaseClient supabaseClient;

  SupabaseProfileRemoteDataSource({required this.supabaseClient});

  @override
  Future<ProfileEntity?> getProfile(String userId) async {
    try {
      final response = await supabaseClient
          .from('profiles')
          .select()
          .eq('id', userId)
          .maybeSingle();
      
      if (response == null) {
        return null;
      }
      
      return ProfileEntity.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }
}
