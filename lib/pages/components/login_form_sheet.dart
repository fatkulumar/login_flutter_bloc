import 'package:flutter/material.dart';
import 'package:flutter_application_2/blocs/auth/login/bloc/login_bloc.dart';
import 'package:flutter_application_2/pages/widgets/custom_button.dart';
import 'package:flutter_application_2/pages/widgets/header_text.dart';
import 'package:flutter_application_2/pages/widgets/custom_text_field.dart';
import 'package:flutter_application_2/repositories/auth/login_repository.dart';
import 'package:flutter_application_2/services/auth/login_api.dart';
import 'package:flutter_application_2/shared/shared.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_2/pages/components/register_form_sheet.dart';

// Variabel Global
String cachedEmail = '';
String cachedPassword = '';

void showLoginFormSheet(BuildContext context) {
  final LoginApi api = LoginApi();
  final loginRepository = LoginRepository(api: api);

  showModalBottomSheet(
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    context: context,
    builder: (context) => BlocProvider(
      create: (_) => LoginBloc(loginRepository),
      child: _LoginFormSheet(
        initialEmail: cachedEmail,
        initialPassword: cachedPassword,
        onValueChanged: (email, password) {
          cachedEmail = email;
          cachedPassword = password;
        },
      ),
    ),
  );
}

class _LoginFormSheet extends StatefulWidget {
  final String initialEmail;
  final String initialPassword;
  final void Function(String email, String password)? onValueChanged;

  const _LoginFormSheet({
    required this.initialEmail,
    required this.initialPassword,
    required this.onValueChanged,
  });

  @override
  State<_LoginFormSheet> createState() => _LoginFormSheetState();
}

class _LoginFormSheetState extends State<_LoginFormSheet> {
  late TextEditingController emailController;
  late TextEditingController passwordController;

  final _formKey = GlobalKey<FormState>();
  bool _isHiddenPassword = true;
  bool _isChecked = false;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController(text: widget.initialEmail);
    passwordController = TextEditingController(text: widget.initialPassword);
  }

  @override
  void dispose() {
    // Simpan data terakhir saat form ditutup
    widget.onValueChanged?.call(emailController.text, passwordController.text);
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _loginSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<LoginBloc>().add(
        LoginSubmitted(
          email: emailController.text,
          password: passwordController.text,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Form belum valid')),
      );
    }
  }

  void _togglePasswordView() {
    setState(() {
      _isHiddenPassword = !_isHiddenPassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginLoading) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => const Center(child: CircularProgressIndicator()),
          );
        } else if (state is LoginSuccess) {
          // Reset data global setelah login berhasil
          setState(() {
            cachedEmail = ''; // Reset email yang tersimpan
            cachedPassword = ''; // Reset password yang tersimpan

            emailController.clear();
            passwordController.clear();
          });

          // Tutup loading dialog dan BottomSheet
          Navigator.pop(context); // tutup loading dialog
          Navigator.pop(context); // tutup bottom sheet

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        } else if (state is LoginFailure) {
          Navigator.pop(context); // tutup loading
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: secondaryColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
            ),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const HeaderText(title: "Welcome Back", subtitle: "Login"),
                  const SizedBox(height: 20),
                  CustomTextField(
                    controller: emailController,
                    label: "Username/Email",
                    hint: "example@email.com",
                    icon: Icons.email_outlined,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email tidak boleh kosong';
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Format email tidak valid';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    obscure: _isHiddenPassword,
                    controller: passwordController,
                    label: "Password",
                    hint: "password",
                    icon: Icons.lock_outline,
                    suffixIcon: IconButton(
                      onPressed: _togglePasswordView,
                      icon: Icon(
                        _isHiddenPassword
                            ? Icons.lock_outline
                            : Icons.lock_open_outlined,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password tidak boleh kosong';
                      }

                      final passwordRegex = RegExp(
                        r'^(?=.*[A-Z])(?=.*\d)(?=.*[!@#\$&*~])[A-Za-z\d!@#\$&*~]{8,}$',
                      );
                      if (!passwordRegex.hasMatch(value)) {
                        return 'Password minimal 8 karakter,\n'
                            'mengandung huruf kapital, angka, dan simbol (!@#\$&*~)';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Checkbox(
                        value: _isChecked,
                        onChanged: (value) {
                          setState(() {
                            _isChecked = value ?? false;
                          });
                        },
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Wrap(
                          children: [
                            Text(
                              "Remember Me",
                              style: whiteTextStyle.copyWith(
                                color: primaryColor,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              print('Forgot password tapped');
                            },
                            child: Text(
                              "Forgot Password?",
                              style: whiteTextStyle.copyWith(
                                color: primaryColor,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  CustomButton(
                    text: "Login",
                    onPressed: _loginSubmit,
                    backgroundColor: Colors.blue,
                    textColor: Colors.white,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?"),
                      const SizedBox(width: 5),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          showRegisterFormSheet(context);
                        },
                        child: const Text(
                          "Register",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
