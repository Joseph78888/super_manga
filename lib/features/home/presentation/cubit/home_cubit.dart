import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/manga.dart';
import '../../data/repositories/manga_repository.dart';
import 'home_state.dart';

/// Drives the home screen. Loads the manga list from [MangaRepository].
class HomeCubit extends Cubit<HomeState> {
  final MangaRepository _mangaRepository;

  HomeCubit({required MangaRepository mangaRepository})
      : _mangaRepository = mangaRepository,
        super(const HomeInitial());

  /// Triggers the initial data load.
  Future<void> loadMangas() async {
    emit(const HomeLoading());
    try {
      final results = await Future.wait([
        _mangaRepository.getFeaturedManga(),
        _mangaRepository.getTrendingMangas(),
        _mangaRepository.getRecentlyUpdatedMangas(),
      ]);

      emit(HomeLoaded(
        featuredManga: results[0] as Manga,
        trendingMangas: results[1] as List<Manga>,
        recentMangas: results[2] as List<Manga>,
      ));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }
}
