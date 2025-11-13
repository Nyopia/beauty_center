import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beauty_center/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:beauty_center/features/auth/presentation/pages/login_page.dart';
import '../../../../home_page.dart';

class WrapperPage extends StatelessWidget {
  const WrapperPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthSuccess) {
          // Kullanıcı giriş yapmıs ise HomePage'e yönlendir.
          return const HomePage();
        } else {
          // Kullanıcı giriş yapmamış ise LoginPage'e yönlendir.
          return const LoginPage();
        }
      },
    );
  }
}
