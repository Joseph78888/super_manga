import 'package:equatable/equatable.dart';
import '../../../home/domain/manga.dart';
import '../../../home/domain/chapter.dart';

/// State for the manga detail screen.
class DetailState extends Equatable {
  final bool isSynopsisExpanded;
  final bool isLoading;
  final Manga? manga;
  final List<Chapter> chapters;
  final String? error;

  const DetailState({
    this.isSynopsisExpanded = false,
    this.isLoading = false,
    this.manga,
    this.chapters = const [],
    this.error,
  });

  DetailState copyWith({
    bool? isSynopsisExpanded,
    bool? isLoading,
    Manga? manga,
    List<Chapter>? chapters,
    String? error,
  }) {
    return DetailState(
      isSynopsisExpanded: isSynopsisExpanded ?? this.isSynopsisExpanded,
      isLoading: isLoading ?? this.isLoading,
      manga: manga ?? this.manga,
      chapters: chapters ?? this.chapters,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
        isSynopsisExpanded,
        isLoading,
        manga,
        chapters,
        error,
      ];
}
