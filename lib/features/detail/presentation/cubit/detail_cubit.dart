import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../home/data/repositories/manga_repository.dart';
import '../../../home/data/repositories/chapter_repository.dart';
import 'detail_state.dart';

/// Drives the manga detail screen. Loads manga metadata and chapter list.
class DetailCubit extends Cubit<DetailState> {
  final MangaRepository _mangaRepository;
  final ChapterRepository _chapterRepository;

  DetailCubit({
    required MangaRepository mangaRepository,
    required ChapterRepository chapterRepository,
  }) : _mangaRepository = mangaRepository,
       _chapterRepository = chapterRepository,
       super(const DetailState());

  /// Loads the manga details and its chapters concurrently.
  Future<void> loadDetail(String mangaId) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final results = await Future.wait([
        _mangaRepository.getMangaById(mangaId),
        _chapterRepository.getChaptersByMangaId(mangaId),
      ]);
      emit(
        state.copyWith(
          isLoading: false,
          manga: results[0] as dynamic,
          chapters: results[1] as dynamic,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  void toggleSynopsis() {
    emit(state.copyWith(isSynopsisExpanded: !state.isSynopsisExpanded));
  }
}
