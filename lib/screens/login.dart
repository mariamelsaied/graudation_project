import 'package:flutter/material.dart';
import '../core/constants/colors_app.dart';
import 'forget_pass.dart'; 

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
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              ColorsApp.darknavyblueColor,
              ColorsApp.darknavyblueColor.withOpacity(1),
              ColorsApp.midnightBlueColor,
            ],
            stops: const [0.0, 0.4, 1.0],
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

                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: ColorsApp.darkblueColor.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.person_outline,
                        color: ColorsApp.blueColor,
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
                        color: ColorsApp.greyColor,
                        fontSize: 15,
                      ),
                    ),

                    const SizedBox(height: 60),

                    // Email Field
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

                    // Password Field
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

                    Align(
                      alignment: Alignment.centerRight,
                      child: Transform.translate(
                        offset: const Offset(
                          0,
                          -1,
                        ), 
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => const ForgetPasswordScreen(),
                              ),
                            );
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(50, 30),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text(
                            "Forget password",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 17),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorsApp.greyColor,
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

                    const SizedBox(height: 200),
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
