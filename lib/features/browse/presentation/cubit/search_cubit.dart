import 'package:flutter_bloc/flutter_bloc.dart';
import 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(const SearchState());

  void updateSearchQuery(String query) {
    emit(state.copyWith(searchQuery: query));
  }
}
