import 'package:flutter/material.dart';
import 'package:flutter_application_2/blocs/auth/forgot_password/bloc/forgot_password_bloc.dart';
import 'package:flutter_application_2/pages/components/login_form_sheet.dart';
import 'package:flutter_application_2/pages/widgets/custom_button.dart';
import 'package:flutter_application_2/pages/widgets/header_text.dart';
import 'package:flutter_application_2/pages/widgets/custom_text_field.dart';
import 'package:flutter_application_2/repositories/auth/forgot_password_repository.dart';
import 'package:flutter_application_2/services/auth/forgot_password_service.dart';
import 'package:flutter_application_2/shared/shared.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_2/pages/components/register_form_sheet.dart';

// Variabel Global
String cachedEmail = '';
String? cachedEmailError; 

void showForgotPasswordFormSheet(BuildContext context) {
  final ForgotPasswordService api = ForgotPasswordService();
  final forgotPasswordRepository = ForgotPasswordRepository(api: api);

  showModalBottomSheet(
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    context: context,
    builder:
        (context) => BlocProvider(
          create: (_) => ForgotPasswordBloc(forgotPasswordRepository),
          child: _ForgotPasswordFormSheet(
            initialEmail: cachedEmail,
            onValueChanged: (email) {
              cachedEmail = email;
            },
          ),
        ),
  );
}

class _ForgotPasswordFormSheet extends StatefulWidget {
  final String initialEmail;
  final void Function(String email)? onValueChanged;

  const _ForgotPasswordFormSheet({
    required this.initialEmail,
    required this.onValueChanged,
  });

  @override
  State<_ForgotPasswordFormSheet> createState() => _ForgotPasswordFormSheetState();
}

class _ForgotPasswordFormSheetState extends State<_ForgotPasswordFormSheet> {
  late TextEditingController emailController;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController(text: "fatkulumar@gmail.com");

    emailController.addListener(() {
      if (_emailError != null && emailController.text.isNotEmpty) {
        setState(() {
          _emailError = null;
           cachedEmailError = null;
        });
      }
    });
  }

  @override
  void dispose() {
    // Simpan data terakhir saat form ditutup
    widget.onValueChanged?.call(emailController.text);
    emailController.dispose();
    super.dispose();
  }

  void _forgotPasswordSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<ForgotPasswordBloc>().add(
        ForgotPassword(
          email: emailController.text,
        ),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Form belum valid')));
    }
  }

  String? _emailError;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
      listener: (context, state) {
        if (state is ForgotPasswordLoading) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder:
                (context) => const Center(child: CircularProgressIndicator()),
          );
        } else if (state is ForgotPasswordSuccess) {
          // Reset data global setelah login berhasil
          setState(() {
            cachedEmail = ''; // Reset email yang tersimpan

            cachedEmailError = null;

            emailController.clear();
          });

          // Tutup loading dialog dan BottomSheet
          Navigator.pop(context); // tutup loading dialog
          Navigator.pop(context); // tutup bottom sheet

          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        } else if (state is ForgotPasswordFailure) {
          Navigator.pop(context); // tutup loading
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        } else if (state is ForgotPasswordFailureWithFields) {
          setState(() {
            // Reset semua error dulu
            _emailError = null;
            // Cek apakah pesan mengandung error field
            _emailError = state.emailError;

            cachedEmailError = _emailError != null ? state.emailError : null;
          });
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
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(40),
              ),
            ),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const HeaderText(title: "Helo...", subtitle: "Forgot Password"),
                  const SizedBox(height: 20),
                  CustomTextField(
                    controller: emailController,
                    icon: Icons.email_outlined,
                    label: "Username/Email",
                    hint: "example@email.com",
                    errorText: cachedEmailError,
                    validator: (value) {
                      if (_emailError != null) return _emailError;
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
                  Row(
                    children: [
                      const Spacer(),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              showLoginFormSheet(context);
                            },
                            child: Text(
                              "Login?",
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
                    text: "Kirim",
                    onPressed: _forgotPasswordSubmit,
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
