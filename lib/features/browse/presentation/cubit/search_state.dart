import 'package:equatable/equatable.dart';

class SearchState extends Equatable {
  final String searchQuery;

  const SearchState({this.searchQuery = ''});

  SearchState copyWith({String? searchQuery}) {
    return SearchState(searchQuery: searchQuery ?? this.searchQuery);
  }

  @override
  List<Object?> get props => [searchQuery];
}
