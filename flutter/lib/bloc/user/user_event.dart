part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class UserRegister extends UserEvent {
  final String email;
  final String password;

  const UserRegister({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [
        email,
        password,
      ];
}

class UserLogout extends UserEvent {
  const UserLogout();

  @override
  List<Object> get props => [];
}

class UserLogin extends UserEvent {
  final String email;
  final String password;

  const UserLogin({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [
        email,
        password,
      ];
}
