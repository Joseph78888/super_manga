import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/manga.dart';

/// Abstract contract for fetching manga records from remote.
abstract class MangaRemoteDataSource {
  /// Returns all manga records ordered by creation date.
  Future<List<Manga>> fetchMangaList();

  /// Returns a single manga record by [id].
  Future<Manga> fetchMangaById(String id);

  /// Returns top 5 highest rated mangas to be featured.
  Future<List<Manga>> fetchFeaturedMangas({String? type});

  /// Returns top 10 mangas ordered by rating.
  Future<List<Manga>> fetchTrendingMangas({String? type});

  /// Returns 10 most recently created mangas.
  Future<List<Manga>> fetchRecentlyUpdatedMangas({String? type});
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
    final response = await supabaseClient
        .from('manga')
        .select('*, manga_genres(genres(*))')
        .eq('id', id)
        .single();
    return Manga.fromJson(response);
  }

  @override
  Future<List<Manga>> fetchFeaturedMangas({String? type}) async {
    // Top 5 highest rated mangas
    var query = supabaseClient
        .from('manga')
        .select('*, manga_genres(genres(*))');

    if (type != null && type != 'All') {
      query = query.eq('type', type);
    }

    final response = await query.order('rating', ascending: false).limit(5);

    return (response as List<dynamic>)
        .map((json) => Manga.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<Manga>> fetchTrendingMangas({String? type}) async {
    // Top 10 by rating
    var query = supabaseClient
        .from('manga')
        .select('*, manga_genres(genres(*))');

    if (type != null && type != 'All') {
      query = query.eq('type', type);
    }

    final response = await query.order('rating', ascending: false).limit(10);

    return (response as List<dynamic>)
        .map((json) => Manga.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<Manga>> fetchRecentlyUpdatedMangas({String? type}) async {
    // Top 10 by creation date
    var query = supabaseClient
        .from('manga')
        .select('*, manga_genres(genres(*))');

    if (type != null && type != 'All') {
      query = query.eq('type', type);
    }

    final response = await query
        .order('created_at', ascending: false)
        .limit(10);

    return (response as List<dynamic>)
        .map((json) => Manga.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
