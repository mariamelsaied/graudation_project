import 'package:flutter/material.dart';
// استدعاء ملف الألوان الخاص بالمشروع بناءً على هيكل الفولدرات
import '../core/constants/colors_app.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // التدرج اللوني من كلاس ColorsApp الخاص بالمشروع
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              ColorsApp.darknavyblueColor, // من ملف ألوان المشروع
              ColorsApp.blackColor, // من ملف ألوان المشروع
            ],
            stops: const [0.0, 0.5],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 60),

                    // --- الجزء العلوي (أيقونة الشخص) ---
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: ColorsApp.darkblueColor.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.person_outline,
                        color: ColorsApp.blueColor, // أزرق المشروع
                        size: 40,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      "Welcome !",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Log in to keep everything running smoothly and deliver great care.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: ColorsApp.greyColor, // رمادي المشروع
                        fontSize: 15,
                      ),
                    ),

                    const SizedBox(height: 60),

                    // --- حقل الإيميل ---
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Email",
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: emailController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Your email",
                        hintStyle: TextStyle(
                          color: ColorsApp.greyColor.withOpacity(0.5),
                        ),
                        filled: true,
                        fillColor: ColorsApp.blackColor.withOpacity(0.4),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator:
                          (value) =>
                              value!.isEmpty ? "Email is required" : null,
                    ),

                    const SizedBox(height: 25),

                    // --- حقل الباسورد ---
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Password",
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: passwordController,
                      obscureText: isObscure,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Enter your password",
                        hintStyle: TextStyle(
                          color: ColorsApp.greyColor.withOpacity(0.5),
                        ),
                        filled: true,
                        fillColor: ColorsApp.blackColor.withOpacity(0.4),
                        suffixIcon: IconButton(
                          icon: Icon(
                            isObscure ? Icons.visibility_off : Icons.visibility,
                            color: ColorsApp.greyColor,
                          ),
                          onPressed:
                              () => setState(() => isObscure = !isObscure),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator:
                          (value) =>
                              value!.isEmpty ? "Password is required" : null,
                    ),

                    const SizedBox(height: 40),

                    // --- زرار الدخول (Sign in) ---
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            ColorsApp.greyColor, // لون الزرار من المشروع
                        minimumSize: const Size(double.infinity, 60),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          debugPrint("Sign in tapped!");
                        }
                      },
                      child: const Text(
                        "Sign in",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    // باقي الصفحة هيفضل واخد لون الخلفية المدرج
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
