import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/customer.dart';

abstract class CustomerRepository {
  // Müşterileri listele
  Future<Either<Failure, List<Customer>>> getCustomers();

  // Müşteriyi ekle
  Future<Either<Failure, void>> addCustomer(Customer customer);

  // Müşteriyi güncelle
  Future<Either<Failure, void>> updateCustomer(Customer customer);

  // Müşteriyi sil
  Future<Either<Failure, void>> deleteCustomer(String customerId);
}
