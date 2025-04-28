import 'package:flutter/material.dart';
import 'package:flutter_application_2/blocs/auth/bloc/login_bloc.dart';
import 'package:flutter_application_2/pages/welcome_pages.dart';
import 'package:flutter_application_2/repositories/auth/login_repository.dart';
import 'package:flutter_application_2/services/auth/login_api.dart';
import 'package:flutter_application_2/shared/color_pallet.dart';
import 'package:flutter_application_2/shared/shared.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: 'assets/.env');
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginBloc(LoginRepository(api: LoginApi())),
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: ColorPallet.purpleColor,
          primaryColor: primaryColor,
          canvasColor: Colors.transparent,
        ),
        home: WelcomePages(),
      ),
    );
  }
}
