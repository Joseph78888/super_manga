import 'package:equatable/equatable.dart';
import '../../domain/manga_page.dart';

/// State for the manga reader screen.
class ReaderState extends Equatable {
  final bool isMenuVisible;
  final int currentPage;
  final List<MangaPage> pages;
  final bool isLoading;
  final String? chapterNumber;
  final String? error;

  const ReaderState({
    this.isMenuVisible = true,
    this.currentPage = 1,
    this.pages = const [],
    this.isLoading = false,
    this.chapterNumber,
    this.error,
  });

  int get totalPages => pages.isEmpty ? 1 : pages.length;

  ReaderState copyWith({
    bool? isMenuVisible,
    int? currentPage,
    List<MangaPage>? pages,
    bool? isLoading,
    String? chapterNumber,
    String? error,
  }) {
    return ReaderState(
      isMenuVisible: isMenuVisible ?? this.isMenuVisible,
      currentPage: currentPage ?? this.currentPage,
      pages: pages ?? this.pages,
      isLoading: isLoading ?? this.isLoading,
      chapterNumber: chapterNumber ?? this.chapterNumber,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
    isMenuVisible,
    currentPage,
    pages,
    isLoading,
    chapterNumber,
    error,
  ];
}
