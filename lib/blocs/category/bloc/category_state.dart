part of 'category_bloc.dart';

@immutable
sealed class CategoryState {}

final class CategoryInitial extends CategoryState {}
final class CategoryLoading extends CategoryState {}
final class CategoryLoaded extends CategoryState {
  final bool success;
  final int code;
  final String message;
  final List<CategoryModel> data;

  CategoryLoaded({
    required this.success,
    required this.code,
    required this.message,
    required this.data
  });
}

final class CategoryFailure extends CategoryState {
  final String message;
  CategoryFailure(this.message);
}

final class CategoryDeleted extends CategoryState {
  final String message;
  CategoryDeleted(this.message);
}
