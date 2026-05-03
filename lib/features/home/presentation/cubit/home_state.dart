import 'package:equatable/equatable.dart';
import '../../domain/manga.dart';

/// Sealed state for the home screen.
sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

/// Initial state before any load is triggered.
class HomeInitial extends HomeState {
  const HomeInitial();
}

/// While the manga list is being fetched.
class HomeLoading extends HomeState {
  const HomeLoading();
}

/// Manga list fetched successfully.
class HomeLoaded extends HomeState {
  final Manga featuredManga;
  final List<Manga> trendingMangas;
  final List<Manga> recentMangas;

  const HomeLoaded({
    required this.featuredManga,
    required this.trendingMangas,
    required this.recentMangas,
  });

  @override
  List<Object?> get props => [featuredManga, trendingMangas, recentMangas];
}

/// A fetch error occurred.
class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object?> get props => [message];
}
