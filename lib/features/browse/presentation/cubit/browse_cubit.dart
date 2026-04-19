import 'package:flutter_bloc/flutter_bloc.dart';
import 'browse_state.dart';

class BrowseCubit extends Cubit<BrowseState> {
  BrowseCubit() : super(const BrowseState());

  void changeGenre(String genre) {
    emit(state.copyWith(selectedGenre: genre));
  }

  void changeSortOption(String sortOption) {
    emit(state.copyWith(selectedSort: sortOption));
  }
}
