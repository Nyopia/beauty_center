import 'package:dartz/dartz.dart';
import 'package:beauty_center/core/error/failures.dart';
import 'package:equatable/equatable.dart';

abstract class UseCase<ReturnType, Params> {
  Future<Either<Failure, ReturnType>> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}
