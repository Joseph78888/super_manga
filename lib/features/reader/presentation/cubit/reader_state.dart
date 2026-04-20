import 'package:equatable/equatable.dart';

class ReaderState extends Equatable {
  final bool isMenuVisible;
  final int currentPage;
  final int totalPages;

  const ReaderState({
    this.isMenuVisible = true,
    this.currentPage = 1,
    this.totalPages = 50, // Dummy total pages for endless reading emulation
  });

  ReaderState copyWith({
    bool? isMenuVisible,
    int? currentPage,
    int? totalPages,
  }) {
    return ReaderState(
      isMenuVisible: isMenuVisible ?? this.isMenuVisible,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
    );
  }

  @override
  List<Object?> get props => [isMenuVisible, currentPage, totalPages];
}
