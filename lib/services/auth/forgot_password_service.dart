import 'dart:convert';
import 'package:flutter_application_2/models/forgot_password_nodel.dart';
import 'package:flutter_application_2/models/response_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ForgotPasswordService {
  final String _baseUrl;

  ForgotPasswordService() : _baseUrl = dotenv.get('API_URL', fallback: 'http://localhost:8000');

  Uri _buildUrl(String path) {
    return Uri.parse('$_baseUrl$path');
  }

  Future<ResponseModel<ForgotPasswordModel>> forgotPassword(String email) async {
    print('forgot service');

    final url = _buildUrl('/api/forgot-password');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'email': email
        }),
      );

      final jsonData = json.decode(response.body);
      if (response.statusCode == 200) {
        return ResponseModel<ForgotPasswordModel>.fromJsonForSingle(
          jsonData,
          (json) => ForgotPasswordModel.fromJson(json),
        );
      } else {
        return ResponseModel<ForgotPasswordModel>(
          success: jsonData['status'] ?? false,
          code: jsonData['code'] ?? response.statusCode,
          message: jsonData['message'] ?? 'Terjadi kesalahan',
          singleData: null,
          errors:
              jsonData['data'] is Map<String, dynamic>
                  ? (jsonData['data'] as Map<String, dynamic>).map(
                    (key, value) => MapEntry(key, List<String>.from(value)),
                  )
                  : null,
        );
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}