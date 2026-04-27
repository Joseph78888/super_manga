import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/manga.dart';

/// Abstract contract for fetching manga records from remote.
abstract class MangaRemoteDataSource {
  /// Returns all manga records ordered by creation date.
  Future<List<Manga>> fetchMangaList();

  /// Returns a single manga record by [id].
  Future<Manga> fetchMangaById(String id);
}

/// Supabase implementation of [MangaRemoteDataSource].
class SupabaseMangaRemoteDataSource implements MangaRemoteDataSource {
  final SupabaseClient supabaseClient;

  SupabaseMangaRemoteDataSource({required this.supabaseClient});

  @override
  Future<List<Manga>> fetchMangaList() async {
    final response = await supabaseClient
        .from('manga')
        .select()
        .order('created_at', ascending: false);
    return (response as List<dynamic>)
        .map((json) => Manga.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<Manga> fetchMangaById(String id) async {
    final response =
        await supabaseClient.from('manga').select().eq('id', id).single();
    return Manga.fromJson(response);
  }
}
