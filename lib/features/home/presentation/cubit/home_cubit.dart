import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/error/supabase_error_handler.dart';
import '../../data/repositories/manga_repository.dart';
import 'home_state.dart';

/// Drives the home screen. Loads the manga list from [MangaRepository].
class HomeCubit extends Cubit<HomeState> {
  final MangaRepository _mangaRepository;

  HomeCubit({required MangaRepository mangaRepository})
    : _mangaRepository = mangaRepository,
      super(const HomeInitial());

  /// Triggers the initial data load.
  Future<void> loadMangas({String? type}) async {
    final currentType = type ?? state.selectedType;
    emit(HomeLoading(selectedType: currentType));
    try {
      final results = await Future.wait([
        _mangaRepository.getFeaturedMangas(type: currentType),
        _mangaRepository.getTrendingMangas(type: currentType),
        _mangaRepository.getRecentlyUpdatedMangas(type: currentType),
      ]);

      emit(
        HomeLoaded(
          featuredMangas: results[0],
          trendingMangas: results[1],
          recentMangas: results[2],
          selectedType: currentType,
        ),
      );
    } catch (e) {
      final message = SupabaseErrorHandler.handle(e);
      emit(HomeError(message, selectedType: currentType));
    }
  }

  /// Changes the active content filter.
  void changeType(String type) {
    if (state.selectedType == type) return;
    loadMangas(type: type);
  }
}
