part of 'category_bloc.dart';

@immutable
sealed class CategoryEvent {}

class LoadCategory extends CategoryEvent {}

class AddCategory extends CategoryEvent {
  final String name;

  AddCategory({required this.name});
}

class UpdateCategory extends CategoryEvent {
  final String id;
  final String name;

  UpdateCategory({required this.id, required this.name});
}

class DeleteCategory extends CategoryEvent {
  final String id;

  DeleteCategory({required this.id});
}