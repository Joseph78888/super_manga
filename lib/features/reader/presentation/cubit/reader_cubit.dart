import 'package:flutter_bloc/flutter_bloc.dart';
import 'reader_state.dart';

class ReaderCubit extends Cubit<ReaderState> {
  ReaderCubit() : super(const ReaderState());

  void toggleMenu() {
    emit(state.copyWith(isMenuVisible: !state.isMenuVisible));
  }

  void updatePage(int page) {
    if (page >= 1 && page <= state.totalPages) {
      emit(state.copyWith(currentPage: page));
    }
  }
}
