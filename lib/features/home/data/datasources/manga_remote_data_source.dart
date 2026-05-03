import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/manga.dart';

/// Abstract contract for fetching manga records from remote.
abstract class MangaRemoteDataSource {
  /// Returns all manga records ordered by creation date.
  Future<List<Manga>> fetchMangaList();

  /// Returns a single manga record by [id].
  Future<Manga> fetchMangaById(String id);

  /// Returns the highest rated manga to be featured.
  Future<Manga> fetchFeaturedManga();

  /// Returns top 10 mangas ordered by rating.
  Future<List<Manga>> fetchTrendingMangas();

  /// Returns 10 most recently created mangas.
  Future<List<Manga>> fetchRecentlyUpdatedMangas();
}

/// Supabase implementation of [MangaRemoteDataSource].
class SupabaseMangaRemoteDataSource implements MangaRemoteDataSource {
  final SupabaseClient supabaseClient;

  SupabaseMangaRemoteDataSource({required this.supabaseClient});

  @override
  Future<List<Manga>> fetchMangaList() async {
    final response = await supabaseClient
        .from('manga')
        .select('*, manga_genres(genres(*))')
        .order('created_at', ascending: false);
    return (response as List<dynamic>)
        .map((json) => Manga.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<Manga> fetchMangaById(String id) async {
    final response =
        await supabaseClient.from('manga').select('*, manga_genres(genres(*))').eq('id', id).single();
    return Manga.fromJson(response);
  }

  @override
  Future<Manga> fetchFeaturedManga() async {
    // Pick the single highest rated manga
    final response = await supabaseClient
        .from('manga')
        .select('*, manga_genres(genres(*))')
        .order('rating', ascending: false)
        .limit(1)
        .single();
    return Manga.fromJson(response);
  }

  @override
  Future<List<Manga>> fetchTrendingMangas() async {
    // Top 10 by rating
    final response = await supabaseClient
        .from('manga')
        .select('*, manga_genres(genres(*))')
        .order('rating', ascending: false)
        .limit(10);
    return (response as List<dynamic>)
        .map((json) => Manga.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<Manga>> fetchRecentlyUpdatedMangas() async {
    // Top 10 by creation date
    final response = await supabaseClient
        .from('manga')
        .select('*, manga_genres(genres(*))')
        .order('created_at', ascending: false)
        .limit(10);
    return (response as List<dynamic>)
        .map((json) => Manga.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
