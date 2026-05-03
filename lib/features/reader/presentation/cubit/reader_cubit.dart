import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/page_repository.dart';
import 'reader_state.dart';

/// Drives the reader screen. Loads pages from [PageRepository].
class ReaderCubit extends Cubit<ReaderState> {
  final PageRepository _pageRepository;

  ReaderCubit({required PageRepository pageRepository})
    : _pageRepository = pageRepository,
      super(const ReaderState());

  /// Loads all pages for the given [chapterId].
  Future<void> loadPages(String chapterId, {String? chapterNumber}) async {
    emit(
      state.copyWith(
        isLoading: true,
        error: null,
        chapterNumber: chapterNumber,
      ),
    );
    try {
      final pages = await _pageRepository.getPagesByChapterId(chapterId);
      emit(state.copyWith(isLoading: false, pages: pages, currentPage: 1));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  void toggleMenu() {
    emit(state.copyWith(isMenuVisible: !state.isMenuVisible));
  }

  void updatePage(int page) {
    if (page >= 1 && page <= state.totalPages) {
      emit(state.copyWith(currentPage: page));
    }
  }
}
