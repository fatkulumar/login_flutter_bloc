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
        final categories =
            response.data?.data ??
            (response.singleData != null ? [response.singleData!] : []);

        final isSuccess = response.code == 200;
        final nextState =
            isSuccess
                ? CategoryLoaded(
                  code: response.code,
                  message: response.message,
                  success: response.success,
                  data: categories,
                )
                : CategoryFailure(
                  'Gagal mengambil data:\n${response.message} (code: ${response.code})',
                );

        emit(nextState);
      } catch (e) {
        emit(CategoryFailure('Terjadi Kesalahan Ketika Mengambil Data: $e'));
      }
    });

    on<AddCategory>((event, emit) async {
      final currentState =
          state is CategoryLoaded ? state as CategoryLoaded : null;

      try {
        final response = await categoryRepository.addCategory(event.name);

        if (response.singleData != null) {
          final newItem = response.singleData!;

          final updatedCategory =
              currentState != null
                  ? [
                    ...currentState.data.where((item) => item.id != newItem.id),
                    newItem,
                  ]
                  : [newItem];

          emit(
            CategoryUpdated(
              code: response.code,
              message: response.message,
              success: response.success,
              data: updatedCategory,
            ),
          );

          emit(
            CategoryLoaded(
              code: response.code,
              message: response.message,
              success: response.success,
              data: updatedCategory,
            ),
          );
        } else {
          final errors =
              response.errors?.values.expand((msgs) => msgs).join('\n') ??
              'Terjadi kesalahan';
          emit(CategoryFailure(errors));
          if (currentState != null) {
            emit(currentState);
          }
        }
      } catch (e) {
        emit(CategoryFailure('Terjadi Kesalahan Ketika Menambahkan Data: $e'));
        if (currentState != null) {
          emit(currentState);
        }
      }
    });

    on<UpdateCategory>((event, emit) async {
      final currentState =
          state is CategoryLoaded ? state as CategoryLoaded : null;

      try {
        final response = await categoryRepository.updateCategory(
          event.id,
          event.name,
        );

        if (response.singleData == null) {
          final errorText = (response.errors ?? {}).values
              .expand((e) => e)
              .join('\n');
          emit(CategoryFailure(errorText));
          if (currentState != null) emit(currentState);
          return;
        }

        final updatedCategory = response.singleData!;
        final updatedCategories =
            currentState != null
                ? currentState.data
                    .map(
                      (category) =>
                          category.id == updatedCategory.id
                              ? updatedCategory
                              : category,
                    )
                    .toList()
                : [updatedCategory];

        emit(
          CategoryUpdated(
            code: response.code,
            message: response.message,
            success: response.success,
            data: updatedCategories,
          ),
        );

        emit(
          CategoryLoaded(
            code: response.code,
            message: response.message,
            success: response.success,
            data: updatedCategories,
          ),
        );
      } catch (e) {
        emit(CategoryFailure('Terjadi Kesalahan: $e'));
        if (currentState != null) emit(currentState);
      }
    });

    on<DeleteCategory>((event, emit) async {
      final currentState =
          state is CategoryLoaded ? state as CategoryLoaded : null;

      try {
        final response = await categoryRepository.deleteCategory(event.id);

        if (response.success && response.code == 200) {
          if (currentState != null) {
            final updatedCategories =
                currentState.data
                    .where((category) => category.id != event.id)
                    .toList();

            emit(CategoryDeleted(response.message));
            emit(
              CategoryLoaded(
                code: response.code,
                message: response.message,
                success: true,
                data: updatedCategories,
              ),
            );
          }
        } else {
          emit(CategoryFailure(response.message));
          if (currentState != null) {
            emit(
              CategoryLoaded(
                code: currentState.code,
                message: "Reload Data Category",
                success: currentState.success,
                data: currentState.data,
              ),
            );
          }
        }
      } catch (e) {
        emit(CategoryFailure('Terjadi kesalahan saat menghapus data: $e'));
        if (currentState != null) {
          emit(
            CategoryLoaded(
              code: currentState.code,
              message: "Reload Data Category",
              success: currentState.success,
              data: currentState.data,
            ),
          );
        }
      }
    });
  }
}
