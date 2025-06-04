import 'package:flutter_application_2/models/response_model.dart';
import 'package:flutter_application_2/models/token_model.dart';
import 'package:flutter_application_2/services/auth/logout_api.dart';

class LogoutRepository {
  final LogoutApi api;

  LogoutRepository({required this.api});

  Future<ResponseModel<TokenModel>> logout(token) {
    return api.logout(token);
  }
}