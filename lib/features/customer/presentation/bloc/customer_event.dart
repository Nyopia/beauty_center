part of 'customer_bloc.dart';

sealed class CustomerEvent extends Equatable {
  const CustomerEvent();

  @override
  List<Object> get props => [];
}

class LoadCustomersEvent extends CustomerEvent {}

class AddCustomerEvent extends CustomerEvent {
  final Customer customer;

  const AddCustomerEvent(this.customer);

  @override
  List<Object> get props => [customer];
}

class UpdateCustomerEvent extends CustomerEvent {
  final Customer customer;

  const UpdateCustomerEvent(this.customer);

  @override
  List<Object> get props => [customer];
}

class DeleteCustomerEvent extends CustomerEvent {
  final String customerId;

  const DeleteCustomerEvent(this.customerId);

  @override
  List<Object> get props => [customerId];
}
