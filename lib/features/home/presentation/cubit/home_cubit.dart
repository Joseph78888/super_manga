import 'package:flutter_bloc/flutter_bloc.dart';
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
      final mangas = await _mangaRepository.getMangaList();
      emit(HomeLoaded(mangas));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }
}
