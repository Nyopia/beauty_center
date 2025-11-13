import 'package:beauty_center/features/service/data/datasources/service_remote_data_source.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:beauty_center/features/service/data/models/service_model.dart';
import 'package:firebase_core/firebase_core.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/service.dart';
import '../../domain/repositories/service_repository.dart';

// Bu sınıf, DataSource'u çağıracak ve hataları Failure'a çevierecek.

class ServiceRepositoryImpl implements ServiceRepository {
  final ServiceRemoteDataSource remoteDataSource;

  ServiceRepositoryImpl({required this.remoteDataSource});

  // --- getServices ---
  @override
  Future<Either<Failure, List<Service>>> getServices() async {
    try {
      final services = await remoteDataSource.getServices();
      // remoteDataSource'dan gelen ServiceModel listesi, aynı zamanda
      // Service listesi olduğu için doğrudan döndürebiliriz.
      return Right(services);
    } on FirebaseException catch (e) {
      print('🔥🔥🔥 Firestore Hatası (ServiceRepo): ${e.toString()}');
      return Left(ServerFailure());
    }
  }

  // --- addService ---
  @override
  Future<Either<Failure, void>> addService(Service service) async {
    try {
      // Domainden gelen Service entity'sini Data katmanın anlayacağı ServiceModel'e çeviriyoruz.
      final serviceModel = ServiceModel(
        id: '', // Add işleminde ID'yi Firestore oluşturacak.
        name: service.name,
        price: service.price,
        durationInMinutes: service.durationInMinutes,
      );
      await remoteDataSource.addService(serviceModel);
      return const Right(null);
    } on FirebaseException catch (e) {
      print('🔥🔥🔥 Firestore Hatası (ServiceRepo): ${e.toString()}');
      return Left(ServerFailure());
    }
  }

  // --- deleteService ---
  @override
  Future<Either<Failure, void>> deleteService(String serviceId) async {
    try {
      await remoteDataSource.deleteService(serviceId);
      return const Right(null);
    } on FirebaseException catch (e) {
      print('🔥🔥🔥 Firestore Hatası (ServiceRepo): ${e.toString()}');
      return Left(ServerFailure());
    }
  }

  // --- updateService ---
  @override
  Future<Either<Failure, void>> updateService(Service service) async {
    try {
      final serviceModel = ServiceModel(
        id: service.id,
        name: service.name,
        price: service.price,
        durationInMinutes: service.durationInMinutes,
      );
      await remoteDataSource.updateService(serviceModel);
      return const Right(null);
    } on FirebaseException catch (e) {
      print('🔥🔥🔥 Firestore Hatası (ServiceRepo): ${e.toString()}');
      return Left(ServerFailure());
    }
  }
}
