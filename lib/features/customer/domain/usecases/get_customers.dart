import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/customer.dart';
import '../repositories/customer_repository.dart';

// Parametre almadığı için NoParams kullanıyoruz

class GetCustomers implements UseCase<List<Customer>, NoParams> {
  final CustomerRepository repository;
  GetCustomers(this.repository);

  @override
  Future<Either<Failure, List<Customer>>> call(NoParams params) async {
    return await repository.getCustomers();
  }
}
