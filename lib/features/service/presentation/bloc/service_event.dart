part of 'service_bloc.dart';

sealed class ServiceEvent extends Equatable {
  const ServiceEvent();

  @override
  List<Object> get props => [];
}

// Hizmet listesini yükle
class LoadServices extends ServiceEvent {}

// Yeni hizmet eklemek için event
class AddServiceEvent extends ServiceEvent {
  final Service service;
  const AddServiceEvent(this.service);
  @override
  List<Object> get props => [service];
}

// Hizmeti güncellemek için event
class UpdateServiceEvent extends ServiceEvent {
  final Service service;
  const UpdateServiceEvent(this.service);
  @override
  List<Object> get props => [service];
}

// Hizmeti silmek için event
class DeleteServiceEvent extends ServiceEvent {
  final String serviceId;
  const DeleteServiceEvent(this.serviceId);
  @override
  List<Object> get props => [serviceId];
}
