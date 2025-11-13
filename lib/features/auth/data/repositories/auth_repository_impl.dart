// --- REPOSITORY UYGULAMASI (IMPL) DOSYASI ---
// GÖREVİ: Arayüzde (abstract class) tanımlanan metotları uygular (override eder).
// Örnek: 'class UserRepositoryImpl implements UserRepository'.
//
// KURAL 1: Gerçek "kirli" işi (API, Veritabanı, Cache) bu sınıf yapar.
// KURAL 2: ApiService, LocalDatabase gibi veri kaynaklarına bağımlıdır.
// KURAL 3: Veri kaynaklarını yönetir (örn: "önce cache'e bak, yoksa API'ye git").
// KURAL 4: Bu dosya "Data" (Veri) katmanında yer alır.

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

// Domain katmanındaki soyut AuthRepository sınıfını uyguluyoruz.
class AuthRepositoryImpl implements AuthRepository {
  // Bu repository, işini yapmak için bir veri kaynağına ihtiyaç duyar.
  final AuthRemoteDataSource remoteDataSource;

  // Constructor
  // Bu sınıf oluşturulurken dışarıdan bir remoteDataSource verilmesi ZORUNLUDUR.
  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, User>> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      // Veri kaynağından kullanıcıyı getirmesini istiyoruz.
      final userModel = await remoteDataSource.signInWithEmailAndPassword(
        email,
        password,
      );

      // başarılı sonucu (UserModel bir User'dır) Right döndürüyoruz.
      return Right(userModel);
    } catch (e) {
      // Hata varsa Left döndürüyoruz.
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await remoteDataSource.signOut();
      return Right(null);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
