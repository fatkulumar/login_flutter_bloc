import 'package:flutter_application_2/models/response_model.dart';
import 'package:flutter_application_2/models/token_model.dart';
import 'package:flutter_application_2/services/auth/login_api.dart';

class LoginRepository {
  final LoginApi api;

  LoginRepository({required this.api});

   Future<ResponseModel<TokenModel>> login(String email, String password) {
    return api.login(email, password);
  }
}