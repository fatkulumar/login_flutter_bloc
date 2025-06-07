import 'package:flutter_application_2/models/response_model.dart';
import 'package:flutter_application_2/models/token_model.dart';
import 'package:flutter_application_2/services/auth/register_service.dart';

class RegisterRepository {
  final RegisterService api;

  RegisterRepository({required this.api});

   Future<ResponseModel<TokenModel>> register(String email, String name, String password, String passwordConfirmation) {
    return api.register(email, name, password, passwordConfirmation);
  }
}