import 'package:beauty_center/features/customer/data/models/customer_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class CustomerRemoteDataSource {
  Future<List<CustomerModel>> getCustomers();
  Future<void> addCustomer(CustomerModel customer);
  Future<void> updateCustomer(CustomerModel customer);
  Future<void> deleteCustomer(String customerId);
}

class CustomerRemoteDataSourceImpl implements CustomerRemoteDataSource {
  final FirebaseFirestore firestore;

  CustomerRemoteDataSourceImpl({required this.firestore});

  // 'customers' koleksiyonuna referans
  CollectionReference get _customerCollection =>
      firestore.collection('customers');

  @override
  Future<void> addCustomer(CustomerModel customer) async {
    await _customerCollection.add(customer.toMap());
  }

  @override
  Future<List<CustomerModel>> getCustomers() async {
    final snapshot = await _customerCollection.get();
    return snapshot.docs.map((doc) => CustomerModel.fromSnapshot(doc)).toList();
  }

  @override
  Future<void> updateCustomer(CustomerModel customer) async {
    await _customerCollection.doc(customer.id).update(customer.toMap());
  }

  @override
  Future<void> deleteCustomer(String customerId) async {
    await _customerCollection.doc(customerId).delete();
  }
}
