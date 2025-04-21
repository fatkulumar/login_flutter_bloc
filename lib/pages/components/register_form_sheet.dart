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
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: secondaryColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const HeaderText(title: "Hello...", subtitle: "Register"),
              const SizedBox(height: 20),
              const CustomTextField(
                label: "Username/Email",
                hint: "example@email.com",
                icon: Icons.email_outlined,
              ),
              const SizedBox(height: 20),
              const CustomTextField(
                label: "Course",
                hint: "course",
                icon: Icons.school_outlined,
              ),
              const SizedBox(height: 20),
              const CustomTextField(
                label: "Password",
                hint: "password",
                icon: Icons.lock_outline,
                obscure: true,
              ),
              const SizedBox(height: 20),
              const CustomTextField(
                label: "Password Confirmation",
                hint: "password confirmation",
                icon: Icons.lock_outline,
                obscure: true,
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: "Register",
                onPressed: () {
                  // TODO: tambahkan aksi register di sini
                },
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
    },
  );
}
