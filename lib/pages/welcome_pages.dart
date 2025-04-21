import 'package:flutter/material.dart';
import 'package:flutter_application_2/shared/shared.dart';
import 'package:flutter_application_2/pages/components/register_form_sheet.dart';
import 'package:flutter_application_2/pages/components/auth_button.dart';

class WelcomePages extends StatelessWidget {
  const WelcomePages({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: defaultMargin),
          children: [
            Image.asset(
              'assets/images/login-image.png',
              height: 333,
              fit: BoxFit.fill,
            ),
            SizedBox(height: 15),
            Text(
              "Welcome",
              style: dangerTextStyle,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 15),
            Text(
              "Welcome Welcome Welcome Welcome Welcome Welcome Welcome Welcome ",
              style: whiteTextStyle.copyWith(fontSize: 20),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
            SizedBox(height: 51),
            AuthButton(
                text: "Create Account",
                onPressed: () => showRegisterFormSheet(context),
                backgroundColor: secondaryColor,
                textColor: primaryColor,
              ),
            SizedBox(height: 15),
            AuthButton(
              text: "Login",
              onPressed: () => showRegisterFormSheet(context), // nanti diganti showLoginFormSheet
              backgroundColor: primaryColor,
              borderColor: secondaryColor,
              textColor: secondaryColor,
            ),
            SizedBox(height: 36),
            Text(
              'All Right Reserved @2025',
              style: whiteTextStyle.copyWith(
                color: secondaryColor,
                fontSize: 11,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: defaultMargin),
          ],
        ),
      ),
    );
  }
}
