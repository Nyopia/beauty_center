import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/service.dart';

abstract class ServiceRepository {
  // Tüm hizmetleri getir
  Future<Either<Failure, List<Service>>> getServices();

  // Yeni hizmet ekle
  Future<Either<Failure, void>> addService(Service service);

  // Hizmet güncelle
  Future<Either<Failure, void>> updateService(Service service);

  // Hizmet sil
  Future<Either<Failure, void>> deleteService(String id);
}
