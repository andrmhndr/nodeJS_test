import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String email;
  final String id;

  const User({
    required this.email,
    required this.id,
  });

  factory User.empty() {
    return const User(
      email: '',
      id: '',
    );
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'],
      id: json['_id'],
    );
  }

  @override
  List<Object?> get props => [
        email,
        id,
      ];

  User copyWith({
    String? email,
    String? id,
  }) {
    return User(email: email ?? this.email, id: id ?? this.id);
  }
}
