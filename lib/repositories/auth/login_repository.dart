import 'package:flutter_application_2/models/response_model.dart';
import 'package:flutter_application_2/models/token_model.dart';
import 'package:flutter_application_2/services/auth/login_service.dart';

class LoginRepository {
  final LoginService api;

  LoginRepository({required this.api});

  Future<ResponseModel<TokenModel>> login(String email, String password) {
    return api.login(email, password);
  }
}
