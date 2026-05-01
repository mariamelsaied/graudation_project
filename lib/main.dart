import 'package:flutter/material.dart';
import 'package:graduation_app/screens/profile.dart';
import 'package:graduation_app/screens/my_leaves.dart';
import 'package:graduation_app/screens/login.dart';
import 'package:graduation_app/screens/forget_pass.dart';
import 'package:graduation_app/presentation/features/dashboard_screen.dart';
// import 'package:graduation_app/presentation/features/dashboard_screen.dart';
import 'package:graduation_app/presentation/features/my_request_screen.dart';
import 'package:graduation_app/presentation/features/my_tasks_screen.dart';
import 'package:graduation_app/presentation/features/payroll_screen.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HRMS Graduation Project',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home:  LoginScreen (),
    );
  }
}
