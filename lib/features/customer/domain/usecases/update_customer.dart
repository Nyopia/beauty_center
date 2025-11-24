import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/customer.dart';
import '../repositories/customer_repository.dart';

class UpdateCustomer implements UseCase<void, Customer> {
  final CustomerRepository repository;
  UpdateCustomer(this.repository);

  @override
  Future<Either<Failure, void>> call(Customer updatedCustomer) async {
    return await repository.updateCustomer(updatedCustomer);
  }
}
