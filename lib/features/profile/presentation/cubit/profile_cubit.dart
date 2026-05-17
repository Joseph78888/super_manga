import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/error/supabase_error_handler.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import '../../data/repositories/profile_repository.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final AuthRepository _authRepository;
  final ProfileRepository _profileRepository;

  ProfileCubit({
    required AuthRepository authRepository,
    required ProfileRepository profileRepository,
  }) : _authRepository = authRepository,
       _profileRepository = profileRepository,
       super(const ProfileState()) {
    loadUserData();
  }

  Future<void> loadUserData() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final user = _authRepository.getCurrentUser();

      if (user != null) {
        if (user.isAnonymous) {
          emit(
            state.copyWith(
              isLoading: false,
              username: 'Guest User',
              email: 'Hidden for Guest',
              isAnonymous: true,
              isPremium: false,
              mangaRead: 0,
              chaptersRead: 0,
              streakDays: 0,
            ),
          );
        } else {
          final profile = await _profileRepository.getProfile(user.id);

          emit(
            state.copyWith(
              isLoading: false,
              username: profile?.username ?? user.username ?? 'Reader',
              email: user.email,
              isAnonymous: false,
              isPremium: profile?.isPremium ?? false,
              mangaRead: profile?.mangaRead ?? 0,
              chaptersRead: profile?.chaptersRead ?? 0,
              streakDays: profile?.streakDays ?? 0,
            ),
          );
        }
      } else {
        emit(state.copyWith(isLoading: false));
      }
    } catch (e) {
      final message = SupabaseErrorHandler.handle(e);
      emit(state.copyWith(isLoading: false, errorMessage: message));
    }
  }

  Future<void> signOut() async {
    try {
      await _authRepository.signOut();
    } catch (e) {
      final message = SupabaseErrorHandler.handle(e);
      emit(state.copyWith(errorMessage: message));
    }
  }

  void togglePremium() {
    if (!state.isAnonymous) {
      emit(state.copyWith(isPremium: !state.isPremium));
    }
  }
}
