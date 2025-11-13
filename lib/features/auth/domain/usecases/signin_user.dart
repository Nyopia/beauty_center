// --- USECASE DOSYASI ---
// GÖREVİ: Sadece BİR iş mantığını (business logic) yapar.
// Örnek: 'LoginUserUseCase', 'GetArticlesUseCase'.
//
// KURAL 1: İçinde Flutter/UI kodu (Widget, BuildContext) OLMAZ.
// KURAL 2: Saf Dart kodudur.
// KURAL 3: Genellikle bir Repository'ye (arayüzüne) bağımlıdır ve constructor ile alır.
// KURAL 4: BLoC/Cubit/Provider tarafından çağrılır.
// KURAL 5: Genellikle 'call' veya 'execute' adında tek bir public metodu olur.
import 'package:beauty_center/core/error/failures.dart';
import 'package:beauty_center/core/usecases/usecase.dart';
import 'package:beauty_center/features/auth/domain/entities/user.dart';
import 'package:beauty_center/features/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class SignInUser implements UseCase<User, SignInParams> {
  final AuthRepository repository;
  SignInUser(this.repository);

  @override
  Future<Either<Failure, User>> call(SignInParams params) async {
    return await repository.signInWithEmailAndPassword(
      params.email,
      params.password,
    );
  }
}

class SignInParams extends Equatable {
  final String email;
  final String password;

  const SignInParams({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}
