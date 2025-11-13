import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/service.dart';
import '../repositories/service_repository.dart';

// --- Hizmet Güncelleme ---

class UpdateService implements UseCase<void, Service> {
  final ServiceRepository repository;

  UpdateService(this.repository);

  @override
  Future<Either<Failure, void>> call(Service service) async {
    return await repository.updateService(service);
  }
}
