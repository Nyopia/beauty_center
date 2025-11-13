import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

// Parametre almayan Usecase'ler için bir NoParams sınıfı oluşturacağız.

class SignOutUser implements UseCase<void, NoParams> {
  final AuthRepository repository;
  SignOutUser(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.signOut();
  }
}
