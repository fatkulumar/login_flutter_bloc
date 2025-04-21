import 'package:flutter/material.dart';
import 'package:flutter_application_2/pages/widgets/custom_button.dart';
import 'package:flutter_application_2/pages/widgets/header_text.dart';
import 'package:flutter_application_2/pages/widgets/custom_text_field.dart';
import 'package:flutter_application_2/shared/shared.dart';

void showRegisterFormSheet(BuildContext context) {
  showModalBottomSheet(
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    context: context,
    builder: (context) => const _RegisterFormSheet(),
  );
}

class _RegisterFormSheet extends StatefulWidget {
  const _RegisterFormSheet(); // ← ini cara modern

  @override
  State<_RegisterFormSheet> createState() => _RegisterFormSheetState();
}

class _RegisterFormSheetState extends State<_RegisterFormSheet> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController courseController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    courseController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _register() {
    final email = emailController.text;
    final course = courseController.text;
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    // TODO: Lakukan validasi dan aksi register di sini
    print('Email: $email, Course: $course, password: $password, confirmPassword: $confirmPassword');
  }

  void _tootlePasswordView() {
    setState(() {
      _isHiddenPassword = !_isHiddenPassword;
    });
  }

  void _tootleConfirmPasswordView() {
    setState(() {
      _isHiddenConfirmPassword = !_isHiddenConfirmPassword;
    });
  }

  bool _isHiddenPassword = true;
  bool _isHiddenConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: secondaryColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const HeaderText(title: "Hello...", subtitle: "Register"),
            const SizedBox(height: 20),
            CustomTextField(
              controller: emailController,
              label: "Username/Email",
              hint: "example@email.com",
              icon: Icons.email_outlined,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              controller: courseController,
              label: "Course",
              hint: "course",
              icon: Icons.school_outlined,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              obscure: _isHiddenPassword,
              controller: passwordController,
              label: "Password",
              hint: "password",
              icon: Icons.lock_outline,
              suffixIcon: IconButton(onPressed: _tootlePasswordView,
               icon: Icon(_isHiddenPassword ? Icons.lock_outline : Icons.lock_clock_outlined)),
            ),
            const SizedBox(height: 20),
            CustomTextField(
              obscure: _isHiddenConfirmPassword,
              controller: confirmPasswordController,
              label: "Password Confirmation",
              hint: "password confirmation",
              icon: Icons.lock_outline,
              suffixIcon: IconButton(onPressed: _tootleConfirmPasswordView,
              icon: Icon(_isHiddenConfirmPassword ? Icons.lock_outline : Icons.lock_clock_outlined)),
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: "Register",
              onPressed: _register,
              backgroundColor: Colors.blue,
              textColor: Colors.white,
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text("Already have an account?"),
                SizedBox(width: 5),
                Text(
                  "Login",
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
