import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/chapter.dart';

/// Abstract contract for fetching chapter records from remote.
abstract class ChapterRemoteDataSource {
  /// Returns all chapters for a given [mangaId], ordered descending.
  Future<List<Chapter>> fetchChaptersByMangaId(String mangaId);
}

/// Supabase implementation of [ChapterRemoteDataSource].
class SupabaseChapterRemoteDataSource implements ChapterRemoteDataSource {
  final SupabaseClient supabaseClient;

  SupabaseChapterRemoteDataSource({required this.supabaseClient});

  @override
  Future<List<Chapter>> fetchChaptersByMangaId(String mangaId) async {
    final response = await supabaseClient
        .from('chapters')
        .select()
        .eq('manga_id', mangaId)
        .order('chapter_number', ascending: false);
    return (response as List<dynamic>)
        .map((json) => Chapter.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
