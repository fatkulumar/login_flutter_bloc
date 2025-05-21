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
        if (response.code == 200) {
          emit(
            CategoryLoaded(
              code: response.code,
              message: response.message,
              success: response.success,
              data: categories,
            ),
          );
        }
      } catch (e) {
        emit(CategoryFailure('Failed get data: $e'));
      }
    });

    on<AddCategory>((event, emit) async {
      try {
        final response = await categoryRepository.addCategory(event.name);
        if (response.singleData != null) {
          final newItem = response.singleData!;
          if (state is CategoryLoaded) {
            final currentState = state as CategoryLoaded;

            // Salin data lama, hapus jika sudah ada (hindari duplikat), lalu tambahkan di akhir
            final updatedCategory =
                List<CategoryModel>.from(currentState.data)
                  ..removeWhere((item) => item.id == newItem.id)
                  ..add(newItem);

            emit(
              CategoryLoaded(
                code: response.code,
                message: response.message,
                success: response.success,
                data: updatedCategory,
              ),
            );
          } else {
            // Kalau state sebelumnya bukan CategoryLoaded, kita anggap baru dan emit list 1 user
            emit(
              CategoryLoaded(
                code: response.code,
                message: response.message,
                success: response.success,
                data: [response.singleData!],
              ),
            );
          }
        } else {
          emit(CategoryFailure('Tidak ada data yang ditambahkan.'));
        }
      } catch (e) {
        emit(CategoryFailure('Gagal menambahkan data: $e'));
      }
    });

    on<UpdateCategory>((event, emit) async {
      try {
        final response = await categoryRepository.updateCategory(
          event.id,
          event.name,
        );

        if (response.singleData == null) {
          emit(CategoryFailure('Data gagal diupdate.'));
          return;
        }

        final updatedCategory = response.singleData!;

        if (state is CategoryLoaded) {
          final currentState = state as CategoryLoaded;

          final updatedCategories =
              currentState.data.map((category) {
                return category.id == updatedCategory.id
                    ? updatedCategory
                    : category;
              }).toList();

          emit(
            CategoryLoaded(
              code: response.code,
              message: response.message,
              success: response.success,
              data: updatedCategories,
            ),
          );
        } else {
          // fallback: jika sebelumnya bukan CategoryLoaded
          emit(
            CategoryLoaded(
              code: response.code,
              message: response.message,
              success: response.success,
              data: [updatedCategory],
            ),
          );
        }
      } catch (e) {
        emit(CategoryFailure('Gagal update data: $e'));
      }
    });

    on<DeleteCategory>((event, emit) async {
      try {
        final response = await categoryRepository.deleteCategory(event.id);

        if (response.success && response.code == 200) {
          if (state is CategoryLoaded) {
            final currentState = state as CategoryLoaded;

            final updatedCategory =
                currentState.data
                    .where((category) => category.id != event.id)
                    .toList();

            emit(CategoryDeleted(response.message));
            // Emit hanya 1 state yang sudah diupdate
            emit(
              CategoryLoaded(
                code: response.code,
                message: response.message,
                success: true,
                data: updatedCategory,
              ),
            );
          }
        } else {
          emit(CategoryFailure(response.message));
        }
      } catch (e) {
        emit(CategoryFailure('Terjadi kesalahan saat menghapus data: $e'));
      }
    });
  }
}
