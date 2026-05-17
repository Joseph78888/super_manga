import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/error/supabase_error_handler.dart';
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
        _mangaRepository.getFeaturedMangas(),
        _mangaRepository.getTrendingMangas(),
        _mangaRepository.getRecentlyUpdatedMangas(),
      ]);

      emit(
        HomeLoaded(
          featuredMangas: results[0] as List<Manga>,
          trendingMangas: results[1] as List<Manga>,
          recentMangas: results[2] as List<Manga>,
        ),
      );
    } catch (e) {
      final message = SupabaseErrorHandler.handle(e);
      emit(HomeError(message));
    }
  }
}
