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
}
