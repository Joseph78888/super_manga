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
  final List<Manga> featuredMangas;
  final List<Manga> trendingMangas;
  final List<Manga> recentMangas;

  const HomeLoaded({
    required this.featuredMangas,
    required this.trendingMangas,
    required this.recentMangas,
  });

  @override
  List<Object?> get props => [featuredMangas, trendingMangas, recentMangas];
}

/// A fetch error occurred.
class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object?> get props => [message];
}
