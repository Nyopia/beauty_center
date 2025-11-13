import 'package:beauty_center/features/service/domain/entities/service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beauty_center/core/usecases/usecase.dart';
import 'package:beauty_center/features/service/domain/usecases/add_service.dart';
import 'package:beauty_center/features/service/domain/usecases/delete_service.dart';
import 'package:beauty_center/features/service/domain/usecases/get_services.dart';
import 'package:beauty_center/features/service/domain/usecases/update_service.dart';

part 'service_event.dart';
part 'service_state.dart';

class ServiceBloc extends Bloc<ServiceEvent, ServiceState> {
  final GetServices getServices;
  final AddService addService;
  final UpdateService updateService;
  final DeleteService deleteService;

  ServiceBloc({
    required this.getServices,
    required this.addService,
    required this.updateService,
    required this.deleteService,
  }) : super(ServiceInitial()) {
    on<LoadServices>(_onLoadServices);
    on<AddServiceEvent>(_onAddService); // DÜZELTİLDİ
    on<UpdateServiceEvent>(_onUpdateService); // DÜZELTİLDİ
    on<DeleteServiceEvent>(_onDeleteService); // DÜZELTİLDİ
  }

  // Hizmetleri yükleyen method
  Future<void> _onLoadServices(
    LoadServices event,
    Emitter<ServiceState> emit,
  ) async {
    emit(ServiceLoading());
    final result = await getServices(NoParams());
    result.fold(
      (failure) => emit(const ServiceError('Hizmetler Yüklenemedi!')),
      (services) => emit(ServiceLoaded(services)),
    );
  }

  // Yeni hizmet ekleme methodu
  Future<void> _onAddService(
    AddServiceEvent event,
    Emitter<ServiceState> emit,
  ) async {
    emit(ServiceLoading());
    final result = await addService(event.service);
    result.fold(
      (failure) => emit(const ServiceError('Hizmet eklenemedi.')),
      (_) => emit(ServiceSuccess()),
    );
  }

  // Hizmeti güncelleyen metod
  Future<void> _onUpdateService(
    UpdateServiceEvent event,
    Emitter<ServiceState> emit,
  ) async {
    emit(ServiceLoading());
    final result = await updateService(event.service);
    result.fold(
      (failure) => emit(const ServiceError('Hizmet güncellenemedi.')),
      (_) => emit(ServiceSuccess()),
    );
  }

  // Hizmeti silen metod
  Future<void> _onDeleteService(
    DeleteServiceEvent event,
    Emitter<ServiceState> emit,
  ) async {
    emit(ServiceLoading());
    final result = await deleteService(event.serviceId);
    result.fold(
      (failure) => emit(const ServiceError('Hizmet silinemedi.')),
      (_) => emit(ServiceSuccess()),
    );
  }
}
