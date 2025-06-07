import 'package:flutter_application_2/models/category/category_model.dart';
import 'package:flutter_application_2/models/response_model.dart';
import 'package:flutter_application_2/services/category/category_service.dart';

class CategoryRepository {
  final CategoryService api;

  CategoryRepository({required this.api});

  Future<ResponseModel<CategoryModel>> getCategory() {
    return api.getCategory();
  }

  Future<ResponseModel<CategoryModel>> addCategory(
      String name) {
    return api.addCategory(name);
  }

  Future<ResponseModel<CategoryModel>> updateCategory(
      String id, String name) {
    return api.updateCategory(id, name);
  }

  Future<ResponseModel<CategoryModel>> deleteCategory(String id) {
    return api.deleteCategory(id);
  }
}