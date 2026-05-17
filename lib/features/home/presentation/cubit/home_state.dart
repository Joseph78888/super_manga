import 'package:equatable/equatable.dart';
import '../../domain/manga.dart';

/// Sealed state for the home screen.
sealed class HomeState extends Equatable {
  final String selectedType;
  const HomeState({this.selectedType = 'All'});

  @override
  List<Object?> get props => [selectedType];
}

/// Initial state before any load is triggered.
class HomeInitial extends HomeState {
  const HomeInitial({super.selectedType});
}

/// While the manga list is being fetched.
class HomeLoading extends HomeState {
  const HomeLoading({super.selectedType});
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
    super.selectedType,
  });

  @override
  List<Object?> get props => [
    featuredMangas,
    trendingMangas,
    recentMangas,
    selectedType,
  ];
}

/// A fetch error occurred.
class HomeError extends HomeState {
  final String message;

  const HomeError(this.message, {super.selectedType});

  @override
  List<Object?> get props => [message, selectedType];
}
