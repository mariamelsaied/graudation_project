import 'package:flutter/material.dart';
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

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
    
     
      home:PayrollScreen(),
    );
  }
}

