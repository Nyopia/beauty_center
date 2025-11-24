import 'package:beauty_center/core/usecases/usecase.dart';
import 'package:beauty_center/features/customer/domain/entities/customer.dart';
import 'package:beauty_center/features/customer/domain/usecases/add_customer.dart';
import 'package:beauty_center/features/customer/domain/usecases/delete_customer.dart';
import 'package:beauty_center/features/customer/domain/usecases/get_customers.dart';
import 'package:beauty_center/features/customer/domain/usecases/update_customer.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'customer_event.dart';
part 'customer_state.dart';

class CustomerBloc extends Bloc<CustomerEvent, CustomerState> {
  final GetCustomers getCustomers;
  final AddCustomer addCustomer;
  final UpdateCustomer updateCustomer;
  final DeleteCustomer deleteCustomer;

  CustomerBloc({
    required this.getCustomers,
    required this.addCustomer,
    required this.updateCustomer,
    required this.deleteCustomer,
  }) : super(CustomerInitial()) {
    on<LoadCustomersEvent>(_onLoadCustomers);
    on<AddCustomerEvent>(_onAddCustomer);
    on<UpdateCustomerEvent>(_onUpdateCustomer);
    on<DeleteCustomerEvent>(_onDeleteCustomer);
  }

  Future<void> _onLoadCustomers(
    LoadCustomersEvent event,
    Emitter<CustomerState> emit,
  ) async {
    emit(CustomerLoading());
    final result = await getCustomers(NoParams());
    result.fold(
      (failure) => emit(CustomerError('Müşteriler yüklenemedi.')),
      (customers) => emit(CustomerLoaded(customers)),
    );
  }

  Future<void> _onAddCustomer(
    AddCustomerEvent event,
    Emitter<CustomerState> emit,
  ) async {
    emit(CustomerLoading());
    final result = await addCustomer(event.customer);
    result.fold((failure) => emit(CustomerError('Müşteri eklenemedi.')), (_) {
      emit(CustomerSuccess());
      add(LoadCustomersEvent());
    });
  }

  Future<void> _onUpdateCustomer(
    UpdateCustomerEvent event,
    Emitter<CustomerState> emit,
  ) async {
    emit(CustomerLoading());
    final result = await updateCustomer(event.customer);
    result.fold((failure) => emit(CustomerError('Müşteri güncellenemedi.')), (
      _,
    ) {
      emit(CustomerSuccess());
      add(LoadCustomersEvent());
    });
  }

  Future<void> _onDeleteCustomer(
    DeleteCustomerEvent event,
    Emitter<CustomerState> emit,
  ) async {
    emit(CustomerLoading());
    final result = await deleteCustomer(event.customerId);
    result.fold((failure) => emit(CustomerError('Müşteri silinemedi.')), (_) {
      emit(CustomerSuccess());
      add(LoadCustomersEvent());
    });
  }
}
