import 'package:flutter_application_2/models/category/category_model.dart';
import 'package:flutter_application_2/models/response_model.dart';
import 'package:flutter_application_2/services/category/category_api.dart';

class CategoryRepository {
  final CategoryApi api;

  CategoryRepository({required this.api});

  Future<ResponseModel<CategoryModel>> getCategory() {
    return api.getCategory();
  }
}