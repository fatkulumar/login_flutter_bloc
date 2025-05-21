import 'package:flutter_application_2/models/response_model.dart';
import 'package:flutter_application_2/models/user/user_model.dart';
import 'package:flutter_application_2/services/auth/user/user_api.dart';

class UserRepository {
  final UserApi api;

  UserRepository({required this.api});

  Future<ResponseModel<UserModel>> getUser() {
    return api.getUser();
  }
}