import 'dart:developer' as developer;
import '../../domain/manga_page.dart';
import '../datasources/page_remote_data_source.dart';

/// Repository for manga page data.
class PageRepository {
  final PageRemoteDataSource _dataSource;

  PageRepository({required PageRemoteDataSource dataSource})
      : _dataSource = dataSource;

  /// Fetches pages for a given [chapterId].
  Future<List<MangaPage>> getPagesByChapterId(String chapterId) async {
    try {
      return await _dataSource.fetchPagesByChapterId(chapterId);
    } catch (e, s) {
      developer.log(
        'Failed to fetch pages for chapter $chapterId',
        name: 'PageRepository',
        level: 1000,
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }
}
