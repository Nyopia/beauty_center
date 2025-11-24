import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/customer.dart';
import '../../domain/repositories/customer_repository.dart';
import '../datasources/customer_remote_data_source.dart';
import '../models/customer_model.dart';

class CustomerRepositoryImpl implements CustomerRepository {
  final CustomerRemoteDataSource remoteDataSource;

  CustomerRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, void>> addCustomer(Customer customer) async {
    try {
      final customerModel = CustomerModel(
        id: '',
        name: customer.name,
        phoneNumber: customer.phoneNumber,
        note: customer.note,
      );
      await remoteDataSource.addCustomer(customerModel);
      return const Right(null);
    } catch (e) {
      print('🔥🔥🔥 Add Customer Error: $e');
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteCustomer(String customerId) async {
    try {
      await remoteDataSource.deleteCustomer(customerId);
      return const Right(null);
    } catch (e) {
      print('🔥🔥🔥 Delete Customer Error: $e');
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Customer>>> getCustomers() async {
    try {
      final customers = await remoteDataSource.getCustomers();
      return Right(customers);
    } catch (e) {
      print('🔥🔥🔥 Get Customers Error: $e');
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updateCustomer(Customer customer) async {
    try {
      final customerModel = CustomerModel(
        id: customer.id,
        name: customer.name,
        phoneNumber: customer.phoneNumber,
        note: customer.note,
      );
      await remoteDataSource.updateCustomer(customerModel);
      return const Right(null);
    } catch (e) {
      print('🔥🔥🔥 Update Customer Error: $e');
      return Left(ServerFailure());
    }
  }
}
