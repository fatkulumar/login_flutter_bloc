import 'package:flutter_application_2/models/forgot_password_nodel.dart';
import 'package:flutter_application_2/models/response_model.dart';
import 'package:flutter_application_2/services/auth/forgot_password_service.dart';

class ForgotPasswordRepository {
  final ForgotPasswordService api;

  ForgotPasswordRepository({required this.api});

  Future<ResponseModel<ForgotPasswordModel>> forgotPassword(String email) {
    print('forgot repo');
    return api.forgotPassword(email);
  }
}
