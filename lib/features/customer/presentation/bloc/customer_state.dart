part of 'customer_bloc.dart';

sealed class CustomerState extends Equatable {
  const CustomerState();

  @override
  List<Object> get props => [];
}

class CustomerInitial extends CustomerState {}

class CustomerLoading extends CustomerState {}

class CustomerSuccess
    extends CustomerState {} // ekleme güncellleme silme sonrası.

class CustomerLoaded extends CustomerState {
  final List<Customer> customers;
  const CustomerLoaded(this.customers);

  @override
  List<Object> get props => [customers];
}

class CustomerError extends CustomerState {
  final String message;
  const CustomerError(this.message);

  @override
  List<Object> get props => [message];
}
