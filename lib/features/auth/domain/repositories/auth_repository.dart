// --- REPOSITORY ARAYÜZÜ (ABSTRACT) DOSYASI ---
// GÖREVİ: Veri katmanı için "sözleşme" (contract) belirler.
// Örnek: 'abstract class UserRepository'.
//
// KURAL 1: İçinde metotların SADECE imzaları bulunur (gövdesi olmaz).
// KURAL 2: UseCase'ler bu sınıfa bağımlıdır, somut (Impl) sınıfa değil.
// KURAL 3: Bu dosya "Domain" (İş Mantığı) katmanında yer alır.
// KURAL 4: "Nereden" (API, DB) geldiğini belli eden kodlar içermez.
import 'package:dartz/dartz.dart';
import 'package:beauty_center/core/error/failures.dart';
import 'package:beauty_center/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  // Eposta ve şifre ile giriş.
  Future<Either<Failure, User>> signInWithEmailAndPassword(
    String email,
    String password,
  );

  // signOut fonksiyonu

  Future<Either<Failure, void>> signOut();
  // neden void? çünkü başarılı olursa
  // döndüreceğimiz bir veri yok - çıkış yaptı.
}
