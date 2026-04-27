import 'package:equatable/equatable.dart';

class ProfileState extends Equatable {
  final bool isLoading;
  final String username;
  final String email;
  final bool isAnonymous;
  final bool isPremium;
  final int mangaRead;
  final int chaptersRead;
  final int streakDays;

  const ProfileState({
    this.isLoading = true,
    this.username = '',
    this.email = '',
    this.isAnonymous = false,
    this.isPremium = false,
    this.mangaRead = 0,
    this.chaptersRead = 0,
    this.streakDays = 0,
  });

  ProfileState copyWith({
    bool? isLoading,
    String? username,
    String? email,
    bool? isAnonymous,
    bool? isPremium,
    int? mangaRead,
    int? chaptersRead,
    int? streakDays,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      username: username ?? this.username,
      email: email ?? this.email,
      isAnonymous: isAnonymous ?? this.isAnonymous,
      isPremium: isPremium ?? this.isPremium,
      mangaRead: mangaRead ?? this.mangaRead,
      chaptersRead: chaptersRead ?? this.chaptersRead,
      streakDays: streakDays ?? this.streakDays,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        username,
        email,
        isAnonymous,
        isPremium,
        mangaRead,
        chaptersRead,
        streakDays,
      ];
}
