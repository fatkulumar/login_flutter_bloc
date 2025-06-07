import 'dart:convert';
import 'package:flutter_application_2/models/response_model.dart';
import 'package:flutter_application_2/models/token_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class RegisterService {
  final String _baseUrl;

  RegisterService() : _baseUrl = dotenv.get('API_URL', fallback: 'http://localhost:8000');

  Uri _buildUrl(String path) {
    return Uri.parse('$_baseUrl$path');
  }

  Future<ResponseModel<TokenModel>> register(String email, String name, String password, String passwordConfirmation) async {
    final url = _buildUrl('/api/register');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'email': email,
          'name': name,
          'password': password,
          'password_confirmation': passwordConfirmation,
        }),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return ResponseModel<TokenModel>.fromJsonForSingle(
          jsonData,
          (json) => TokenModel.fromJson(json),
        );
      } else {
        throw Exception('Failed to login user: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}