import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_app/cubit/auth_cubit.dart';
import 'package:graduation_app/cubit/auth_state.dart';
import 'package:graduation_app/presentation/features/dashboard_screen.dart';
import 'package:graduation_app/presentation/features/login.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (state is AuthSuccess) {
          return const DashboardScreen(); 
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}