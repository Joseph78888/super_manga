import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/manga_page.dart';

/// Abstract contract for fetching page records from remote.
abstract class PageRemoteDataSource {
  /// Returns all pages for a given [chapterId], ordered by page number.
  Future<List<MangaPage>> fetchPagesByChapterId(String chapterId);
}

/// Supabase implementation of [PageRemoteDataSource].
class SupabasePageRemoteDataSource implements PageRemoteDataSource {
  final SupabaseClient supabaseClient;

  SupabasePageRemoteDataSource({required this.supabaseClient});

  @override
  Future<List<MangaPage>> fetchPagesByChapterId(String chapterId) async {
    final response = await supabaseClient
        .from('pages')
        .select()
        .eq('chapter_id', chapterId)
        .order('page_number', ascending: true);
    return (response as List<dynamic>)
        .map((json) => MangaPage.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
