import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/customer.dart';
import '../repositories/customer_repository.dart';

class AddCustomer implements UseCase<void, Customer> {
  final CustomerRepository repository;
  AddCustomer(this.repository);

  @override
  Future<Either<Failure, void>> call(Customer customer) async {
    return await repository.addCustomer(customer);
  }
}
