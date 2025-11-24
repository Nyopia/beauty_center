import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/customer.dart';

class CustomerModel extends Customer {
  const CustomerModel({
    required super.id,
    required super.name,
    required super.phoneNumber,
    super.note,
  });

  // Firestore'dan gelen veriyi modele çevir
  factory CustomerModel.fromSnapshot(DocumentSnapshot snap) {
    var data = snap.data() as Map<String, dynamic>;

    return CustomerModel(
      id: snap.id,
      name: data['name'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      note: data['note'],
    );
  }

  // Modeli Firestore'a gönderilecek Map'e çevir
  Map<String, dynamic> toMap() {
    return {'name': name, 'phoneNumber': phoneNumber, 'note': note};
  }
}
