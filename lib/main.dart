import 'package:flutter/material.dart';
import 'package:flutter_application_2/blocs/user/bloc/user_bloc.dart';
import 'package:flutter_application_2/middleware/auth_checker.dart';
import 'package:flutter_application_2/repositories/user/user_repository.dart';
import 'package:flutter_application_2/services/auth/user/user_api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:flutter_application_2/blocs/auth/login/bloc/login_bloc.dart';
import 'package:flutter_application_2/blocs/category/bloc/category_bloc.dart';

import 'package:flutter_application_2/pages/home.dart';
import 'package:flutter_application_2/pages/welcome_pages.dart';

import 'package:flutter_application_2/repositories/auth/login_repository.dart';
import 'package:flutter_application_2/repositories/category/category_repository.dart';

import 'package:flutter_application_2/services/auth/login_api.dart';
import 'package:flutter_application_2/services/category/category_api.dart';

import 'package:flutter_application_2/shared/color_pallet.dart';
import 'package:flutter_application_2/shared/shared.dart';
import 'package:flutter_application_2/utils/token_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: 'assets/.env');

  final token = await TokenStorage.getToken(); // Ambil token dulu
  runApp(MainApp(token: token));
}

class MainApp extends StatelessWidget {
  final String? token;
  const MainApp({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(
          create: (_) => LoginBloc(LoginRepository(api: LoginApi())),
        ),
        BlocProvider<CategoryBloc>(
          create: (_) => CategoryBloc(CategoryRepository(api: CategoryApi())),
        ),
        BlocProvider<UserBloc>(
          create: (_) => UserBloc(UserRepository(api: UserApi())),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: ColorPallet.purpleColor,
          primaryColor: primaryColor,
          canvasColor: Colors.transparent,
        ),
        home: AuthChecker(),
      ),
    );
  }
}
