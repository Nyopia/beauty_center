import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/service_model.dart';

// bu sınıf, Firebase ile doğrudan konuşacak sınıf.
abstract class ServiceRemoteDataSource {
  Future<List<ServiceModel>> getServices();
  Future<void> addService(ServiceModel service);
  Future<void> updateService(ServiceModel service);
  Future<void> deleteService(String serviceId);
}

class ServiceRemoteDataSourceImpl implements ServiceRemoteDataSource {
  final FirebaseFirestore firestore;
  ServiceRemoteDataSourceImpl({required this.firestore});

  // Firestore'daki 'services' koleksiyonuna bir referans oluşturalım.
  final _serviceCollection = FirebaseFirestore.instance.collection('services');

  @override
  Future<List<ServiceModel>> getServices() async {
    final snapshot = await _serviceCollection.get();
    return snapshot.docs.map((doc) => ServiceModel.fromSnapshot(doc)).toList();
  }

  @override
  Future<void> addService(ServiceModel service) async {
    // ServiceModel'i Map'e çevirip Firestore'a ekliyoruz.
    await _serviceCollection.add(service.toMap());
  }

  @override
  Future<void> deleteService(String serviceId) async {
    await _serviceCollection.doc(serviceId).delete();
  }

  @override
  Future<void> updateService(ServiceModel service) async {
    await _serviceCollection.doc(service.id).update(service.toMap());
  }
}
