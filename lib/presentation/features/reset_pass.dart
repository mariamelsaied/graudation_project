import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/colors_app.dart';
import '../../cubit/forget_password_cubit.dart';
import '../../cubit/forget_password_state.dart';
import 'login.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  const ResetPasswordScreen({super.key, required this.email});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  bool isObscureNew = true;
  bool isObscureConfirm = true;

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ForgetPasswordCubit(),
      child: Scaffold(
        backgroundColor: ColorsApp.darknavyblueColor,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: BlocConsumer<ForgetPasswordCubit, ForgetPasswordState>(
          listener: (context, state) {
            if (state is ForgetPasswordResetSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Password reset successfully!"),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            } else if (state is ForgetPasswordFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage),
                  backgroundColor: Colors.redAccent,
                ),
              );
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      "Reset Password",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Your new password must be different from previously used passwords.",
                      style: TextStyle(
                        color: ColorsApp.greyColor.withOpacity(0.8),
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 40),

                    const Text("New Password",
                        style: TextStyle(color: Colors.white, fontSize: 14)),
                    const SizedBox(height: 10),
                    _buildPasswordField(
                      controller: passwordController,
                      hint: "Enter new password",
                      isObscure: isObscureNew,
                      onToggle: () => setState(() => isObscureNew = !isObscureNew),
                      validator: (value) {
                        if (value == null || value.isEmpty) return "Password is required";
                        if (value.length < 6) return "Password must be at least 6 characters";
                        return null;
                      },
                    ),

                    const SizedBox(height: 25),

                    const Text("Confirm Password",
                        style: TextStyle(color: Colors.white, fontSize: 14)),
                    const SizedBox(height: 10),
                    _buildPasswordField(
                      controller: confirmPasswordController,
                      hint: "Confirm your password",
                      isObscure: isObscureConfirm,
                      onToggle: () => setState(() => isObscureConfirm = !isObscureConfirm),
                      validator: (value) {
                        if (value == null || value.isEmpty) return "Please confirm your password";
                        if (value != passwordController.text) return "Passwords do not match";
                        return null;
                      },
                    ),

                    const Spacer(),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorsApp.blueColor,
                        minimumSize: const Size(double.infinity, 55),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: state is ForgetPasswordLoading
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                context.read<ForgetPasswordCubit>().resetPassword(
                                      widget.email,
                                      passwordController.text,
                                    );
                              }
                            },
                      child: state is ForgetPasswordLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              "Reset Password",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hint,
    required bool isObscure,
    required VoidCallback onToggle,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isObscure,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: ColorsApp.greyColor.withOpacity(0.3)),
        filled: true,
        fillColor: ColorsApp.blackColor.withOpacity(0.4),
        suffixIcon: IconButton(
          icon: Icon(
            isObscure ? Icons.visibility_off : Icons.visibility,
            color: ColorsApp.greyColor,
          ),
          onPressed: onToggle,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        errorStyle: const TextStyle(color: Colors.redAccent),
      ),
      validator: validator,
    );
  }
}