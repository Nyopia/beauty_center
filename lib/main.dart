import 'package:beauty_center/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:beauty_center/features/auth/presentation/pages/wrapper_page.dart';
import 'package:beauty_center/package_export.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'injection_container.dart' as di; // dependency injection

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Flutter projesini Firebase projesine bağlayan asenkron işlem.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Dependency injectionu başlat.
  await di.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          di.sl<AuthBloc>(), // Depodan (sl) AuthBloc'u aldık ve sağladık.
      child: MaterialApp(
        title: 'Güzellik Salonu',
        theme: ThemeData(
          primarySwatch: Colors.amber,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const WrapperPage(),
      ),
    );
  }
}
