part of 'user_bloc.dart';

enum UserStatus { authenticated, unauthenticated }

class UserState extends Equatable {
  final UserStatus status;
  final User user;

  const UserState({
    required this.status,
    required this.user,
  });

  factory UserState.initial() {
    return UserState(
      status: UserStatus.unauthenticated,
      user: User.empty(),
    );
  }

  @override
  List<Object> get props => [
        user,
        status,
      ];

  UserState copyWith({
    User? user,
    UserStatus? status,
  }) {
    return UserState(
      status: status ?? this.status,
      user: user ?? this.user,
    );
  }
}
