import 'package:equatable/equatable.dart';

class LibraryState extends Equatable {
  final String selectedCategory;

  const LibraryState({this.selectedCategory = 'Reading'});

  LibraryState copyWith({String? selectedCategory}) {
    return LibraryState(
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }

  @override
  List<Object?> get props => [selectedCategory];
}
