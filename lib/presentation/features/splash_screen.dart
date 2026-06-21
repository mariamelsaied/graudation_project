import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async'; 
import 'package:graduation_app/core/constants/colors_app.dart';
import 'package:graduation_app/core/constants/strings.dart';
import 'package:graduation_app/cubit/auth_cubit.dart'; // تأكدي من مسار الـ Cubit الصحيح
import 'package:graduation_app/cubit/auth_state.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isTimerDone = false;

  @override
  void initState() {
    super.initState();
    
    // عداد الـ 3 ثواني لضمان ظهور اللوجو بشكل مريح للمستخدم
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isTimerDone = true;
        });
        // محاولة التوجيه بناءً على حالة الـ Cubit الحالية بعد انتهاء الوقت
        _handleNavigation(context.read<LoginCubit>().state);
      }
    });
  }

  // دالة المسؤولة عن التوجيه بناءً على الـ State والوقت
  void _handleNavigation(AuthState state) {
    if (!_isTimerDone) return; // لو الـ 3 ثواني مخلصوش، متعملش حاجة وسيب الـ Timer يوجهنا لما يخلص

    if (state is AuthSuccess) {
      // التوكن موجود وتم عمل Auto Login بنجاح -> لوحة التحكم
      Navigator.pushReplacementNamed(context, Strings.dashboard);
    } else if (state is AuthInitial || state is AuthFailure) {
      // التوكن مش موجود أو حصل فشل -> صفحة تسجيل الدخول
      Navigator.pushReplacementNamed(context, Strings.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, AuthState>(
      // الـ Listener هيلقط التغيير لو الـ Cubit خلص فحص بعد الـ 3 ثواني
      listener: (context, state) {
        _handleNavigation(state);
      },
      child: Scaffold(
        backgroundColor: ColorsApp.secondaryBlueColor, 
        body: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 55, 
                height: 55,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage('assets/images/staffly.png'), 
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 16), 
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                      text: "Staff",
                      style: TextStyle(color: ColorsApp.blueColor), 
                    ),
                    TextSpan(
                      text: "ly",
                      style: TextStyle(color: ColorsApp.WhiteColor),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}