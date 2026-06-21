import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_app/core/constants/colors_app.dart';
import 'package:graduation_app/core/constants/strings.dart';
import 'package:graduation_app/core/helper/dio_helper.dart';
import 'package:graduation_app/cubit/auth_cubit.dart';
import 'package:graduation_app/cubit/payroll_cubit.dart'; 
import 'package:graduation_app/cubit/leave_cubit.dart'; 
import 'package:graduation_app/cubit/attendance_cubit.dart';
import 'package:graduation_app/cubit/performance_cubit.dart';
import 'package:graduation_app/cubit/request_cubit.dart'; 
import 'package:graduation_app/cubit/dashboard_cubit.dart';
import 'package:graduation_app/cubit/chatbot_cubit.dart';
import 'package:graduation_app/cubit/task_cubit.dart'; 
import 'package:graduation_app/cubit/profile_cubit.dart'; 
import 'package:graduation_app/presentation/features/AuthWrapper.dart';
import 'package:graduation_app/presentation/features/My_Task_Screen.dart';
import 'package:graduation_app/presentation/features/attendance_page.dart';
import 'package:graduation_app/presentation/features/chatbot_screen.dart';
import 'package:graduation_app/presentation/features/general_setting_screen.dart';
import 'package:graduation_app/presentation/features/help_support_screen.dart';
import 'package:graduation_app/presentation/features/legal_info_screen.dart';
import 'package:graduation_app/presentation/features/performance_screen.dart';
import 'package:graduation_app/presentation/features/setting_screen.dart';
import 'package:graduation_app/presentation/features/login.dart';
import 'package:graduation_app/presentation/features/forget_pass.dart';
import 'package:graduation_app/presentation/features/dashboard_screen.dart';
import 'package:graduation_app/presentation/features/my_request_screen.dart';
import 'package:graduation_app/presentation/features/payroll_screen.dart';
import 'package:graduation_app/presentation/features/my_leaves.dart';
import 'package:graduation_app/presentation/features/profile_page.dart';
import 'package:graduation_app/presentation/features/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DioHelper.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginCubit>(
          create: (context) => LoginCubit()..checkAutoLogin(),
        ),
        BlocProvider<PayrollCubit>(
          create: (context) => PayrollCubit(),
        ),
        BlocProvider<LeaveCubit>(
          create: (context) => LeaveCubit(),
        ),
        BlocProvider<AttendanceCubit>(
          create: (context) => AttendanceCubit(), 
        ),
        BlocProvider<RequestCubit>(
          create: (context) => RequestCubit(), 
        ),
        BlocProvider<DashboardCubit>(
          create: (context) => DashboardCubit(), 
        ),
        BlocProvider<EmployeePerformanceCubit>(
          create: (context) => EmployeePerformanceCubit(), 
        ),
        BlocProvider<ChatbotCubit>(
          create: (context) => ChatbotCubit(),
        ),
        BlocProvider<TaskStatsCubit>(
          create: (context) => TaskStatsCubit(),
        ),
        BlocProvider<ProfileCubit>(
          create: (context) => ProfileCubit(),
        ),
      ],
      child: MaterialApp(
        title: 'HRMS Graduation Project',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          canvasColor: ColorsApp.darknavyblueColor,
        ),
        home: const SplashScreen(),
        routes: {
          Strings.login: (context) => const LoginScreen(),
          Strings.splash: (context) => const SplashScreen(),
          Strings.dashboard: (context) => const DashboardScreen(),
          Strings.profile: (context) => const ProfileScreen(),
          Strings.forget: (context) => const ForgetPasswordScreen(),
          Strings.payroll: (context) => const PayrollPage(),
          Strings.request: (context) => const MyRequestsPage(),
          Strings.setting: (context) => const SettingsScreen(),
          Strings.genralSetting: (context) => const GeneralSettingsScreen(),
          Strings.helpAndSupportSetting: (context) => const HelpSupportScreen(),
          Strings.legalAppSetting: (context) => const LegalInfoScreen(),
          Strings.leaves: (context) => const MyLeavesPage(),
          Strings.attendance: (context) => const AttendancePage(),
          Strings.performance: (context) => const EmployeePerformanceScreen(),
          Strings.chatbot: (context) => const ChatbotScreen(),
          Strings.tasks: (context) => const MyTaskScreen(),
        },
      ),
    );
  }
}