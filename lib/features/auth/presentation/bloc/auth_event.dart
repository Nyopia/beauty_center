part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

// Kullanıcı giriş yap butonu

class SignInButtonPressed extends AuthEvent {
  final String email;
  final String password;

  const SignInButtonPressed({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class SignOutButtonPressed extends AuthEvent {}
