import 'package:flutter_bloc/flutter_bloc.dart';
import 'detail_state.dart';

class DetailCubit extends Cubit<DetailState> {
  DetailCubit() : super(const DetailState());

  void toggleSynopsis() {
    emit(state.copyWith(isSynopsisExpanded: !state.isSynopsisExpanded));
  }
}
