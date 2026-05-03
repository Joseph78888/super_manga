import 'package:equatable/equatable.dart';

class BrowseState extends Equatable {
  final String selectedGenre;
  final String selectedSort;

  const BrowseState({this.selectedGenre = 'All', this.selectedSort = 'New'});

  BrowseState copyWith({String? selectedGenre, String? selectedSort}) {
    return BrowseState(
      selectedGenre: selectedGenre ?? this.selectedGenre,
      selectedSort: selectedSort ?? this.selectedSort,
    );
  }

  @override
  List<Object?> get props => [selectedGenre, selectedSort];
}
