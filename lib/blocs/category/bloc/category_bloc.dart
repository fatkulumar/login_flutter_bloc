import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/category/category_model.dart';
import 'package:flutter_application_2/repositories/category/category_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepository categoryRepository;
  CategoryBloc(this.categoryRepository) : super(CategoryInitial()) {
    on<LoadCategory>((event, emit) async {
      emit(CategoryLoading());
      try {
        final response = await categoryRepository.getCategory();
         final categories = response.data?.data ??
            (response.singleData != null ? [response.singleData!] : []);
        if (response.code == 200) {
          emit(
            CategoryLoaded(
              code: response.code,
              message: response.message,
              success: response.success,
              data: categories
            )
          );
        }
     } catch (e) {
        emit(CategoryFailure('Failed Get Data Category: $e'));
      }
    });
  }
}
