import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/service.dart';

// Bu model, firestore'dan gelen veriyi bizim Service entity'mize çevirecek.

class ServiceModel extends Service {
  const ServiceModel({
    required super.id,
    required super.name,
    required super.price,
    required super.durationInMinutes,
    // daha sonradan service'ler hakkında bir şey eklememiz gerekirse
  });

  // Firestore'dan gelen DocumentSnapshot'ı ServiceModel'e çevir.

  factory ServiceModel.fromSnapshot(DocumentSnapshot snap) {
    var data = snap.data() as Map<String, dynamic>;
    return ServiceModel(
      id: snap.id,
      name: data['name'],
      price: (data['price'] as num)
          .toDouble(), // firestore'dan gelen sayı double olmayabilir.
      durationInMinutes: data['durationInMinutes'],
    );
  }

  // ServiceModel'i Firestore'a yazmak için Map'e çevir.
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'durationInMinutes': durationInMinutes,
    };
  }
}
