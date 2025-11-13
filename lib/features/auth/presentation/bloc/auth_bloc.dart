import 'package:beauty_center/core/usecases/usecase.dart';
import 'package:beauty_center/features/auth/domain/usecases/signout_user.dart';

import '../../../../package_export.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInUser signInUser; // Domain katmanından usecase'imizi istiyoruz.
  final SignOutUser signOutUser;

  AuthBloc({required this.signInUser, required this.signOutUser})
    : super(AuthInitial()) {
    on<SignInButtonPressed>(_onSignInButtonPressed);
    on<SignOutButtonPressed>(_onSignOutButtonPressed);
  }

  Future<void> _onSignInButtonPressed(
    SignInButtonPressed event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    // usecase'i çağır
    final result = await signInUser(
      SignInParams(email: event.email, password: event.password),
    );

    // Usecase'den gelen sonuca göre yeni state yayınla
    result.fold(
      // başarısız olursa (LEFT)
      (failure) {
        emit(
          AuthFailure(
            message: 'Giriş başarısız! Lütfen bilgileri kontrol ediniz.',
          ),
        );
      },
      // başarılı olursa (RIGHT)
      (user) {
        emit(AuthSuccess(user));
      },
    );
  }

  Future<void> _onSignOutButtonPressed(
    SignOutButtonPressed event,
    Emitter<AuthState> emit,
  ) async {
    await signOutUser(NoParams());
    emit(AuthInitial());
  }
}
