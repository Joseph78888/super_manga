import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final AuthRepository _authRepository;

  ProfileCubit({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(const ProfileState()) {
    loadUserData();
  }

  void loadUserData() {
    emit(state.copyWith(isLoading: true));
    final user = _authRepository.getCurrentUser();

    if (user != null) {
      emit(
        state.copyWith(
          isLoading: false,
          username:
              user.username ?? (user.isAnonymous ? 'Guest User' : 'Reader'),
          email: user.isAnonymous ? 'Hidden for Guest' : user.email,
          isAnonymous: user.isAnonymous,
          // Keep dummy data for the fun stats
          isPremium: !user.isAnonymous,
          mangaRead: user.isAnonymous ? 0 : 145,
          chaptersRead: user.isAnonymous ? 0 : 1240,
          streakDays: user.isAnonymous ? 0 : 89,
        ),
      );
    } else {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> signOut() async {
    await _authRepository.signOut();
  }

  void togglePremium() {
    if (!state.isAnonymous) {
      emit(state.copyWith(isPremium: !state.isPremium));
    }
  }
}
