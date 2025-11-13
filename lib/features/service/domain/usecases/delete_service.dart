import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/service_repository.dart';

// --- Hizmet Silme ---

class DeleteService implements UseCase<void, String> {
  final ServiceRepository repository;
  DeleteService(this.repository);

  @override
  Future<Either<Failure, void>> call(String params) async {
    return await repository.deleteService(params);
  }
}
