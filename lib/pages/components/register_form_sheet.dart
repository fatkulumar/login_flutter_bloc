import 'package:flutter/material.dart';
import 'package:flutter_application_2/blocs/auth/register/bloc/register_bloc.dart';
import 'package:flutter_application_2/pages/widgets/custom_button.dart';
import 'package:flutter_application_2/pages/widgets/header_text.dart';
import 'package:flutter_application_2/pages/widgets/custom_text_field.dart';
import 'package:flutter_application_2/repositories/auth/register_repository.dart';
import 'package:flutter_application_2/services/auth/register_api.dart';
import 'package:flutter_application_2/shared/shared.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

String cachedEmail = '';
String cachedName = '';
String cachedPassword = '';
String cachedPasswordConfirmation = '';

void showRegisterFormSheet(BuildContext context) {
  final registerRepository = RegisterRepository(api: RegisterApi());

  showModalBottomSheet(
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    context: context,
    builder:
        (context) => BlocProvider(
          create: (context) => RegisterBloc(registerRepository),
          child: _RegisterFormSheet(
            initialEmail: cachedEmail,
            initialName: cachedName,
            initialPassword: cachedPassword,
            initialPasswordConfirmation: cachedPasswordConfirmation,
            onValueChanged: (email, name, password, passwordConfimation) {
              cachedEmail = email;
              cachedName = name;
              cachedPassword = password;
              cachedPasswordConfirmation = passwordConfimation;
            },
          ),
        ),
  );
}

class _RegisterFormSheet extends StatefulWidget {
  final String initialEmail;
  final String initialName;
  final String initialPassword;
  final String initialPasswordConfirmation;
  final Function(
    String email,
    String name,
    String password,
    String passwordConfimation,
  )
  onValueChanged;

  const _RegisterFormSheet({
    required this.initialEmail,
    required this.initialName,
    required this.initialPassword,
    required this.initialPasswordConfirmation,
    required this.onValueChanged,
  });

  @override
  State<_RegisterFormSheet> createState() => _RegisterFormSheetState();
}

class _RegisterFormSheetState extends State<_RegisterFormSheet> {
  late TextEditingController emailController;
  late TextEditingController nameController;
  late TextEditingController passwordController;
  late TextEditingController passwordConfirmationController;

  bool _isHiddenPassword = true;
  bool _isHiddenPasswordConfirmation = true;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController(text: widget.initialEmail);
    nameController = TextEditingController(text: widget.initialName);
    passwordController = TextEditingController(text: widget.initialPassword);
    passwordConfirmationController = TextEditingController(
      text: widget.initialPasswordConfirmation,
    );
  }

  @override
  void dispose() {
    widget.onValueChanged(
      emailController.text,
      nameController.text,
      passwordController.text,
      passwordConfirmationController.text,
    );
    emailController.dispose();
    nameController.dispose();
    passwordController.dispose();
    passwordConfirmationController.dispose();
    super.dispose();
  }

  void _registerSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<RegisterBloc>().add(RegisterSubmitted(
        email: emailController.text,
        name: nameController.text,
        password: passwordController.text,
        passwordConfimation: passwordConfirmationController.text
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text('Form Tidak Valid')));
    }
  }

  void _togglePasswordView() {
    setState(() {
      _isHiddenPassword = !_isHiddenPassword;
    });
  }

  void _togglePasswordConfirmationView() {
    setState(() {
      _isHiddenPasswordConfirmation = !_isHiddenPasswordConfirmation;
    });
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state is RegisterLoading) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => const Center(child: CircularProgressIndicator(),));
        } else if (state is RegisterSuccess) {
          cachedEmail = "";
          cachedName = "";
          cachedPassword = "";
          cachedPasswordConfirmation = "";
          Navigator.pop(context);
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
        } else if (state is RegisterFailure) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
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
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
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
                    controller: nameController,
                    label: "Nama",
                    hint: "Nama",
                    icon: Icons.school_outlined,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nama Tidak Boleh Kosong';
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
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password tidak boleh kosong';
                      }

                      final passwordRegex = RegExp(r'^(?=.*[A-Z])(?=.*\d)(?=.*[!@#\$&*~])[A-Za-z\d!@#\$&*~]{8,}$');
                      if (!passwordRegex.hasMatch(value)) {
                        return 'Password minimal 8 karakter,\n'
                              'mengandung huruf kapital, angka, dan simbol (!@#\$&*~)';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    obscure: _isHiddenPasswordConfirmation,
                    controller: passwordConfirmationController,
                    label: "Password Confirmation",
                    hint: "password confirmation",
                    icon: Icons.lock_outline,
                    suffixIcon: IconButton(
                      onPressed: _togglePasswordConfirmationView,
                      icon: Icon(
                        _isHiddenPasswordConfirmation
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password Confirmation Tidak Boleh Kosong';
                      }
                      if (value != passwordController.text) {
                        return 'Password dan Password Confirmation Tidak Cocok';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomButton(
                    text: "Register",
                    onPressed: _registerSubmit,
                    backgroundColor: Colors.blue,
                    textColor: Colors.white,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text("Already have an account?"),
                      SizedBox(width: 5),
                      Text("Login", style: TextStyle(color: Colors.red)),
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
