import 'package:beauty_center/features/auth/domain/entities/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel extends User {
  const UserModel({
    required super.uid,
    required super.email,
    required super.name,
    required super.role,
  });

  // Firestore'dan gelen DocumentSnapshot'ı Usermodel'e çeviren factory constructor
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      role: data['role'] ?? 'personnel',
    );
  }

  // UserModel'i Firestore'a yazmak için Map'e çeviren metot.
  Map<String, dynamic> toMap() {
    return {'email': email, 'name': name, 'role': role};
  }
}
