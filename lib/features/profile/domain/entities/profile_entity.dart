import 'package:equatable/equatable.dart';

class ProfileEntity extends Equatable {
  final String id;
  final String? username;
  final String? avatarUrl;
  final bool isPremium;
  final int mangaRead;
  final int chaptersRead;
  final int streakDays;

  const ProfileEntity({
    required this.id,
    this.username,
    this.avatarUrl,
    this.isPremium = false,
    this.mangaRead = 0,
    this.chaptersRead = 0,
    this.streakDays = 0,
  });

  factory ProfileEntity.fromJson(Map<String, dynamic> json) {
    return ProfileEntity(
      id: json['id'] as String,
      username: json['username'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      isPremium: json['is_premium'] as bool? ?? false,
      mangaRead: json['manga_read'] as int? ?? 0,
      chaptersRead: json['chapters_read'] as int? ?? 0,
      streakDays: json['streak_days'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'avatar_url': avatarUrl,
      'is_premium': isPremium,
      'manga_read': mangaRead,
      'chapters_read': chaptersRead,
      'streak_days': streakDays,
    };
  }

  @override
  List<Object?> get props => [
    id,
    username,
    avatarUrl,
    isPremium,
    mangaRead,
    chaptersRead,
    streakDays,
  ];
}
