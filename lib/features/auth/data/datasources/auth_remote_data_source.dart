import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signInWithEmailAndPassword(String email, String password);
  Future<void> signOut();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthRemoteDataSourceImpl({
    required firebase_auth.FirebaseAuth firebaseAuth,
    required FirebaseFirestore firestore,
  }) : _firebaseAuth = firebaseAuth,
       _firestore = firestore;

  @override
  Future<UserModel> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      // 1. Firebase Auth ile kullanıcı girişi yap
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final firebaseUser = userCredential.user;
      if (firebaseUser == null) {
        throw Exception('Giriş başarısız, kullanıcı bulunamadı.');
      }

      // 2. Firestore'dan kullanıcının ek bilgilerini (rol, isim vb.) çek
      final userDoc = await _firestore
          .collection('users')
          .doc(firebaseUser.uid)
          .get();

      if (!userDoc.exists) {
        throw Exception('Kullanıcı veritabanında bulunamadı.');
      }

      // 3. Firestore'dan gelen veriyi UserModel'e çevir ve döndür
      return UserModel.fromFirestore(userDoc);
    } on firebase_auth.FirebaseAuthException catch (e) {
      // Hatanın detayını görmek için bunu ekle
      print('🔥🔥🔥 Firebase Auth Hatası: ${e.code} - ${e.message}');
      throw Exception(e.message);
    } catch (e) {
      // Genel hatanın detayını görmek için bunu ekle
      print('🔥🔥🔥 Genel Hata: ${e.toString()}');
      throw Exception('Bilinmeyen bir hata oluştu.');
    }
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
