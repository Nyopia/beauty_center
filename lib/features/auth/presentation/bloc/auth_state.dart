part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

// Başlangıç durumu
final class AuthInitial extends AuthState {}

// Giriş işlemi sırasında gösterilecek yüklenme durumu
final class AuthLoading extends AuthState {}

// Giriş başarılı durumu
final class AuthSuccess extends AuthState {
  final User user;
  const AuthSuccess(this.user);

  @override
  List<Object> get props => [user];
}

// Giriş başarısız durumu
final class AuthFailure extends AuthState {
  final String message;
  const AuthFailure({required this.message});

  @override
  List<Object> get props => [message];
}
