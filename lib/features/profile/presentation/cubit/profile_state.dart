import 'package:equatable/equatable.dart';

class ProfileState extends Equatable {
  final String username;
  final String email;
  final bool isPremium;
  final int mangaRead;
  final int chaptersRead;
  final int streakDays;

  const ProfileState({
    this.username = 'Jin-Woo',
    this.email = 'shadow.monarch@system.com',
    this.isPremium = true,
    this.mangaRead = 145,
    this.chaptersRead = 1240,
    this.streakDays = 89,
  });

  ProfileState copyWith({
    String? username,
    String? email,
    bool? isPremium,
    int? mangaRead,
    int? chaptersRead,
    int? streakDays,
  }) {
    return ProfileState(
      username: username ?? this.username,
      email: email ?? this.email,
      isPremium: isPremium ?? this.isPremium,
      mangaRead: mangaRead ?? this.mangaRead,
      chaptersRead: chaptersRead ?? this.chaptersRead,
      streakDays: streakDays ?? this.streakDays,
    );
  }

  @override
  List<Object?> get props => [
        username,
        email,
        isPremium,
        mangaRead,
        chaptersRead,
        streakDays,
      ];
}
