import 'dart:developer' as developer;
import '../../domain/chapter.dart';
import '../datasources/chapter_remote_data_source.dart';

/// Repository for chapter data.
class ChapterRepository {
  final ChapterRemoteDataSource _dataSource;

  ChapterRepository({required ChapterRemoteDataSource dataSource})
      : _dataSource = dataSource;

  /// Fetches chapters for a given [mangaId].
  Future<List<Chapter>> getChaptersByMangaId(String mangaId) async {
    try {
      return await _dataSource.fetchChaptersByMangaId(mangaId);
    } catch (e, s) {
      developer.log(
        'Failed to fetch chapters for manga $mangaId',
        name: 'ChapterRepository',
        level: 1000,
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }
}
