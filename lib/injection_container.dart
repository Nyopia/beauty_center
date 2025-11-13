import 'package:beauty_center/features/auth/domain/usecases/signout_user.dart';
import 'package:beauty_center/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/signin_user.dart';

import 'features/service/data/datasources/service_remote_data_source.dart';
import 'features/service/data/repositories/service_repository_impl.dart';
import 'features/service/domain/repositories/service_repository.dart';
import 'features/service/domain/usecases/add_service.dart';
import 'features/service/domain/usecases/delete_service.dart';
import 'features/service/domain/usecases/get_services.dart';
import 'features/service/domain/usecases/update_service.dart';
import 'features/service/presentation/bloc/service_bloc.dart';

// Service locator - GetIt
final sl = GetIt.instance;

Future<void> init() async {
  // ##################################################################
  // #                        FEATURES - AUTH                         #
  // ##################################################################

  // BLoC
  // AuthBloc'a her ihtiyaç duyulduğunda yeni bir instance oluşturulacak.
  sl.registerFactory(() => AuthBloc(signInUser: sl(), signOutUser: sl()));

  // Use Cases
  // genelde state tutmadıkları için lazySingleton olarak kaydedilir.
  // Sadece ilk ihtyiaç duyulduğunda oluşturulur ve sonra hep aynı instance kullanılır.

  sl.registerLazySingleton(() => SignInUser(sl()));
  sl.registerLazySingleton(() => SignOutUser(sl()));

  // Repository
  // Repository arayüzünü(AuthRepository) kaydederken, somut implementasyonunu (AuthRepositoryImpl) veriyoruz.

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );

  // Data Sources

  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(firebaseAuth: sl(), firestore: sl()),
  );

  // ##################################################################
  // #                      FEATURES - SERVICE                        #
  // ##################################################################

  // BLoC
  sl.registerFactory(
    () => ServiceBloc(
      getServices: sl(),
      addService: sl(),
      updateService: sl(),
      deleteService: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetServices(sl()));
  sl.registerLazySingleton(() => AddService(sl()));
  sl.registerLazySingleton(() => UpdateService(sl()));
  sl.registerLazySingleton(() => DeleteService(sl()));

  // Repository
  sl.registerLazySingleton<ServiceRepository>(
    () => ServiceRepositoryImpl(remoteDataSource: sl()),
  );

  // Data Sources
  sl.registerLazySingleton<ServiceRemoteDataSource>(
    () => ServiceRemoteDataSourceImpl(firestore: sl()),
  );

  // ##################################################################
  // #                          EXTERNAL                              #
  // ##################################################################

  // Dış bağımlılıklar(Firebase, sharedpreferences etc..) kaydediyoruz.
  final firebaseAuth = FirebaseAuth.instance;
  sl.registerLazySingleton(() => firebaseAuth);

  final firestore = FirebaseFirestore.instance;
  sl.registerLazySingleton(() => firestore);
}
