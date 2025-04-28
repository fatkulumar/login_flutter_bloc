import 'package:flutter/material.dart';
import 'package:flutter_application_2/blocs/auth/bloc/login_bloc.dart';
import 'package:flutter_application_2/pages/widgets/custom_button.dart';
import 'package:flutter_application_2/pages/widgets/header_text.dart';
import 'package:flutter_application_2/pages/widgets/custom_text_field.dart';
import 'package:flutter_application_2/repositories/auth/login_repository.dart';
import 'package:flutter_application_2/services/auth/login_api.dart';
import 'package:flutter_application_2/shared/shared.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void showLoginFormSheet(BuildContext context) {
  final LoginApi api = LoginApi();
  final loginRepository = LoginRepository(api: api);
  showModalBottomSheet(
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    context: context,
    builder: (context) => BlocProvider(
      create: (_) => LoginBloc(loginRepository),
      child: const _LoginFormSheet(),
    ),
  );
}

class _LoginFormSheet extends StatefulWidget {
  const _LoginFormSheet(); // ← ini cara modern

  @override
  State<_LoginFormSheet> createState() => _LoginFormSheetState();
}

class _LoginFormSheetState extends State<_LoginFormSheet> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (_formKey.currentState?.validate() ?? false) {
      final email = emailController.text;
      final password = passwordController.text;

      context.read<LoginBloc>().add(LoginSubmitted(
        email: email,
        password: password,
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Form belum valid')),
      );
    }
  }

  void _tootlePasswordView() {
    setState(() {
      _isHiddenPassword = !_isHiddenPassword;
    });
  }

  bool _isHiddenPassword = true;
  bool _isChecked = false;

  final _formKey = GlobalKey<FormState>();

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
          Navigator.pop(context); // tutup loading
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
                    if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                        .hasMatch(value)) {
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
                    onPressed: _tootlePasswordView,
                    icon: Icon(_isHiddenPassword
                        ? Icons.lock_outline
                        : Icons.lock_open_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD7D7D7),
                        border: Border.all(color: primaryColor, width: 3),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Checkbox(
                        value: _isChecked,
                        onChanged: (value) {
                          setState(() {
                            _isChecked = value ?? false;
                          });
                        },
                        checkColor: const Color(0xFFD7D7D7),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      "Remember Me",
                      style: whiteTextStyle.copyWith(
                          color: primaryColor, fontSize: 12),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        print('Forgot password tapped');
                      },
                      child: Text(
                        "Forgot Password?",
                        style: whiteTextStyle.copyWith(
                            color: primaryColor, fontSize: 12),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                CustomButton(
                  text: "Login",
                  onPressed: _login,
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
                        print('Register tapped');
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
    );
  }
}
