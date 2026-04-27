import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String email;
  final String? username;
  final bool isAnonymous;

  const UserEntity({
    required this.id,
    required this.email,
    this.username,
    this.isAnonymous = false,
  });

  @override
  List<Object?> get props => [id, email, username, isAnonymous];
}
