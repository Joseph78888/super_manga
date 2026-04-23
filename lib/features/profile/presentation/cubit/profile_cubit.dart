import 'package:flutter_bloc/flutter_bloc.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(const ProfileState());

  void togglePremium() {
    emit(state.copyWith(isPremium: !state.isPremium));
  }
}
