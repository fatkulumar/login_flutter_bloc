import 'package:flutter/material.dart';
import 'package:flutter_application_2/blocs/auth/forgot_password/bloc/forgot_password_bloc.dart';
import 'package:flutter_application_2/blocs/auth/logout/bloc/logout_bloc.dart';
import 'package:flutter_application_2/blocs/user/bloc/user_bloc.dart';
import 'package:flutter_application_2/middleware/auth_checker.dart';
import 'package:flutter_application_2/repositories/auth/forgot_password_repository.dart';
import 'package:flutter_application_2/repositories/auth/logout_repository.dart';
import 'package:flutter_application_2/repositories/user/user_repository.dart';
import 'package:flutter_application_2/services/auth/forgot_password_service.dart';
import 'package:flutter_application_2/services/auth/logout_service.dart';
import 'package:flutter_application_2/services/auth/user/user_api.dart';
import 'package:flutter_application_2/utils/token_storage_util.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:flutter_application_2/blocs/auth/login/bloc/login_bloc.dart';
import 'package:flutter_application_2/blocs/category/bloc/category_bloc.dart';

import 'package:flutter_application_2/repositories/auth/login_repository.dart';
import 'package:flutter_application_2/repositories/category/category_repository.dart';

import 'package:flutter_application_2/services/auth/login_service.dart';
import 'package:flutter_application_2/services/category/category_service.dart';

import 'package:flutter_application_2/shared/color_pallet.dart';
import 'package:flutter_application_2/shared/shared.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: 'assets/.env');

  final token = await TokenStorageUtil.getToken(); // Ambil token dulu
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
          create: (_) => LoginBloc(LoginRepository(api: LoginService())),
        ),
        BlocProvider<CategoryBloc>(
          create:
              (_) => CategoryBloc(CategoryRepository(api: CategoryService())),
        ),
        BlocProvider<UserBloc>(
          create: (_) => UserBloc(UserRepository(api: UserApi())),
        ),
        BlocProvider<LogoutBloc>(
          create: (_) => LogoutBloc(LogoutRepository(api: LogoutService())),
        ),
        BlocProvider<ForgotPasswordBloc>(
          create: (_) => ForgotPasswordBloc(ForgotPasswordRepository(api: ForgotPasswordService())),
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
