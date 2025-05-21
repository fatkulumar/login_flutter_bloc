import 'dart:convert';
import 'package:flutter_application_2/models/response_model.dart';
import 'package:flutter_application_2/models/user/user_model.dart';
import 'package:flutter_application_2/utils/token_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class UserApi {
  final String _baseUrl;

  UserApi() : _baseUrl = dotenv.get('API_URL', fallback: 'http://localhost:8000');

  Uri _buildUrl(String path) {
    return Uri.parse('$_baseUrl$path');
  }

  Future<ResponseModel<UserModel>> getUser() async {
    final url = _buildUrl('/api/user');
    try {
      final token = await TokenStorage.getToken();
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return ResponseModel<UserModel>.fromJsonForSingle(
          jsonData,
          (json) => UserModel.fromJson(json),
        );
      } else {
        throw Exception('Failed to get data from api: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}