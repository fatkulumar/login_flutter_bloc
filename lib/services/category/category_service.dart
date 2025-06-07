import 'dart:convert';
import 'package:flutter_application_2/models/category/category_model.dart';
import 'package:flutter_application_2/models/response_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_application_2/utils/token_storage_util.dart';

class CategoryService {
  final String _baseUrl;

  CategoryService()
    : _baseUrl = dotenv.get('API_URL', fallback: 'http://localhost:8000');

  Uri _buildUrl(String path) {
    return Uri.parse('$_baseUrl$path');
  }

  Future<ResponseModel<CategoryModel>> getCategory() async {
    final url = _buildUrl('/api/category');
    try {
      final token = await TokenStorageUtil.getToken();
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final jsonData = json.decode(response.body);
      if (response.statusCode == 200) {
        return ResponseModel<CategoryModel>.fromJsonForDataModel(
          jsonData,
          (json) => CategoryModel.fromJson(json),
        );
      } else {
        return ResponseModel<CategoryModel>(
          success: jsonData['success'] ?? false,
          code: jsonData['code'] ?? response.statusCode,
          message: jsonData['message'] ?? 'Terjadi kesalahan',
          singleData: null,
          errors: null,
        );
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<ResponseModel<CategoryModel>> addCategory(String name) async {
    final url = _buildUrl('/api/category');
    try {
      final token = await TokenStorageUtil.getToken();
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({'name': name}),
      );

      final jsonData = json.decode(response.body);
      if (response.statusCode == 200) {
        return ResponseModel<CategoryModel>.fromJsonForSingle(
          jsonData,
          (json) => CategoryModel.fromJson(json),
        );
      } else {
        return ResponseModel<CategoryModel>(
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

  Future<ResponseModel<CategoryModel>> updateCategory(
    String id,
    String name,
  ) async {
    final url = _buildUrl('/api/category/$id');
    try {
      final token = await TokenStorageUtil.getToken();
      final response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({'id': id, 'name': name}),
      );
      final jsonData = json.decode(response.body);
      if (response.statusCode == 200) {
        return ResponseModel<CategoryModel>.fromJsonForSingle(
          jsonData,
          (json) => CategoryModel.fromJson(json),
        );
      } else {
        return ResponseModel<CategoryModel>(
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

  Future<ResponseModel<CategoryModel>> deleteCategory(String id) async {
    final token = await TokenStorageUtil.getToken();
    final url = _buildUrl('/api/category/$id');
    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({'id': id}),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return ResponseModel<CategoryModel>.fromJsonForSingle(
          jsonData,
          (json) => CategoryModel.fromJson(json),
        );
      } else {
        throw Exception('Failed to delete data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
