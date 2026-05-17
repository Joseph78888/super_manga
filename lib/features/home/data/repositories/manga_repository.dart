import 'dart:developer' as developer;
import '../../domain/manga.dart';
import '../datasources/manga_remote_data_source.dart';

/// Repository for manga data. Wraps [MangaRemoteDataSource] with
/// error handling.
class MangaRepository {
  final MangaRemoteDataSource _dataSource;

  MangaRepository({required MangaRemoteDataSource dataSource})
    : _dataSource = dataSource;

  /// Fetches the full manga list. Returns an empty list on error.
  Future<List<Manga>> getMangaList() async {
    try {
      return await _dataSource.fetchMangaList();
    } catch (e, s) {
      developer.log(
        'Failed to fetch manga list',
        name: 'MangaRepository',
        level: 1000,
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }

  /// Fetches a single manga by [id].
  Future<Manga> getMangaById(String id) async {
    try {
      return await _dataSource.fetchMangaById(id);
    } catch (e, s) {
      developer.log(
        'Failed to fetch manga $id',
        name: 'MangaRepository',
        level: 1000,
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }

  /// Fetches the featured mangas.
  Future<List<Manga>> getFeaturedMangas({String? type}) async {
    try {
      return await _dataSource.fetchFeaturedMangas(type: type);
    } catch (e, s) {
      developer.log(
        'Failed to fetch featured mangas',
        name: 'MangaRepository',
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }

  /// Fetches trending mangas.
  Future<List<Manga>> getTrendingMangas({String? type}) async {
    try {
      return await _dataSource.fetchTrendingMangas(type: type);
    } catch (e, s) {
      developer.log(
        'Failed to fetch trending mangas',
        name: 'MangaRepository',
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }

  /// Fetches recently updated mangas.
  Future<List<Manga>> getRecentlyUpdatedMangas({String? type}) async {
    try {
      return await _dataSource.fetchRecentlyUpdatedMangas(type: type);
    } catch (e, s) {
      developer.log(
        'Failed to fetch recently updated mangas',
        name: 'MangaRepository',
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }
}
