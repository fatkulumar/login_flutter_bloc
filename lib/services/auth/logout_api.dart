import 'dart:convert';
import 'package:flutter_application_2/models/response_model.dart';
import 'package:flutter_application_2/models/token_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class LogoutApi {
  final String _baseUrl;

  LogoutApi()
    : _baseUrl = dotenv.get('API_URL', fallback: 'http://localhost:8000');

  Uri _buildUrl(String path) {
    return Uri.parse('$_baseUrl$path');
  }
  
  Future<ResponseModel<TokenModel>> logout(token) async {
    final url = _buildUrl('/api/logout');
    print('masuk api 1');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({'_token': token}),
      );
print('masuk api 2');
print(token);
      final jsonData = json.decode(response.body);
      if (response.statusCode == 200) {
        return ResponseModel<TokenModel>.fromJsonForSingle(
          jsonData,
          (json) => TokenModel.fromJson(json),
        );
      } else {
        return ResponseModel<TokenModel>(
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
      return ResponseModel<TokenModel>(
        success: false,
        code: 500,
        message: 'Kesalahan koneksi atau data tidak valid.',
        singleData: null,
      );
    }
  }
}
