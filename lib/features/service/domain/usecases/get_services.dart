import 'package:beauty_center/core/error/failures.dart';
import 'package:beauty_center/core/usecases/usecase.dart';
import 'package:beauty_center/features/service/domain/entities/service.dart';
import 'package:beauty_center/features/service/domain/repositories/service_repository.dart';
import 'package:dartz/dartz.dart';

// --- Tüm hizmetleri getir ---

class GetServices implements UseCase<List<Service>, NoParams> {
  final ServiceRepository repository;

  GetServices(this.repository);

  @override
  Future<Either<Failure, List<Service>>> call(NoParams params) async {
    return await repository.getServices();
  }
}
