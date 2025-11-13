import "package:equatable/equatable.dart";

class User extends Equatable {
  final String uid;
  final String email;
  final String name;
  final String role; // admin - personel

  const User({
    required this.uid,
    required this.email,
    required this.name,
    required this.role,
  });

  @override
  List<Object?> get props => [uid, email, name, role];
}
