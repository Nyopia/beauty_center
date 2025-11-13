part of 'service_bloc.dart';

sealed class ServiceState extends Equatable {
  const ServiceState();

  @override
  List<Object> get props => [];
}

// Başlangıç durumu
class ServiceInitial extends ServiceState {}

// Yüklenme durumu
class ServiceLoading extends ServiceState {}

// Hizmetler başarıyla yüklendiğinde
class ServiceLoaded extends ServiceState {
  final List<Service> services;
  const ServiceLoaded(this.services);
  @override
  List<Object> get props => [services];
}

// Herhangi bir işlem (ekleme, silme, güncelleme) başarıyla tamamlandığında
class ServiceSuccess extends ServiceState {}

// Bir hata oluştuğunda
class ServiceError extends ServiceState {
  final String message;
  const ServiceError(this.message);
  @override
  List<Object> get props => [message];
}
